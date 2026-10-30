#!/usr/bin/env python3
"""Generate the Unicode property tables of StringiFor from the Unicode Character Database (issue #51, step 0.4).

Usage: gen_unicode_tables.py [--version V] [--cache DIR] [-o FILE]   write the Fortran module
       gen_unicode_tables.py --check                                 fail if the committed module is not what the
                                                                     pinned UCD gives (byte-identical)
       gen_unicode_tables.py --check-driver PROGRAM                  run the check_tables driver and compare every
                                                                     codepoint 0..10FFFF with an independent parse

The UCD files are downloaded once into the cache (default build/utf8/ucd-VERSION, git-ignored) and verified against
the SHA-256 pinned below: a file that differs stops the generation. To move to another Unicode version, add its hashes
to PINNED (first download, then review the diff of the generated module) and change DEFAULT_VERSION.

Tables (sorted, disjoint, non-adjacent ranges of codepoints):
  WIDE_RANGES         East_Asian_Width W or F (EastAsianWidth.txt): two display columns
  ZERO_WIDTH_RANGES   General_Category Mn, Me or Cf except U+00AD (extracted/DerivedGeneralCategory.txt), plus the
                      Hangul jamo medial vowels and final consonants U+1160..U+11FF and U+D7B0..U+D7FF: no column
  WHITE_SPACE_RANGES  White_Space (PropList.txt)
"""

from __future__ import annotations

import argparse
import hashlib
import re
import subprocess
import sys
import tempfile
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
MODULE = ROOT / "src" / "lib" / "stringifor_unicode_tables.F90"
DEFAULT_VERSION = "17.0.0"
FILES = ("EastAsianWidth.txt", "extracted/DerivedGeneralCategory.txt", "PropList.txt")
PINNED = {  # version -> file -> SHA-256 (recorded at the first download, 2026-10-30)
    "17.0.0": {
        "EastAsianWidth.txt": "ea7ce50f3444a050333448dffef1cadd9325af55cbb764b4a2280faf52170a33",
        "extracted/DerivedGeneralCategory.txt": "d62e5bab70ca74f099343f71224fa051cb1fdd61a1ab45c0488c44cfc0b6102e",
        "PropList.txt": "130dcddcaadaf071008bdfce1e7743e04fdfbc910886f017d9f9ac931d8c64dd",
    },
}
HANGUL_JAMO_MEDIAL_FINAL = [(0x1160, 0x11FF), (0xD7B0, 0xD7FF)]
SOFT_HYPHEN = 0x00AD
TABLES = ("WIDE_RANGES", "ZERO_WIDTH_RANGES", "WHITE_SPACE_RANGES")


class UcdError(Exception):
    """A UCD file is missing, unreadable or differs from its pinned hash."""


def fetch(version: str, cache: Path) -> dict[str, str]:
    """Return the text of the UCD files, downloading them into the cache if needed and checking their hashes."""
    if version not in PINNED:
        raise UcdError(f"no pinned hashes for UCD {version}: add them to PINNED")
    texts = {}
    for name in FILES:
        path = cache / name
        if not path.exists():
            path.parent.mkdir(parents=True, exist_ok=True)
            url = f"https://www.unicode.org/Public/{version}/ucd/{name}"
            with urllib.request.urlopen(url, timeout=60) as response:  # noqa: S310 (fixed https URL)
                path.write_bytes(response.read())
        data = path.read_bytes()
        digest = hashlib.sha256(data).hexdigest()
        if digest != PINNED[version][name]:
            raise UcdError(
                f"{path}: SHA-256 {digest} differs from the pinned {PINNED[version][name]}"
            )
        texts[name] = data.decode("utf-8")
    return texts


def records(text: str) -> list[tuple[int, int, str]]:
    """Parse "FIRST[..LAST] ; VALUE # comment" lines into (first, last, value)."""
    result = []
    for line in text.splitlines():
        data = line.split("#", 1)[0].strip()
        if not data:
            continue
        span, value = (field.strip() for field in data.split(";", 1))
        first, _, last = span.partition("..")
        result.append((int(first, 16), int(last or first, 16), value))
    return result


def merge(ranges: list[tuple[int, int]]) -> list[tuple[int, int]]:
    """Sort ranges and merge the overlapping or adjacent ones."""
    merged: list[tuple[int, int]] = []
    for first, last in sorted(ranges):
        if merged and first <= merged[-1][1] + 1:
            merged[-1] = (merged[-1][0], max(merged[-1][1], last))
        else:
            merged.append((first, last))
    return merged


def subtract(ranges: list[tuple[int, int]], codepoint: int) -> list[tuple[int, int]]:
    """Remove one codepoint from merged ranges."""
    result = []
    for first, last in ranges:
        if first <= codepoint <= last:
            result.extend(
                r
                for r in ((first, codepoint - 1), (codepoint + 1, last))
                if r[0] <= r[1]
            )
        else:
            result.append((first, last))
    return result


def tables(texts: dict[str, str]) -> dict[str, list[tuple[int, int]]]:
    """Build the tables from the UCD texts."""
    wide = [
        (f, la) for f, la, v in records(texts["EastAsianWidth.txt"]) if v in ("W", "F")
    ]
    marks = [
        (f, la)
        for f, la, v in records(texts["extracted/DerivedGeneralCategory.txt"])
        if v in ("Mn", "Me", "Cf")
    ]
    zero = subtract(merge(marks + HANGUL_JAMO_MEDIAL_FINAL), SOFT_HYPHEN)
    space = [
        (f, la) for f, la, v in records(texts["PropList.txt"]) if v == "White_Space"
    ]
    return {
        "WIDE_RANGES": merge(wide),
        "ZERO_WIDTH_RANGES": merge(zero),
        "WHITE_SPACE_RANGES": merge(space),
    }


def fortran_table(name: str, ranges: list[tuple[int, int]], purpose: str) -> str:
    """Return the declaration of a table as a Fortran parameter, a range per column."""
    numbers = [str(value) for pair in ranges for value in pair]
    lines, line = [], "  "
    for i, number in enumerate(numbers):
        item = number + ("," if i < len(numbers) - 1 else "")
        if len(line) + len(item) + 1 > 112:
            lines.append(line.rstrip() + " &")
            line = "  "
        line += item + " "
    lines.append(line.rstrip() + "], [2, " + str(len(ranges)) + "])")
    head = f"integer(I4P), parameter :: {name}(1:2, 1:{len(ranges)}) = reshape([ &"
    return "\n".join([f"! {purpose}", head, *lines])


def module_text(version: str, built: dict[str, list[tuple[int, int]]]) -> str:
    """Return the Fortran module."""
    purposes = {
        "WIDE_RANGES": "East_Asian_Width W or F: two display columns.",
        "ZERO_WIDTH_RANGES": "Mn, Me, Cf (not U+00AD), Hangul jamo medial/final: no display column.",
        "WHITE_SPACE_RANGES": "White_Space property.",
    }
    parts = [
        "!< Unicode property tables of StringiFor, generated: do not edit.",
        "!<",
        f"!< Generated by scripts/utf8/gen_unicode_tables.py from the Unicode Character Database {version}",
        "!< (EastAsianWidth.txt, extracted/DerivedGeneralCategory.txt, PropList.txt). Each table is a sorted list of",
        "!< disjoint, non-adjacent ranges of codepoints, one column [first, last] per range; `in_ranges` searches one.",
        "module stringifor_unicode_tables",
        "!< Unicode property tables of StringiFor, generated: do not edit.",
        "use penf, only : I4P",
        "",
        "implicit none",
        "private",
        "public :: UCD_VERSION",
        *(f"public :: {name}" for name in TABLES),
        "public :: in_ranges",
        "",
        f"character(len=*), parameter :: UCD_VERSION = '{version}' !< Version of the Unicode Character Database.",
        *(fortran_table(name, built[name], purposes[name]) for name in TABLES),
        "",
        "contains",
        "   pure function in_ranges(codepoint, ranges) result(found)",
        "   !< Return true if the codepoint is in one of the ranges (binary search).",
        "   integer(I4P), intent(in) :: codepoint     !< Codepoint.",
        "   integer(I4P), intent(in) :: ranges(:,:)   !< Sorted disjoint ranges, one column [first, last] per range.",
        "   logical                  :: found         !< Result.",
        "   integer                  :: low           !< First candidate range.",
        "   integer                  :: high          !< Last candidate range.",
        "   integer                  :: middle        !< Range tested.",
        "",
        "   found = .false.",
        "   low = 1",
        "   high = size(ranges, dim=2)",
        "   do while (low <= high)",
        "      middle = (low + high) / 2",
        "      if (codepoint < ranges(1, middle)) then",
        "         high = middle - 1",
        "      elseif (codepoint > ranges(2, middle)) then",
        "         low = middle + 1",
        "      else",
        "         found = .true.",
        "         return",
        "      endif",
        "   enddo",
        "   endfunction in_ranges",
        "endmodule stringifor_unicode_tables",
    ]
    return "\n".join(parts) + "\n"


def naive_sets(texts: dict[str, str]) -> dict[str, set[int]]:
    """Codepoint sets of the tables by a separate, per-codepoint reading of the files (for --check-driver)."""
    pattern = re.compile(r"^([0-9A-F]{4,6})(?:\.\.([0-9A-F]{4,6}))?\s*;\s*(\w+)")

    def collect(text: str, values: set[str]) -> set[int]:
        found: set[int] = set()
        for line in text.splitlines():
            match = pattern.match(line)
            if match and match.group(3) in values:
                first = int(match.group(1), 16)
                found.update(
                    range(first, int(match.group(2) or match.group(1), 16) + 1)
                )
        return found

    zero = collect(texts["extracted/DerivedGeneralCategory.txt"], {"Mn", "Me", "Cf"})
    zero |= {
        cp for first, last in HANGUL_JAMO_MEDIAL_FINAL for cp in range(first, last + 1)
    }
    zero.discard(SOFT_HYPHEN)
    return {
        "WIDE_RANGES": collect(texts["EastAsianWidth.txt"], {"W", "F"}),
        "ZERO_WIDTH_RANGES": zero,
        "WHITE_SPACE_RANGES": collect(texts["PropList.txt"], {"White_Space"}),
    }


def check_driver(driver: Path, texts: dict[str, str]) -> int:
    """Compare the ranges the Fortran lookup finds over 0..10FFFF with the naive sets."""
    output = subprocess.run([driver], capture_output=True, text=True, check=True).stdout
    found: dict[str, set[int]] = {name: set() for name in TABLES}
    for line in output.splitlines():
        name, first, last = line.split()
        found[name].update(range(int(first), int(last) + 1))
    failures = 0
    for name, expected in naive_sets(texts).items():
        extra, missing = found[name] - expected, expected - found[name]
        status = "ok" if not extra and not missing else "MISMATCH"
        failures += status != "ok"
        print(
            f"{name:20s} {len(expected):7d} codepoints: {len(extra)} extra, {len(missing)} missing  {status}"
        )
    return 1 if failures else 0


def main() -> int:
    """Command line entry point."""
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument(
        "--version",
        default=DEFAULT_VERSION,
        help=f"UCD version (default {DEFAULT_VERSION})",
    )
    parser.add_argument(
        "--cache", type=Path, help="download cache (default build/utf8/ucd-VERSION)"
    )
    parser.add_argument(
        "-o", "--output", type=Path, default=MODULE, help="module file to write"
    )
    parser.add_argument(
        "--check", action="store_true", help="fail if the committed module differs"
    )
    parser.add_argument(
        "--check-driver", type=Path, help="check_tables program to verify"
    )
    args = parser.parse_args()
    cache = args.cache or ROOT / "build" / "utf8" / f"ucd-{args.version}"
    try:
        texts = fetch(args.version, cache)
    except (UcdError, OSError) as error:
        print(f"gen_unicode_tables: {error}", file=sys.stderr)
        return 1
    if args.check_driver:
        return check_driver(args.check_driver, texts)
    text = module_text(args.version, tables(texts))
    if args.check:
        same = MODULE.exists() and MODULE.read_text(encoding="ascii") == text
        if not same:
            with tempfile.NamedTemporaryFile(
                "w", suffix=".F90", delete=False, encoding="ascii"
            ) as tmp:
                tmp.write(text)
            print(
                f"gen_unicode_tables: {MODULE} differs from the generation (see {tmp.name})",
                file=sys.stderr,
            )
        else:
            print(f"gen_unicode_tables: {MODULE.name} matches UCD {args.version}")
        return 0 if same else 1
    args.output.write_text(text, encoding="ascii")
    print(f"gen_unicode_tables: wrote {args.output}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
