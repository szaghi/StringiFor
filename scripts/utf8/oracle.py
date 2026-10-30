#!/usr/bin/env python3
"""Oracle harness of the UTF-8 work (issue #51, step 0.2): check StringiFor methods against a Python reference.

Usage: oracle.py SUITE --driver PROGRAM [--work DIR] [--seed N] [--random N] [--self-test]
       oracle.py --list

For every byte string of the corpus (corpus.py) the harness generates calls of the methods of SUITE with arguments
drawn from the string itself (byte-level and unit-level substrings, so matches happen) and from a pool of units, writes
them to DIR/cases.txt, runs the Fortran driver (scripts/utf8/src/oracle_driver.f90) on them and compares each result
with the one the reference computes. The reference is Python's bytes semantics plus the deviations StringiFor documents
(each one is written next to its operation below, so the list of differences from Python is this file).

Protocol, one line per call, fields separated by a TAB:
  cases.txt    OP  ARG...         string arguments in hexadecimal, integers in decimal
  results.txt  RESULT             string: hexadecimal; integer: decimal; logical: T or F;
                                  list of strings: the items in hexadecimal separated by commas, "[]" if empty

With --self-test one result is corrupted before the comparison: the harness must report it (exit status 0 when it
does, 1 when the corruption goes unnoticed).

Suites:
  invariant   methods that are already correct on UTF-8 and must not change (design rule R4 of #51)
"""

from __future__ import annotations

import argparse
import random
import subprocess
import sys
from collections import Counter
from collections.abc import Callable
from dataclasses import dataclass
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from corpus import POOL, RANDOM, SEED, cases, units  # noqa: E402

Arg = bytes | int
Result = bytes | int | bool | list[bytes]


@dataclass(frozen=True)
class Op:
    """An operation of a suite: its name (as the driver knows it), its arguments generator and its reference."""

    name: str
    args: Callable[[bytes, random.Random], list[tuple[Arg, ...]]]
    reference: Callable[..., Result]


def substrings(data: bytes, rng: random.Random) -> list[bytes]:
    """Return search arguments for data: unit-aligned and byte-level substrings of it, and a unit of the pool."""
    found = []
    pieces = units(data)
    if pieces:
        first = rng.randrange(len(pieces))
        found.append(b"".join(pieces[first : first + rng.randint(1, 3)]))
    if data:
        first = rng.randrange(len(data))
        found.append(data[first : first + rng.randint(1, 3)])
    found.append(rng.choice(POOL)[0])
    return found


def nonempty_needles(data: bytes, rng: random.Random) -> list[tuple[Arg, ...]]:
    """Calls (data, needle) with non-empty needles."""
    return [(data, needle) for needle in substrings(data, rng)]


def any_needles(data: bytes, rng: random.Random) -> list[tuple[Arg, ...]]:
    """Calls (data, needle), the empty needle included."""
    return [*nonempty_needles(data, rng), (data, b"")]


def replacements(data: bytes, rng: random.Random) -> list[tuple[Arg, ...]]:
    """Calls (data, old, new), old empty included, new sometimes containing old."""
    calls: list[tuple[Arg, ...]] = []
    for old in [*substrings(data, rng), b""]:
        new = rng.choice([b"", rng.choice(POOL)[0], old + old, b"x" + old])
        calls.append((data, old, new))
    return calls


def counted_replacements(data: bytes, rng: random.Random) -> list[tuple[Arg, ...]]:
    """Calls (data, old, new, count) with count in -1..3."""
    return [
        (data, old, new, rng.randint(-1, 3))
        for data, old, new in replacements(data, rng)
    ]


def single(data: bytes, rng: random.Random) -> list[tuple[Arg, ...]]:
    """One call (data,)."""
    return [(data,)]


def pairs(data: bytes, rng: random.Random) -> list[tuple[Arg, ...]]:
    """Calls (data, other): another corpus-like string, a prefix of data, data with trailing blanks."""
    other = b"".join(rng.choice(POOL)[0] for _ in range(rng.randint(0, 4)))
    return [
        (data, other),
        (data, data[: rng.randint(0, len(data))]),
        (data, data + b"  "),
        (data, data),
    ]


def find(data: bytes, needle: bytes) -> int:
    """Fortran index: 1-based position of the first occurrence, 0 if none (the empty needle is found at 1)."""
    return data.find(needle) + 1


def rfind(data: bytes, needle: bytes) -> int:
    """Fortran index with back: the last occurrence (the empty needle is found at len+1)."""
    return data.rfind(needle) + 1


def count(data: bytes, needle: bytes) -> int:
    """Non-overlapping occurrences, as Python. Not defined by StringiFor for an empty needle: not generated."""
    return data.count(needle)


def count_overlapping(data: bytes, needle: bytes) -> int:
    """Overlapping occurrences."""
    return sum(data.startswith(needle, i) for i in range(len(data) - len(needle) + 1))


def replace(data: bytes, old: bytes, new: bytes) -> bytes:
    """Python replace; deviation documented by StringiFor: an empty old leaves the string unchanged."""
    return data if old == b"" else data.replace(old, new)


def replace_count(data: bytes, old: bytes, new: bytes, n: int) -> bytes:
    """Python replace of the first n occurrences; n <= 0 replaces none, an empty old leaves the string unchanged."""
    return data if old == b"" or n <= 0 else data.replace(old, new, n)


def split(data: bytes, sep: bytes) -> list[bytes]:
    """Python split with an explicit separator (StringiFor split with keep_empty=.true.)."""
    return data.split(sep)


def partition(data: bytes, sep: bytes) -> list[bytes]:
    """StringiFor 1.8.0 partition, pinned as it is (not Python's): see the owner decision in issue #51.

    It differs from Python's in two cases: when sep is absent the second part is sep, not empty; when sep is not
    shorter than the string no search is made, so 'a' partitioned at 'a' gives ('a', 'a', '') instead of
    ('', 'a', ''). Python's result is list(data.partition(sep)).
    """
    if len(sep) >= len(data) or sep not in data:
        return [data, sep, b""]
    return list(data.partition(sep))


def padded(left: bytes, right: bytes) -> tuple[bytes, bytes]:
    """Fortran comparison: the shorter operand is padded with blanks (deviation from Python, documented)."""
    width = max(len(left), len(right))
    return left.ljust(width), right.ljust(width)


SUITES: dict[str, list[Op]] = {
    "invariant": [
        Op("len", single, len),
        Op("index", any_needles, find),
        Op("index_back", any_needles, rfind),
        Op("count", nonempty_needles, count),
        Op("count_overlapping", nonempty_needles, count_overlapping),
        Op("replace", replacements, replace),
        Op("replace_count", counted_replacements, replace_count),
        Op("split", nonempty_needles, split),
        Op("partition", nonempty_needles, partition),
        Op("start_with", any_needles, lambda d, p: d.startswith(p)),
        Op("end_with", any_needles, lambda d, s: d.endswith(s)),
        Op("upper", single, bytes.upper),
        Op("lower", single, bytes.lower),
        Op("eq", pairs, lambda a, b: padded(a, b)[0] == padded(a, b)[1]),
        Op("lt", pairs, lambda a, b: padded(a, b)[0] < padded(a, b)[1]),
        Op("concat", pairs, lambda a, b: a + b),
    ],
}


# Results that are wrong because of a compiler, not of StringiFor: compiler -> [(reason, predicate)].
# They are counted and shown apart, never silently: remove an entry when the compiler is fixed.
KNOWN_COMPILER_ISSUES: dict[
    str, list[tuple[str, Callable[[str, tuple[Arg, ...]], bool]]]
] = {
    "nvfortran": [
        (
            "nvfortran 26.9: index(c, '') is 0 for a zero-length variable c (the standard "
            "gives 1), so start_with('', '') is false",
            lambda name, call: name == "start_with" and call == (b"", b""),
        ),
    ],
}


def known_issue(compiler: str, name: str, call: tuple[Arg, ...]) -> str | None:
    """Return the reason if the call hits a known compiler issue, None otherwise."""
    for reason, hit in KNOWN_COMPILER_ISSUES.get(compiler, []):
        if hit(name, call):
            return reason
    return None


def encode_arg(arg: Arg) -> str:
    """Encode an argument for cases.txt."""
    return str(arg) if isinstance(arg, int) else arg.hex()


def encode_result(result: Result) -> str:
    """Encode a result as the driver writes it."""
    if isinstance(result, bool):
        return "T" if result else "F"
    if isinstance(result, int):
        return str(result)
    if isinstance(result, list):
        return ",".join(item.hex() for item in result) if result else "[]"
    return result.hex()


def generate(suite: str, seed: int, n_random: int) -> list[tuple[str, tuple[Arg, ...]]]:
    """Return the calls of a suite over the corpus."""
    rng = random.Random(seed)
    calls = []
    for _, data in cases(seed, n_random):
        for op in SUITES[suite]:
            calls.extend((op.name, args) for args in op.args(data, rng))
    return calls


def run(args: argparse.Namespace) -> int:
    """Generate, run the driver, compare; return the exit status."""
    work: Path = args.work
    work.mkdir(parents=True, exist_ok=True)
    calls = generate(args.suite, args.seed, args.random)
    lines = [
        "\t".join([name, *(encode_arg(arg) for arg in call)]) for name, call in calls
    ]
    (work / "cases.txt").write_text(
        "".join(f"{line}\n" for line in lines), encoding="ascii"
    )
    with (
        (work / "cases.txt").open("rb") as cases_in,
        (work / "results.txt").open("wb") as results_out,
    ):
        status = subprocess.run(
            [args.driver], stdin=cases_in, stdout=results_out, check=False
        ).returncode
    if status != 0:
        print(f"oracle: the driver exited with status {status}", file=sys.stderr)
        return 1
    results = (work / "results.txt").read_text(encoding="ascii").splitlines()
    if args.self_test and results:
        results[len(results) // 2] += "0"
    if len(results) != len(calls):
        print(f"oracle: {len(calls)} calls, {len(results)} results", file=sys.stderr)
        return 1
    reference = {op.name: op.reference for op in SUITES[args.suite]}
    mismatches: Counter[str] = Counter()
    known: Counter[str] = Counter()
    per_op: Counter[str] = Counter(name for name, _ in calls)
    shown = 0
    for (name, call), got in zip(calls, results, strict=True):
        expected = encode_result(reference[name](*call))
        reason = known_issue(args.compiler, name, call) if got != expected else None
        if reason is not None:
            known[reason] += 1
        elif got != expected:
            mismatches[name] += 1
            if shown < args.show:
                shown += 1
                shown_args = " ".join(encode_arg(arg) or '""' for arg in call)
                print(
                    f"MISMATCH {name}({shown_args}): expected {expected or '""'}, got {got or '""'}"
                )
    for name in per_op:
        print(f"{name:20s} {per_op[name]:7d} calls {mismatches[name]:6d} mismatches")
    for reason, n in known.items():
        print(f"KNOWN COMPILER ISSUE ({n} calls): {reason}")
    total = sum(mismatches.values())
    print(
        f"oracle {args.suite}: {len(calls)} calls, {total} mismatch(es), "
        f"{sum(known.values())} known compiler issue(s)"
    )
    if args.self_test:
        print(
            "self-test: the corrupted result was "
            + ("detected" if total else "NOT detected")
        )
        return 0 if total else 1
    return 1 if total else 0


def main() -> int:
    """Command line entry point."""
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("suite", nargs="?", choices=sorted(SUITES), help="suite to run")
    parser.add_argument("--driver", type=Path, help="the Fortran driver program")
    parser.add_argument(
        "--work", type=Path, default=Path("build/utf8/oracle"), help="work directory"
    )
    parser.add_argument("--seed", type=int, default=SEED, help=f"seed (default {SEED})")
    parser.add_argument(
        "--random",
        type=int,
        default=RANDOM,
        help=f"random corpus cases per category ({RANDOM})",
    )
    parser.add_argument(
        "--compiler", default="", help="compiler of the driver, for its known issues"
    )
    parser.add_argument(
        "--show", type=int, default=20, help="mismatches shown at most (default 20)"
    )
    parser.add_argument(
        "--self-test",
        action="store_true",
        help="corrupt one result, require its detection",
    )
    parser.add_argument(
        "--list", action="store_true", help="list the suites and their operations"
    )
    args = parser.parse_args()
    if args.list:
        for suite, ops in SUITES.items():
            print(f"{suite}: {' '.join(op.name for op in ops)}")
        return 0
    if args.suite is None or args.driver is None:
        parser.error("SUITE and --driver are required")
    return run(args)


if __name__ == "__main__":
    sys.exit(main())
