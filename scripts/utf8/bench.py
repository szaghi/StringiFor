#!/usr/bin/env python3
"""Compare two benchmark runs of the UTF-8 work (issue #51, step 0.3, design rule R5).

Usage: bench.py compare BASELINE.csv NEW.csv [--tolerance PERCENT] [--input ascii]
       bench.py merge RUN.csv [RUN.csv ...]      best (minimum) of each timing over runs, CSV to stdout

The CSV files are written by scripts/bench.sh (lines starting with "#" are metadata). Every timing of the chosen input
(default ascii, as R5 requires) in NEW is compared with the same method and size in BASELINE: the comparison fails when
NEW is slower than BASELINE by more than the tolerance (default 5%). Timings below 1e-7 s are reported but never fail:
at that scale the clock and the loop overhead dominate.
"""

from __future__ import annotations

import argparse
import csv
import sys
from pathlib import Path

FLOOR = 1e-7  # timings below this (s) never fail


def load(path: Path) -> dict[tuple[str, str, int], float]:
    """Read a run: (method, input, bytes) -> seconds per call."""
    lines = [
        line
        for line in path.read_text(encoding="ascii").splitlines()
        if not line.startswith("#")
    ]
    return {
        (row["method"], row["input"], int(row["bytes"])): float(row["seconds"])
        for row in csv.DictReader(lines)
    }


def merge(runs: list[Path]) -> None:
    """Print the minimum of each timing over runs, with the metadata of the first run."""
    meta = [
        line
        for line in runs[0].read_text(encoding="ascii").splitlines()
        if line.startswith("#")
    ]
    loaded = [load(run) for run in runs]
    print("\n".join(meta))
    print(f"# runs merged (minimum per timing): {len(runs)}")
    print("method,input,bytes,seconds")
    for key in loaded[0]:
        best = min(run[key] for run in loaded)
        print(f"{key[0]},{key[1]},{key[2]},{best:.5e}")


def compare(baseline: Path, new: Path, tolerance: float, input_name: str) -> int:
    """Print the ratios new/baseline and return 1 if any exceeds 1 + tolerance/100."""
    base, run = load(baseline), load(new)
    missing = sorted(key for key in base if key[1] == input_name and key not in run)
    failures = 0
    print(f"{'method':16s} {'bytes':>7s} {'baseline':>11s} {'new':>11s} {'ratio':>7s}")
    for key in sorted(k for k in base if k[1] == input_name and k in run):
        ratio = run[key] / base[key]
        slow = ratio > 1 + tolerance / 100 and base[key] >= FLOOR
        failures += slow
        flag = "  SLOWER" if slow else ""
        print(
            f"{key[0]:16s} {key[2]:7d} {base[key]:11.3e} {run[key]:11.3e} {ratio:7.3f}{flag}"
        )
    for key in missing:
        print(f"MISSING {key}")
    print(
        f"compare {input_name}: {failures} timing(s) slower than {tolerance}%, {len(missing)} missing"
    )
    return 1 if failures or missing else 0


def main() -> int:
    """Command line entry point."""
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    sub = parser.add_subparsers(dest="command", required=True)
    cmp = sub.add_parser("compare", help="compare a run with a baseline")
    cmp.add_argument("baseline", type=Path)
    cmp.add_argument("new", type=Path)
    cmp.add_argument("--tolerance", type=float, default=5.0, help="percent (default 5)")
    cmp.add_argument(
        "--input", default="ascii", help="input kind compared (default ascii)"
    )
    mrg = sub.add_parser("merge", help="minimum of each timing over runs")
    mrg.add_argument("runs", type=Path, nargs="+")
    args = parser.parse_args()
    if args.command == "merge":
        merge(args.runs)
        return 0
    return compare(args.baseline, args.new, args.tolerance, args.input)


if __name__ == "__main__":
    sys.exit(main())
