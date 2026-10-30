#!/usr/bin/env python3
"""Test corpus of byte strings for the UTF-8 work (issue #51, step 0.1).

Usage: corpus.py [--seed N] [--random N] [-o FILE]
       corpus.py --self-test

The corpus covers ASCII, the boundaries of the 2-, 3- and 4-byte UTF-8 sequences, every class of ill-formed input of
Unicode Table 3-7 (lone continuation bytes, invalid lead bytes, overlong forms, encoded surrogates, values above
U+10FFFF, truncated sequences), Latin-1 text, Latin-1 text that happens to be well-formed UTF-8, random mixes of all
of them and random binary data. It is deterministic: the same seed gives the same bytes.

Each line of the output is "CATEGORY<TAB>HEX", HEX being the bytes of the case in lowercase hexadecimal (empty for the
empty string), so the file is plain ASCII whatever the bytes are and any Fortran program can read it.

The module is also imported by the oracle and the benchmark generators: `cases` gives the corpus, `units` splits a
byte string into the units of design rule R3 (a well-formed sequence, or a single byte that is not part of one).
"""

from __future__ import annotations

import argparse
import random
import sys
from collections.abc import Iterator
from pathlib import Path

SEED = 51  # default seed (the issue number)
RANDOM = 200  # default number of random cases per random category


def utf8(*codepoints: int) -> bytes:
    """Return the UTF-8 encoding of scalar values (surrogates are not scalar values and raise)."""
    return "".join(chr(cp) for cp in codepoints).encode("utf-8")


# fixed cases: (category, well-formed, bytes)
FIXED: list[tuple[str, bool, bytes]] = [
    ("ascii", True, b""),
    ("ascii", True, b"a"),
    ("ascii", True, b" "),
    ("ascii", True, b"Hello, World!"),
    ("ascii", True, b"\x00"),
    ("ascii", True, b"a\x00b"),
    ("ascii", True, b"\t\n\r\x0b\x0c"),
    ("ascii", True, b"  padded  "),
    ("ascii", True, bytes(range(128))),
    ("valid2", True, utf8(0x80)),
    ("valid2", True, utf8(0xA0)),  # no-break space
    ("valid2", True, utf8(0xE9)),  # e acute
    ("valid2", True, utf8(0x3A3, 0x3C3, 0x3C2)),  # Greek sigma forms
    ("valid2", True, utf8(0x7FF)),
    ("valid3", True, utf8(0x800)),
    ("valid3", True, utf8(0x4F60, 0x597D)),  # CJK
    ("valid3", True, utf8(0xD7FF)),  # last before the surrogates
    ("valid3", True, utf8(0xE000)),  # first after the surrogates
    ("valid3", True, utf8(0xFEFF)),  # byte order mark
    ("valid3", True, utf8(0xFFFD)),  # replacement character
    ("valid3", True, utf8(0xFFFF)),  # noncharacter, still a scalar value
    ("valid3", True, utf8(0x65, 0x301)),  # e + combining acute accent
    ("valid4", True, utf8(0x10000)),
    ("valid4", True, utf8(0x1F600)),  # emoji
    ("valid4", True, utf8(0x10FFFF)),
    ("mixed", True, b"ab" + utf8(0x4F60, 0x597D, 0xE9)),
    ("mixed", True, utf8(0xE9) + b"=" + utf8(0x1F600) + b" x"),
    ("continuation", False, b"\x80"),
    ("continuation", False, b"\xbf"),
    ("continuation", False, b"a\x80b"),
    ("continuation", False, b"\x80\x80\x80\x80"),
    ("lead", False, b"\xc0\x80"),
    ("lead", False, b"\xc1\xbf"),
    ("lead", False, b"\xf5\x80\x80\x80"),
    ("lead", False, b"\xf8\x88\x80\x80\x80"),
    ("lead", False, b"\xfe"),
    ("lead", False, b"\xff"),
    ("overlong", False, b"\xc0\xaf"),  # '/'
    ("overlong", False, b"\xe0\x80\xaf"),  # '/'
    ("overlong", False, b"\xe0\x9f\xbf"),  # U+07FF in 3 bytes
    ("overlong", False, b"\xf0\x80\x80\xaf"),  # '/'
    ("overlong", False, b"\xf0\x8f\xbf\xbf"),  # U+FFFF in 4 bytes
    ("surrogate", False, b"\xed\xa0\x80"),  # U+D800
    ("surrogate", False, b"\xed\xbf\xbf"),  # U+DFFF
    ("surrogate", False, b"\xed\xa0\xbd\xed\xb8\x80"),  # CESU-8 pair of U+1F600
    ("above", False, b"\xf4\x90\x80\x80"),  # U+110000
    ("above", False, b"\xf7\xbf\xbf\xbf"),  # U+1FFFFF
    ("truncated", False, b"\xc3"),
    ("truncated", False, b"x\xe4\xbd"),
    ("truncated", False, b"\xe4\xbdx"),
    ("truncated", False, b"\xf0\x9f\x98"),
    ("truncated", False, b"\xf0\x9f\x98a\xf0\x9f"),
    ("latin1", False, "caf\xe9".encode("latin-1")),
    ("latin1", False, "na\xefve \xe0 la".encode("latin-1")),
    ("latin1", False, bytes(range(128, 256))),
    (
        "latin1-accidental",
        True,
        "\xc3\xa9".encode("latin-1"),
    ),  # Latin-1 'A tilde, copyright' = UTF-8 e acute
]

# pool of units the random cases are made of: (bytes, well-formed)
POOL: list[tuple[bytes, bool]] = [
    *((bytes([b]), True) for b in b"abcxyz XYZ019_-=.,\t"),
    *(
        (utf8(cp), True)
        for cp in (
            0x80,
            0xA0,
            0xE9,
            0x3C3,
            0x7FF,
            0x800,
            0x4F60,
            0xFEFF,
            0xFFFF,
            0x10000,
            0x1F600,
        )
    ),
    *((utf8(cp), True) for cp in (0x10FFFF, 0x301, 0x3000)),
    *(
        (b, False)
        for b in (
            b"\x80",
            b"\xbf",
            b"\xc0",
            b"\xc1",
            b"\xf5",
            b"\xff",
            b"\xc0\xaf",
            b"\xe0\x80\xaf",
            b"\xed\xa0\x80",
        )
    ),
    *((b, False) for b in (b"\xf4\x90\x80\x80", b"\xe4\xbd", b"\xf0\x9f\x98", b"\xe9")),
]


def cases(seed: int = SEED, n_random: int = RANDOM) -> Iterator[tuple[str, bytes]]:
    """Yield the corpus as (category, bytes), fixed cases first, then the random ones.

    Parameters
    ----------
    seed : int
        Seed of the random cases.
    n_random : int
        Number of cases of each random category.
    """
    for category, _, data in FIXED:
        yield category, data
    rng = random.Random(seed)
    for _ in range(n_random):  # mixes of units, well-formed ones only
        valid = [unit for unit, ok in POOL if ok]
        yield (
            "random-valid",
            b"".join(rng.choice(valid) for _ in range(rng.randint(0, 24))),
        )
    for _ in range(
        n_random
    ):  # mixes of all the units; adjacent units can form new sequences, as in real data
        yield (
            "random-mixed",
            b"".join(rng.choice(POOL)[0] for _ in range(rng.randint(0, 24))),
        )
    for _ in range(n_random):
        yield "random-binary", rng.randbytes(rng.randint(0, 32))


def units(data: bytes) -> list[bytes]:
    """Split bytes into the units of rule R3: a well-formed UTF-8 sequence, or one byte that is not part of one.

    The reference is Python's decoder with the surrogateescape handler, which maps every byte that is not part of a
    well-formed sequence (Unicode Table 3-7) to its own code U+DC80..U+DCFF.
    """
    result = []
    for char in data.decode("utf-8", "surrogateescape"):
        code = ord(char)
        result.append(
            bytes([code - 0xDC00]) if 0xDC80 <= code <= 0xDCFF else char.encode("utf-8")
        )
    return result


def is_well_formed(data: bytes) -> bool:
    """Return True if the bytes are well-formed UTF-8."""
    try:
        data.decode("utf-8", "strict")
    except UnicodeDecodeError:
        return False
    return True


def write(seed: int, n_random: int, out: Path | None) -> None:
    """Write the corpus, one "CATEGORY<TAB>HEX" line per case, to a file or the standard output."""
    text = "".join(
        f"{category}\t{data.hex()}\n" for category, data in cases(seed, n_random)
    )
    if out is None:
        sys.stdout.write(text)
    else:
        out.write_text(text, encoding="ascii")


def self_test() -> list[str]:
    """Check the corpus: return the list of failures (empty if it is sound)."""
    failures = []
    for category, ok, data in FIXED:
        if is_well_formed(data) != ok:
            failures.append(
                f"{category} {data.hex()}: declared well-formed={ok}, Python says {not ok}"
            )
        if b"".join(units(data)) != data:
            failures.append(
                f"{category} {data.hex()}: units do not concatenate back to the bytes"
            )
    for unit, ok in POOL:
        if is_well_formed(unit) != ok:
            failures.append(
                f"pool {unit.hex()}: declared well-formed={ok}, Python says {not ok}"
            )
    first, second = list(cases()), list(cases())
    if first != second:
        failures.append("two runs with the same seed differ")
    if list(cases(seed=SEED + 1)) == first:
        failures.append("a different seed gives the same corpus")
    categories = {category for category, _ in first}
    expected = {category for category, _, _ in FIXED} | {
        "random-valid",
        "random-mixed",
        "random-binary",
    }
    if categories != expected:
        failures.append(f"categories {sorted(categories)} != {sorted(expected)}")
    for category, data in first:
        if category == "random-valid" and not is_well_formed(data):
            failures.append(f"random-valid case {data.hex()} is ill-formed")
        if b"".join(units(data)) != data:
            failures.append(
                f"{category} {data.hex()}: units do not concatenate back to the bytes"
            )
    seen = set(b"".join(data for _, data in first))
    if seen != set(range(256)):
        failures.append(f"byte values never used: {sorted(set(range(256)) - seen)}")
    # spot checks of the unit split against hand-made expectations
    for data, expected_units in (
        (b"a\xc3\xa9b", [b"a", b"\xc3\xa9", b"b"]),
        (b"\xc0\xaf", [b"\xc0", b"\xaf"]),
        (b"x\xe4\xbd", [b"x", b"\xe4", b"\xbd"]),
        (b"\xed\xa0\x80", [b"\xed", b"\xa0", b"\x80"]),
        (b"\xf0\x9f\x98\x80", [b"\xf0\x9f\x98\x80"]),
    ):
        if units(data) != expected_units:
            failures.append(
                f"units({data.hex()}) = {units(data)}, expected {expected_units}"
            )
    return failures


def main() -> int:
    """Command line entry point."""
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument(
        "--seed",
        type=int,
        default=SEED,
        help=f"seed of the random cases (default {SEED})",
    )
    parser.add_argument(
        "--random",
        type=int,
        default=RANDOM,
        help=f"cases per random category (default {RANDOM})",
    )
    parser.add_argument(
        "-o", "--output", type=Path, help="output file (default: standard output)"
    )
    parser.add_argument(
        "--self-test", action="store_true", help="check the corpus and exit"
    )
    args = parser.parse_args()
    if args.self_test:
        failures = self_test()
        for failure in failures:
            print(f"FAIL {failure}", file=sys.stderr)
        n_cases = len(list(cases()))
        print(f"corpus self-test: {n_cases} cases, {len(failures)} failure(s)")
        return 1 if failures else 0
    write(args.seed, args.random, args.output)
    return 0


if __name__ == "__main__":
    sys.exit(main())
