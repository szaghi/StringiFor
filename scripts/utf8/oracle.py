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
  utf8        the UTF-8 core (Phase 1 of #51): is_utf8, utf8_error, codepoints, from_codepoints, to_valid_utf8; besides
              the corpus, every 2-byte string, every lead byte with boundary continuation bytes for 3- and 4-byte
              sequences, and the whole codespace through from_codepoints
  escape      the C escape codecs (Phase 2 of #51): escape_c, unescape_c, escapes_error and the round trip; the
              reference is checked first against Python's unicode_escape codec on the escapes both understand
  columns     display width (Phase 5 of #51): width and by=SF_COLUMNS; the reference applies the rules to the pinned
              UCD 17.0.0 read codepoint by codepoint (gen_unicode_tables.naive_sets), on every Unicode scalar value
  positions   positions and lengths in characters (Phase 4 of #51): by=SF_CHARS and byte_pos/char_pos; the reference
              converts the byte results with its own split of the bytes into units
  units       the methods that work on units (Phase 3 of #51): the reference is Python str on the bytes decoded with
              surrogateescape, so each byte that is not part of a well-formed sequence is one character (rule R3)
"""

from __future__ import annotations

import argparse
import codecs
import fnmatch
import random
import subprocess
import sys
from collections import Counter
from collections.abc import Callable
from dataclasses import dataclass
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from corpus import POOL, RANDOM, SEED, cases, units  # noqa: E402

_UCD_SETS: dict[str, set[int]] = {}

Arg = bytes | int | list[int]
Result = bytes | int | bool | list[bytes] | list[int]


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
    """Python partition (StringiFor follows it since 1.10.0)."""
    return list(data.partition(sep))


def collapse(data: bytes, sep: bytes) -> bytes:
    """Runs of consecutive separators reduced to one (StringiFor unique)."""
    out, i = [], 0
    while i < len(data):
        if data.startswith(sep, i):
            out.append(sep)
            i += len(sep)
            while data.startswith(sep, i):
                i += len(sep)
        else:
            out.append(data[i : i + 1])
            i += 1
    return b"".join(out)


def split_collapse(data: bytes, sep: bytes) -> list[bytes]:
    """StringiFor split without keep_empty, as documented and implemented in 1.8.0: separators collapsed; no
    separator gives the string itself; only separators give no token; a blank head or tail field is no token."""
    uniq = collapse(data, sep)
    if uniq.count(sep) == 0:
        return [data]
    if uniq == sep:
        return []
    fields = uniq.split(sep)
    head, inner, tail = fields[0], fields[1:-1], fields[-1]
    return (
        ([head] if head.strip(b" ") else [])
        + inner
        + ([tail] if tail.strip(b" ") else [])
    )


def occurrence(data: bytes, needle: bytes, n: int, back: bool) -> int:
    """Position of the n-th non-overlapping occurrence, counted from the left (from the right if back), 0 if none."""
    found, end, start = 0, len(data), 0
    for _ in range(n):
        found = data.rfind(needle, 0, end) if back else data.find(needle, start)
        if found < 0:
            return 0
        end, start = found, found + len(needle)
    return found + 1


def occurrences(data: bytes, rng: random.Random) -> list[tuple[Arg, ...]]:
    """Calls (data, needle, n) with non-empty needles and n in 1..3."""
    return [
        (data, needle, rng.randint(1, 3))
        for data, needle in nonempty_needles(data, rng)
    ]


def chunked(data: bytes, rng: random.Random) -> list[tuple[Arg, ...]]:
    """Calls (data, sep, chunks) with chunks in 1..4."""
    return [(data, sep, rng.randint(1, 4)) for data, sep in nonempty_needles(data, rng)]


def ranges(data: bytes, rng: random.Random) -> list[tuple[Arg, ...]]:
    """Calls (data, first, last) with 1 <= first <= last + 1 <= len + 1: substrings, the null one included."""
    calls: list[tuple[Arg, ...]] = []
    for _ in range(3):
        first = rng.randint(1, len(data) + 1)
        calls.append((data, first, rng.randint(first - 1, len(data))))
    return calls


def padded(left: bytes, right: bytes) -> tuple[bytes, bytes]:
    """Fortran comparison: the shorter operand is padded with blanks (deviation from Python, documented)."""
    width = max(len(left), len(right))
    return left.ljust(width), right.ljust(width)


def utf8_error(data: bytes) -> int:
    """Byte position (1-based) of the first byte that is not part of a well-formed sequence, 0 if none."""
    try:
        data.decode("utf-8", "strict")
    except UnicodeDecodeError as error:
        return error.start + 1
    return 0


def codepoints(data: bytes) -> list[int]:
    """Codepoints of the units; an ill-formed byte b is -b (Python's surrogateescape gives U+DC00+b)."""
    return [
        -(ord(char) - 0xDC00) if 0xDC80 <= ord(char) <= 0xDCFF else ord(char)
        for char in data.decode("utf-8", "surrogateescape")
    ]


def from_codepoints(codes: list[int]) -> bytes:
    """Inverse of codepoints: -255..-128 give the raw byte, non-scalar values give U+FFFD."""
    out = []
    for code in codes:
        if -255 <= code <= -128:
            out.append(bytes([-code]))
        elif 0 <= code <= 0x10FFFF and not 0xD800 <= code <= 0xDFFF:
            out.append(chr(code).encode("utf-8"))
        else:
            out.append("\ufffd".encode())
    return b"".join(out)


def to_valid_utf8(data: bytes, replacement: bytes = "\ufffd".encode()) -> bytes:
    """Each maximal subpart of an ill-formed sequence replaced, as Python's errors='replace' segments them."""
    out, start = [], 0
    while True:
        try:
            out.append(data[start:].decode("utf-8", "strict").encode("utf-8"))
            return b"".join(out)
        except UnicodeDecodeError as error:
            out.append(data[start : start + error.start] + replacement)
            start += error.end


def codepoint_lists(data: bytes, rng: random.Random) -> list[tuple[Arg, ...]]:
    """Calls (codes,): the codepoints of data (round trip) and values that are not scalar values."""
    invalid = [-1, -127, -256, 0xD800, 0xDFFF, 0x110000, 2**31 - 1, -(2**31) + 1]
    mixed = codepoints(data) + [rng.choice(invalid)]
    rng.shuffle(mixed)
    return [(codepoints(data),), (mixed,)]


def replacements_of(data: bytes, rng: random.Random) -> list[tuple[Arg, ...]]:
    """Calls (data, replacement) with an ASCII, an empty and a multibyte replacement."""
    return [(data, b"?"), (data, b""), (data, "\u2022".encode())]


BOUNDARY = [
    0x00,
    0x41,
    0x7F,
    0x80,
    0x8F,
    0x90,
    0x9F,
    0xA0,
    0xBF,
    0xC0,
    0xC2,
    0xF4,
    0xFF,
]


def utf8_exhaustive() -> list[tuple[str, tuple[Arg, ...]]]:
    """Every 2-byte string; every lead byte with boundary bytes after it; the codespace by blocks of 1024."""
    strings = [bytes([a, b]) for a in range(256) for b in range(256)]
    strings += [
        bytes([a, b, c]) for a in range(256) for b in BOUNDARY for c in BOUNDARY
    ]
    strings += [
        bytes([a, b, c, d])
        for a in range(0xF0, 0xF8)
        for b in BOUNDARY
        for c in BOUNDARY
        for d in BOUNDARY
    ]
    calls: list[tuple[str, tuple[Arg, ...]]] = []
    for data in strings:
        calls += [
            ("codepoints", (data,)),
            ("utf8_error", (data,)),
            ("to_valid_utf8", (data,)),
        ]
    calls += [
        ("from_codepoints", (list(range(first, first + 1024)),))
        for first in range(0, 0x110000, 1024)
    ]
    return calls


BS = b"\\"  # one backslash
SHORT = {
    b"\\": 92,
    b"'": 39,
    b'"': 34,
    b"a": 7,
    b"b": 8,
    b"f": 12,
    b"n": 10,
    b"r": 13,
    b"t": 9,
    b"v": 11,
    b"e": 27,
}
OCTAL, HEX = b"01234567", b"0123456789abcdefABCDEF"


def parse_escape(text: bytes, i: int) -> tuple[bytes, int]:
    """Parse the escape whose backslash is at i: (bytes it gives, its length), length 0 if malformed."""
    nxt = text[i + 1 : i + 2]
    if nxt in SHORT and nxt:
        return bytes([SHORT[nxt]]), 2
    if nxt and nxt in OCTAL:
        digits = 1
        while (
            digits < 3
            and text[i + 1 + digits : i + 2 + digits] not in (b"",)
            and text[i + 1 + digits] in OCTAL
        ):
            digits += 1
        value = int(text[i + 1 : i + 1 + digits], 8)
        return (bytes([value]), 1 + digits) if value <= 255 else (b"", 0)
    width = {b"x": 2, b"u": 4, b"U": 8}.get(nxt, 0)
    field = text[i + 2 : i + 2 + width]
    if width == 0 or len(field) != width or any(c not in HEX for c in field):
        return b"", 0
    value = int(field, 16)
    if nxt == b"x":
        return bytes([value]), 4
    if 0xD800 <= value <= 0xDFFF or value > 0x10FFFF:
        return b"", 0
    return chr(value).encode("utf-8"), 2 + width


def unescape_c(text: bytes) -> bytes:
    """Expand the C escapes; the backslash of a malformed escape is kept and the text after it read normally."""
    out, i = [], 0
    while i < len(text):
        if text[i : i + 1] == BS:
            value, n = parse_escape(text, i)
            if n:
                out.append(value)
                i += n
                continue
        out.append(text[i : i + 1])
        i += 1
    return b"".join(out)


def escapes_error(text: bytes) -> int:
    """Byte position (1-based) of the backslash of the first malformed escape, 0 if none."""
    i = 0
    while i < len(text):
        if text[i : i + 1] == BS:
            _, n = parse_escape(text, i)
            if n == 0:
                return i + 1
            i += n
        else:
            i += 1
    return 0


def escape_c(data: bytes, ascii_only: bool = True) -> bytes:
    """C escapes for what is not printable ASCII (or, ascii_only False, only for controls and ill-formed bytes)."""
    short = {
        92: b"\\\\",
        7: b"\\a",
        8: b"\\b",
        9: b"\\t",
        10: b"\\n",
        11: b"\\v",
        12: b"\\f",
        13: b"\\r",
    }
    out = []
    for code in codepoints(data):
        if code in short:
            out.append(short[code])
        elif code < 0:
            out.append(b"\\x%02x" % -code)
        elif code < 32 or code == 127:
            out.append(b"\\x%02x" % code)
        elif code < 127:
            out.append(bytes([code]))
        elif not ascii_only and code > 159:
            out.append(chr(code).encode("utf-8"))
        elif code <= 0xFFFF:
            out.append(b"\\u%04x" % code)
        else:
            out.append(b"\\U%08x" % code)
    return b"".join(out)


def escape_texts(rng: random.Random, n: int, python_compatible: bool) -> list[bytes]:
    """Random texts of escapes, malformed escapes and plain text (python_compatible: only what Python reads alike)."""

    def valid() -> bytes:
        kind = rng.randrange(6)
        if kind == 0:
            return BS + rng.choice(
                [k for k in SHORT if not (python_compatible and k == b"e")]
            )
        if kind == 1:
            value = rng.randrange(128 if python_compatible else 256)
            # 3 digits in the compatible texts: a following digit can never extend the escape
            width = 3 if python_compatible else rng.randint(len(oct(value)) - 2, 3)
            return BS + oct(value)[2:].zfill(width).encode()
        if kind == 2:
            value = rng.randrange(128 if python_compatible else 256)
            return BS + (b"x%02x" % value if rng.random() < 0.5 else b"x%02X" % value)
        if kind == 3:
            value = rng.choice([rng.randrange(0xD800), rng.randrange(0xE000, 0x10000)])
            return BS + b"u%04x" % value
        if kind == 4:
            return BS + b"U%08x" % rng.choice(
                [rng.randrange(0xD800), rng.randrange(0x10000, 0x110000)]
            )
        return rng.choice([b"a", b"Z", b" ", b"7", b"x", b"u"])

    malformed = [
        BS + b"q",
        BS + b"x4",
        BS + b"xg0",
        BS + b"u12",
        BS + b"ud800",
        BS + b"U00110000",
        BS + b"UFFFFFFFF",
        BS + b"400",
        BS + b"777",
        BS,
    ]
    plain = [b"text", b" ", "\u00e9".encode(), b"\xff", b"9"]
    texts = []
    for _ in range(n):
        tokens = []
        for _ in range(rng.randint(0, 8)):
            pick = rng.random()
            if python_compatible or pick < 0.6:
                tokens.append(valid())
            elif pick < 0.8:
                tokens.append(rng.choice(malformed))
            else:
                tokens.append(rng.choice(plain))
        texts.append(b"".join(tokens))
    return texts


def check_escape_reference() -> list[str]:
    """Check the reference against Python's unicode_escape codec on the escapes both read alike."""
    failures = []
    for text in escape_texts(random.Random(SEED), 5000, python_compatible=True):
        expected = codecs.decode(text, "unicode_escape").encode("utf-8")
        if unescape_c(text) != expected or escapes_error(text) != 0:
            failures.append(
                f"unescape_c({text!r}) = {unescape_c(text)!r}, Python {expected!r}"
            )
    for _, data in cases():
        if (
            is_utf8(data)
            and codecs.decode(escape_c(data), "unicode_escape").encode("utf-8") != data
        ):
            failures.append(
                f"escape_c({data!r}) = {escape_c(data)!r} is not read back by Python"
            )
    return failures


def is_utf8(data: bytes) -> bool:
    """True if the bytes are well-formed UTF-8."""
    return utf8_error(data) == 0


def escape_extra() -> list[tuple[str, tuple[Arg, ...]]]:
    """Calls of unescape_c and escapes_error on random texts of escapes; round trips of every 2-byte string."""
    texts = escape_texts(random.Random(SEED), 4000, python_compatible=False)
    calls: list[tuple[str, tuple[Arg, ...]]] = [
        (name, (text,)) for text in texts for name in ("unescape_c", "escapes_error")
    ]
    pairs = [bytes([a, b]) for a in range(256) for b in range(256)]
    calls += [
        (name, (data,))
        for data in pairs
        for name in ("escape_roundtrip", "escape_roundtrip_utf8")
    ]
    return calls


def text(data: bytes) -> str:
    """Decode bytes into units: each ill-formed byte becomes one character (surrogateescape)."""
    return data.decode("utf-8", "surrogateescape")


def raw(chars: str) -> bytes:
    """Encode units back into the same bytes."""
    return chars.encode("utf-8", "surrogateescape")


def unit_search(data: bytes, members: bytes, back: bool, inside: bool) -> int:
    """Byte position of the first (last) unit in (not in) the set of units, 0 if none."""
    chars, wanted = text(data), set(text(members))
    found, offset = 0, 0
    for char in chars:
        if (char in wanted) == inside:
            found = offset + 1
            if not back:
                return found
        offset += len(raw(char))
    return found


def unit_sets(data: bytes, rng: random.Random) -> list[tuple[Arg, ...]]:
    """Calls (data, set): sets of units of data, of the pool, a lone lead byte, an ASCII set, the empty set."""
    pieces = units(data)
    sets = [
        b"".join(rng.sample(pieces, min(len(pieces), rng.randint(1, 3))))
        if pieces
        else b"x"
    ]
    sets.append(b"".join(rng.choice(POOL)[0] for _ in range(rng.randint(1, 3))))
    sets.append(rng.choice([b"\xc3", b"\xe4\xbd", b" ", b"ab"]))
    sets.append(b"")
    return [(data, members) for members in sets]


def squeeze(data: bytes, members: bytes | None = None) -> bytes:
    """Runs of a repeated unit reduced to one, only for the units of members if given."""
    chars, out = text(data), []
    wanted = None if members is None else set(text(members))
    for i, char in enumerate(chars):
        if i > 0 and char == chars[i - 1] and (wanted is None or char in wanted):
            continue
        out.append(char)
    return raw("".join(out))


def transliterate(data: bytes, old: bytes, new: bytes) -> bytes:
    """Each unit of old replaced by the unit at the same position of new (its last one if shorter), deleted if new
    is empty; a unit repeated in old is replaced as its first occurrence."""
    old_chars, new_chars, table = text(old), text(new), {}
    for i, char in enumerate(old_chars):
        table.setdefault(
            char, new_chars[min(i, len(new_chars) - 1)] if new_chars else ""
        )
    return raw("".join(table.get(char, char) for char in text(data)))


def with_runs(data: bytes, rng: random.Random) -> bytes:
    """Data with some of its units repeated, so that runs occur."""
    pieces = units(data)
    return b"".join(
        p * (rng.randint(2, 3) if rng.random() < 0.4 else 1) for p in pieces
    )


def run_sets(data: bytes, rng: random.Random) -> list[tuple[Arg, ...]]:
    """Calls (data with runs, set)."""
    return [(with_runs(data, rng), members) for _, members in unit_sets(data, rng)]


def runs(data: bytes, rng: random.Random) -> list[tuple[Arg, ...]]:
    """Calls (data with runs,)."""
    return [(with_runs(data, rng),)]


def translations(data: bytes, rng: random.Random) -> list[tuple[Arg, ...]]:
    """Calls (data, old, new): old from the units of data and of the pool, new longer, shorter or empty."""
    calls: list[tuple[Arg, ...]] = []
    for _, old in unit_sets(data, rng):
        n_new = rng.choice([0, 1, len(text(old)), len(text(old)) + 2])
        new = b"".join(rng.choice(POOL)[0] for _ in range(n_new))
        calls.append((data, old, new))
    return calls


def patterns(data: bytes, rng: random.Random) -> list[tuple[Arg, ...]]:
    """Calls (data, pattern): data with some units turned into ?, *, classes (ranges, negation) or other units."""
    pieces = units(data)
    pool = [unit for unit, _ in POOL] + [b"]", b"-", b"!", b"["]
    calls: list[tuple[Arg, ...]] = []
    for _ in range(3):
        out = []
        for piece in pieces:
            pick = rng.random()
            if pick < 0.55:
                out.append(piece)
            elif pick < 0.65:
                out.append(b"?")
            elif pick < 0.75:
                out.append(b"*")
            elif pick < 0.92:
                members = [piece] if rng.random() < 0.7 else []
                members += [rng.choice(pool) for _ in range(rng.randint(0, 2))]
                if rng.random() < 0.4:
                    low, high = sorted(
                        rng.sample([piece, *[rng.choice(pool) for _ in range(2)]], 2)
                    )
                    members.append(low + b"-" + high)
                rng.shuffle(members)
                out.append(
                    b"["
                    + (b"!" if rng.random() < 0.25 else b"")
                    + b"".join(members)
                    + b"]"
                )
            else:
                out.append(rng.choice(pool))
        calls.append((data, b"".join(out)))
    return calls


def units_extra() -> list[tuple[str, tuple[Arg, ...]]]:
    """Calls of match on short ASCII strings and patterns made of the characters that make wildcards tricky."""
    rng = random.Random(SEED)
    calls: list[tuple[str, tuple[Arg, ...]]] = []
    for _ in range(3000):
        data = bytes(rng.choice(b"ab-]![") for _ in range(rng.randint(0, 5)))
        pattern = bytes(rng.choice(b"ab-]![*?") for _ in range(rng.randint(0, 7)))
        calls.append(("match", (data, pattern)))
    return calls


def unit_starts(data: bytes) -> list[int]:
    """1-based byte position of the first byte of each unit, then len+1."""
    starts, at = [], 1
    for piece in units(data):
        starts.append(at)
        at += len(piece)
    return [*starts, at]


def char_pos(data: bytes, b: int) -> int:
    """Unit holding byte b; len+1 gives the number of units + 1; 0 out of range."""
    starts = unit_starts(data)
    if b < 1 or b > len(data) + 1:
        return 0
    return max(k for k, start in enumerate(starts, 1) if start <= b)


def byte_pos(data: bytes, k: int) -> int:
    """First byte of unit k; units + 1 gives len+1; 0 out of range."""
    starts = unit_starts(data)
    return starts[k - 1] if 1 <= k <= len(starts) else 0


def in_chars(data: bytes, i: int) -> int:
    """A byte result (0: none) in characters."""
    return char_pos(data, i) if i else 0


def byte_positions(data: bytes, rng: random.Random) -> list[tuple[Arg, ...]]:
    """Calls (data, b) with b around and inside the string."""
    return [
        (data, b)
        for b in {
            0,
            1,
            len(data),
            len(data) + 1,
            len(data) + 2,
            rng.randint(1, len(data) + 1),
        }
    ]


def char_positions(data: bytes, rng: random.Random) -> list[tuple[Arg, ...]]:
    """Calls (data, k) with k around and inside the units."""
    n = len(units(data))
    return [(data, k) for k in {0, 1, n, n + 1, n + 2, rng.randint(1, n + 1)}]


def fortran_div(a: int, b: int) -> int:
    """Integer division truncating toward zero, as Fortran's."""
    q = abs(a) // abs(b)
    return q if (a >= 0) == (b > 0) else -q


def slice_units(data: bytes, first: int, last: int, stride: int) -> bytes:
    """StringiFor slice(first, last, stride, by=SF_CHARS): bounds clamped into the units, both included."""
    pieces = units(data)
    n = len(pieces)
    if stride == 0:
        return b""
    first, last = (
        (max(first, 1), min(last, n)) if stride > 0 else (min(first, n), max(last, 1))
    )
    length = max(0, fortran_div(last - first + stride, stride))
    return b"".join(pieces[first - 1 + c * stride] for c in range(length))


def insert_units(data: bytes, sub: bytes, pos: int) -> bytes:
    """StringiFor insert(sub, pos, by=SF_CHARS): the first position prepends, the last one appends."""
    pieces = units(data)
    n = len(pieces)
    at = min(max(1, pos), n)
    if at == 1:
        return sub + data
    if at == n:
        return data + sub
    return b"".join(pieces[: at - 1]) + sub + b"".join(pieces[at - 1 :])


def len_last_word_units(data: bytes, sep: bytes) -> int:
    """StringiFor len_last_word(sep, by=SF_CHARS): trailing separators ignored."""
    last = len(data)
    while last >= len(sep) and data[last - len(sep) : last] == sep:
        last -= len(sep)
    at = data.rfind(sep, 0, last) + 1
    word = data[at - 1 + len(sep) : last] if at > 0 else data[:last]
    return len(units(word))


def slices(data: bytes, rng: random.Random) -> list[tuple[Arg, ...]]:
    """Calls (data, first, last, stride) around and inside the units, strides -3..3."""
    n = len(units(data))
    calls: list[tuple[Arg, ...]] = []
    for _ in range(3):
        calls.append(
            (data, rng.randint(-1, n + 2), rng.randint(-1, n + 2), rng.randint(-3, 3))
        )
    return calls


def insertions(data: bytes, rng: random.Random) -> list[tuple[Arg, ...]]:
    """Calls (data, substring, pos) around and inside the units."""
    n = len(units(data))
    return [
        (data, rng.choice(POOL)[0] + b"+", pos)
        for pos in {-1, 1, n, n + 1, rng.randint(1, n + 1)}
    ]


def justify_units(data: bytes, width: int, size_of=None) -> list[bytes]:
    """StringiFor justify(lines, width, by=SF_CHARS): words packed in lines of width characters, the blanks spread
    from the left; the last line, and a line of one word, padded on the right."""
    words = split_collapse(data, b" ") if data.rstrip(b" ") else []

    def size(text_: bytes) -> int:
        return size_of(text_) if size_of else len(units(text_))

    lines, last = [], 0
    while last < len(words):
        first = last + 1
        last = first
        length = size(words[first - 1])
        while last < len(words) and length + 1 + size(words[last]) <= width:
            last += 1
            length += 1 + size(words[last - 1])
        gaps, line = last - first, words[first - 1]
        if last == len(words) or gaps == 0:
            for g in range(1, gaps + 1):
                line += b" " + words[first - 1 + g]
            if size(line) < width:
                line += b" " * (width - size(line))
        else:
            blanks = width - (length - gaps)
            for g in range(1, gaps + 1):
                line += (
                    b" " * (blanks // gaps + (1 if g <= blanks % gaps else 0))
                    + words[first - 1 + g]
                )
        lines.append(line)
    return lines


def widths(data: bytes, rng: random.Random) -> list[tuple[Arg, ...]]:
    """Calls (data, width) around the length in characters."""
    n = len(units(data))
    return [(data, w) for w in {0, n - 1, n, n + 1, n + rng.randint(2, 9)} if w >= 0]


def with_tabs(data: bytes, rng: random.Random) -> list[tuple[Arg, ...]]:
    """Calls (data with tabs, tab size 0..8)."""
    pieces = units(data)
    for _ in range(rng.randint(1, 3)):
        pieces.insert(rng.randint(0, len(pieces)), b"\t")
    return [(b"".join(pieces), rng.randint(0, 8))]


def fills(data: bytes, rng: random.Random) -> list[tuple[Arg, ...]]:
    """Calls (data, width, right)."""
    return [(d, w, rng.randint(0, 1)) for d, w in widths(data, rng)]


def ucd_sets() -> dict[str, set[int]]:
    """The width sets of the pinned UCD, read once (downloaded and verified by gen_unicode_tables if needed)."""
    if not _UCD_SETS:
        import gen_unicode_tables as ucd  # noqa: PLC0415 (only the columns suite needs it)

        cache = ucd.ROOT / "build" / "utf8" / f"ucd-{ucd.DEFAULT_VERSION}"
        _UCD_SETS.update(ucd.naive_sets(ucd.fetch(ucd.DEFAULT_VERSION, cache)))
    return _UCD_SETS


def unit_width(code: int) -> int:
    """Display columns of a unit: code is its codepoint, or -byte for an ill-formed byte."""
    sets = ucd_sets()
    if code < 0:
        return 1
    if code < 32 or 127 <= code < 160:
        return 0
    if code in sets["ZERO_WIDTH_RANGES"]:
        return 0
    return 2 if code in sets["WIDE_RANGES"] else 1


def display_width(data: bytes) -> int:
    """Display columns of the bytes: the sum over their units."""
    return sum(unit_width(code) for code in codepoints(data))


def width_each(codes: list[int]) -> list[int]:
    """Columns of each codepoint encoded alone (a non-scalar value encodes as U+FFFD)."""
    return [display_width(from_codepoints([code])) for code in codes]


def pad_columns(data: bytes, width: int, how: str, fill: bytes = b"*") -> bytes:
    """center, ljust, rjust (and fill, with "0") with the width in display columns."""
    margin = width - display_width(data)
    if margin <= 0:
        return data
    if how == "left":
        return data + fill * margin
    if how == "right":
        return fill * margin + data
    left = margin // 2 + (margin & width & 1)
    return fill * left + data + fill * (margin - left)


def expand_tabs_columns(data: bytes, tab: int) -> bytes:
    """expand_tabs with tab stops every tab display columns; LF and CR reset the column."""
    out, column = [], 0
    for code, piece in zip(codepoints(data), units(data), strict=True):
        if piece == b"\t":
            if tab > 0:
                out.append(b" " * (tab - column % tab))
                column += tab - column % tab
        elif piece in (b"\n", b"\r"):
            out.append(piece)
            column = 0
        else:
            out.append(piece)
            column += unit_width(code)
    return b"".join(out)


def column_widths(data: bytes, rng: random.Random) -> list[tuple[Arg, ...]]:
    """Calls (data, width) around the display width."""
    n = display_width(data)
    return [(data, w) for w in {0, n - 1, n, n + 1, n + rng.randint(2, 9)} if w >= 0]


def columns_extra() -> list[tuple[str, tuple[Arg, ...]]]:
    """Every Unicode scalar value, by blocks of 4096, and the 128 ill-formed bytes."""
    calls: list[tuple[str, tuple[Arg, ...]]] = [
        ("width_each", (list(range(-255, -127)),))
    ]
    for first in range(0, 0x110000, 4096):
        block = [c for c in range(first, first + 4096) if not 0xD800 <= c <= 0xDFFF]
        calls.append(("width_each", (block,)))
    return calls


EXTRA = {
    "utf8": utf8_exhaustive,
    "escape": escape_extra,
    "units": units_extra,
    "columns": columns_extra,
}
SELF_CHECKS = {"escape": check_escape_reference}


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
        Op("split_collapse", nonempty_needles, split_collapse),
        Op("split_chunked", chunked, lambda d, s, c: split_collapse(d, s)),
        Op(
            "index_occurrence",
            occurrences,
            lambda d, s, n: occurrence(d, s, n, back=False),
        ),
        Op(
            "index_occurrence_back",
            occurrences,
            lambda d, s, n: occurrence(d, s, n, back=True),
        ),
        Op("partition", nonempty_needles, partition),
        Op("start_with", any_needles, lambda d, p: d.startswith(p)),
        Op("end_with", any_needles, lambda d, s: d.endswith(s)),
        Op("upper", single, bytes.upper),
        Op("lower", single, bytes.lower),
        Op("eq", pairs, lambda a, b: padded(a, b)[0] == padded(a, b)[1]),
        Op("lt", pairs, lambda a, b: padded(a, b)[0] < padded(a, b)[1]),
        Op("concat", pairs, lambda a, b: a + b),
        Op("assign_substring", ranges, lambda d, first, last: d[first - 1 : last]),
    ],
    "utf8": [
        Op("is_utf8", single, lambda d: utf8_error(d) == 0),
        Op("utf8_error", single, utf8_error),
        Op("codepoints", single, codepoints),
        Op("from_codepoints", codepoint_lists, from_codepoints),
        Op("to_valid_utf8", single, to_valid_utf8),
        Op("to_valid_utf8_with", replacements_of, to_valid_utf8),
    ],
    "columns": [
        Op("width", single, display_width),
        Op("width_each", codepoint_lists, width_each),
        Op("center_columns", column_widths, lambda d, w: pad_columns(d, w, "center")),
        Op("ljust_columns", column_widths, lambda d, w: pad_columns(d, w, "left")),
        Op("rjust_columns", column_widths, lambda d, w: pad_columns(d, w, "right")),
        Op(
            "fill_columns", column_widths, lambda d, w: pad_columns(d, w, "right", b"0")
        ),
        Op("expand_tabs_columns", with_tabs, expand_tabs_columns),
        Op(
            "justify_columns",
            column_widths,
            lambda d, w: justify_units(d, w, display_width),
        ),
    ],
    "positions": [
        Op("len_chars", single, lambda d: len(units(d))),
        Op("index_chars", any_needles, lambda d, n: in_chars(d, find(d, n))),
        Op("index_back_chars", any_needles, lambda d, n: in_chars(d, rfind(d, n))),
        Op(
            "index_occurrence_chars",
            occurrences,
            lambda d, n, k: in_chars(d, occurrence(d, n, k, back=False)),
        ),
        Op(
            "scan_chars",
            unit_sets,
            lambda d, m: in_chars(d, unit_search(d, m, back=False, inside=True)),
        ),
        Op(
            "verify_back_chars",
            unit_sets,
            lambda d, m: in_chars(d, unit_search(d, m, back=True, inside=False)),
        ),
        Op("slice_chars", slices, slice_units),
        Op("insert_chars", insertions, insert_units),
        Op("len_last_word_chars", nonempty_needles, len_last_word_units),
        Op("center_chars", widths, lambda d, w: raw(text(d).center(w, "*"))),
        Op("ljust_chars", widths, lambda d, w: raw(text(d).ljust(w, "*"))),
        Op("rjust_chars", widths, lambda d, w: raw(text(d).rjust(w, "*"))),
        Op(
            "fill_chars",
            fills,
            lambda d, w, r: raw(text(d).ljust(w, "0") if r else text(d).rjust(w, "0")),
        ),
        Op("expand_tabs_chars", with_tabs, lambda d, t: raw(text(d).expandtabs(t))),
        Op("justify_chars", widths, justify_units),
        Op("byte_pos", char_positions, byte_pos),
        Op("char_pos", byte_positions, char_pos),
    ],
    "units": [
        Op("scan", unit_sets, lambda d, m: unit_search(d, m, back=False, inside=True)),
        Op(
            "scan_back",
            unit_sets,
            lambda d, m: unit_search(d, m, back=True, inside=True),
        ),
        Op(
            "verify",
            unit_sets,
            lambda d, m: unit_search(d, m, back=False, inside=False),
        ),
        Op(
            "verify_back",
            unit_sets,
            lambda d, m: unit_search(d, m, back=True, inside=False),
        ),
        Op(
            "scan_overload",
            unit_sets,
            lambda d, m: unit_search(d, m, back=False, inside=True),
        ),
        Op(
            "verify_overload",
            unit_sets,
            lambda d, m: unit_search(d, m, back=True, inside=False),
        ),
        Op("strip_remove", unit_sets, lambda d, m: raw(text(d).strip(text(m)))),
        Op("lstrip_remove", unit_sets, lambda d, m: raw(text(d).lstrip(text(m)))),
        Op("rstrip_remove", unit_sets, lambda d, m: raw(text(d).rstrip(text(m)))),
        Op("reverse", single, lambda d: raw(text(d)[::-1])),
        Op("match", patterns, lambda d, p: fnmatch.fnmatchcase(text(d), text(p))),
        Op("squeeze", runs, squeeze),
        Op("squeeze_set", run_sets, squeeze),
        Op("transliterate", translations, transliterate),
    ],
    "escape": [
        Op("escape_c", single, escape_c),
        Op("escape_c_utf8", single, lambda d: escape_c(d, ascii_only=False)),
        Op("unescape_c", single, unescape_c),
        Op("escapes_error", single, escapes_error),
        Op("escape_roundtrip", single, lambda d: d),
        Op("escape_roundtrip_utf8", single, lambda d: d),
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
        (
            "nvfortran 26.9: index(string, substring) with assumed-length dummies is wrong when the substring holds a "
            "NUL byte (a reduced case gives 12 for 17)",
            lambda name, call: name.startswith("index") and b"\x00" in call[1],
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
    if isinstance(arg, list):
        return ",".join(str(value) for value in arg) if arg else "[]"
    return str(arg) if isinstance(arg, int) else arg.hex()


def encode_result(result: Result) -> str:
    """Encode a result as the driver writes it."""
    if isinstance(result, bool):
        return "T" if result else "F"
    if isinstance(result, int):
        return str(result)
    if isinstance(result, list):
        if not result:
            return "[]"
        return ",".join(
            str(item) if isinstance(item, int) else item.hex() for item in result
        )
    return result.hex()


def generate(suite: str, seed: int, n_random: int) -> list[tuple[str, tuple[Arg, ...]]]:
    """Return the calls of a suite over the corpus."""
    rng = random.Random(seed)
    calls = []
    for _, data in cases(seed, n_random):
        for op in SUITES[suite]:
            calls.extend((op.name, args) for args in op.args(data, rng))
    if suite in EXTRA:
        calls.extend(EXTRA[suite]())
    return calls


def run(args: argparse.Namespace) -> int:
    """Generate, run the driver, compare; return the exit status."""
    work: Path = args.work
    work.mkdir(parents=True, exist_ok=True)
    if args.suite in SELF_CHECKS:
        failures = SELF_CHECKS[args.suite]()
        for failure in failures[: args.show]:
            print(f"REFERENCE {failure}")
        print(f"reference check {args.suite}: {len(failures)} failure(s)")
        if failures:
            return 1
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
