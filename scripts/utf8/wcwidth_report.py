#!/usr/bin/env python3
"""Compare the display width of StringiFor with the Python wcwidth package (issue #51, Phase 5).

Usage: python wcwidth_report.py        (with wcwidth installed, e.g. in a venv: pip install wcwidth==0.9.4)

For every Unicode scalar value the width that StringiFor gives (its rules on the pinned UCD, the reference of the oracle
suite columns) is compared with wcwidth.wcwidth. The differences are grouped by (StringiFor, wcwidth) widths and by
General_Category of the pinned UCD, with a few examples each, as a Markdown table. It is a report, not a test: the two
follow different Unicode versions and wcwidth makes some choices of its own.
"""

from __future__ import annotations

import sys
from collections import defaultdict
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import gen_unicode_tables as ucd  # noqa: E402
import oracle  # noqa: E402

try:
    import wcwidth
except ImportError:
    sys.exit("wcwidth_report: the wcwidth package is needed (pip install wcwidth)")


def categories() -> dict[int, str]:
    """General_Category of every codepoint of the pinned UCD (Cn when unlisted)."""
    cache = ucd.ROOT / "build" / "utf8" / f"ucd-{ucd.DEFAULT_VERSION}"
    texts = ucd.fetch(ucd.DEFAULT_VERSION, cache)
    found = {}
    for first, last, value in ucd.records(
        texts["extracted/DerivedGeneralCategory.txt"]
    ):
        for code in range(first, last + 1):
            found[code] = value
    return found


def main() -> int:
    """Print the report."""
    category = categories()
    groups: dict[tuple[int, int, str], list[int]] = defaultdict(list)
    total = 0
    for code in range(0x110000):
        if 0xD800 <= code <= 0xDFFF:
            continue
        total += 1
        ours, theirs = oracle.unit_width(code), wcwidth.wcwidth(chr(code))
        if ours != theirs:
            groups[(ours, theirs, category.get(code, "Cn"))].append(code)
    print(
        f"StringiFor (UCD {ucd.DEFAULT_VERSION}) against wcwidth {wcwidth.__version__}: {total} scalar values, "
        f"{sum(len(v) for v in groups.values())} differ\n"
    )
    print("| StringiFor | wcwidth | General_Category | Codepoints | Examples |")
    print("|---|---|---|---|---|")
    for (ours, theirs, cat), codes in sorted(
        groups.items(), key=lambda item: -len(item[1])
    ):
        examples = ", ".join(f"U+{c:04X}" for c in codes[:4])
        print(f"| {ours} | {theirs} | {cat} | {len(codes)} | {examples} |")
    return 0


if __name__ == "__main__":
    sys.exit(main())
