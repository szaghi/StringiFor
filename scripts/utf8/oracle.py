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
  regex       regular expressions (Phase 10 of #51): search, match and fullmatch of random patterns of the supported
              syntax on random subjects and on the corpus, against Python's re with re.ASCII on the subject decoded
              with surrogateescape; a pattern StringiFor rejects and Python accepts is allowed and counted
  sort        strsort (Phase 9 of #51): byte, caseless and natural order, the permutation, stability on duplicates,
              not allocated strings; the reference is Python's stable sorted with a key, and byte order is checked to
              be codepoint order on well-formed UTF-8
  whitespace  Unicode whitespace (Phase 7 of #51): is_space, strip, lstrip, rstrip and compact, ASCII and with
              unicode=.true.; the reference is White_Space of the pinned UCD 17.0.0, checked against Python's
              str.isspace (which adds U+001C..U+001F), on spaced corpus strings and on every scalar value
  xml         XML escaping (Phase 6 of #51): escape_xml, unescape_xml, xml_error and the round trip, on every byte and
              every 2-byte string too; the reference is checked first against xml.sax.saxutils and against expat, which
              must read every escaped string back and reject every malformed reference
  units       the methods that work on units (Phase 3 of #51): the reference is Python str on the bytes decoded with
              surrogateescape, so each byte that is not part of a well-formed sequence is one character (rule R3)
"""

from __future__ import annotations

import argparse
import codecs
import fnmatch
import itertools
import os
import random
import re
import struct
import subprocess
import sys
from collections import Counter
from collections.abc import Callable, Sequence
from dataclasses import dataclass
from fractions import Fraction
from pathlib import Path
from xml.etree import ElementTree
from xml.sax import saxutils

sys.path.insert(0, str(Path(__file__).resolve().parent))
from corpus import POOL, RANDOM, SEED, cases, units  # noqa: E402

_UCD_SETS: dict[str, set[int]] = {}

Arg = bytes | int | list[int] | list[bytes] | list[bytes | None]
Result = bytes | int | bool | str | list[bytes] | list[int] | list[bytes | None]


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


XML_ENTITIES = {b"amp": b"&", b"lt": b"<", b"gt": b">", b"quot": b'"', b"apos": b"'"}
XML_REFERENCE = re.compile(rb"&(?:(amp|lt|gt|quot|apos)|#([0-9]+)|#x([0-9a-fA-F]+));")
XML_MARKUP = {38: b"&amp;", 60: b"&lt;", 62: b"&gt;", 34: b"&quot;", 39: b"&apos;"}
XML_SPACES = {9: b"&#9;", 10: b"&#10;", 13: b"&#13;"}


def escape_xml(data: bytes, attribute: bool = False) -> bytes:
    """Escape & < > " ' (and, for an attribute, TAB LF CR); every other byte is kept."""
    table = {**XML_MARKUP, **(XML_SPACES if attribute else {})}
    return b"".join(table.get(b, bytes([b])) for b in data)


def parse_xml_reference(text: bytes, i: int) -> tuple[bytes, int]:
    """Parse the reference whose & is at i: (bytes it gives, its length), length 0 if malformed.

    A character reference must be a Unicode scalar value other than 0 (no version of XML allows U+0000). The other
    controls are accepted, as XML 1.1 does; XML 1.0 (and expat) reject them.
    """
    found = XML_REFERENCE.match(text, i)
    if found is None:
        return b"", 0
    name, decimal, hexadecimal = found.groups()
    if name is not None:
        return XML_ENTITIES[name], found.end() - i
    value = int(decimal, 10) if decimal is not None else int(hexadecimal, 16)
    if value == 0 or value > 0x10FFFF or 0xD800 <= value <= 0xDFFF:
        return b"", 0
    return chr(value).encode("utf-8"), found.end() - i


def unescape_xml(text: bytes) -> bytes:
    """Expand the XML references; the & of a malformed reference is kept and the text after it read normally."""
    out, i = [], 0
    while i < len(text):
        if text[i] == 38:
            value, n = parse_xml_reference(text, i)
            if n:
                out.append(value)
                i += n
                continue
        out.append(text[i : i + 1])
        i += 1
    return b"".join(out)


def xml_error(text: bytes) -> int:
    """Byte position (1-based) of the & of the first malformed reference, 0 if none."""
    i = 0
    while i < len(text):
        if text[i] == 38:
            _, n = parse_xml_reference(text, i)
            if n == 0:
                return i + 1
            i += n
        else:
            i += 1
    return 0


XML_MALFORMED = [
    b"&",
    b"&amp",
    b"&AMP;",
    b"&nbsp;",
    b"&#;",
    b"&#x;",
    b"&#X41;",
    b"&#0;",
    b"&#x0000;",
    b"&#xD800;",
    b"&#57343;",
    b"&#x110000;",
    b"&#1114112;",
    b"&#99999999999999999999;",
    b"&#x100000041;",  # 2**32 + 65: a 32-bit value that wraps around would give "A"
    b"&#4294967361;",
    b"&#12a;",
    b"&# 65;",
]


def is_xml10_char(code: int) -> bool:
    """True if the codepoint is a Char of XML 1.0 (production [2])."""
    return (
        code in (9, 10, 13)
        or 0x20 <= code <= 0xD7FF
        or 0xE000 <= code <= 0xFFFD
        or code >= 0x10000
    )


def xml_texts(rng: random.Random, n: int, expat_compatible: bool) -> list[bytes]:
    """Random texts of references, malformed references and plain text (expat_compatible: only what XML 1.0 reads).

    The compatible texts hold no literal CR (a parser turns it into LF), no < and no & outside a reference.
    """

    def char_value() -> int:
        while True:
            code = rng.choice(
                [
                    rng.randrange(1, 0x80),
                    rng.randrange(0x80, 0x10000),
                    rng.randrange(0x10000, 0x110000),
                ]
            )
            if not 0xD800 <= code <= 0xDFFF and (
                not expat_compatible or is_xml10_char(code)
            ):
                return code

    def valid() -> bytes:
        kind = rng.randrange(3)
        if kind == 0:
            return b"&" + rng.choice(list(XML_ENTITIES)) + b";"
        code = char_value()
        if kind == 1:
            return b"&#" + b"0" * rng.randrange(3) + str(code).encode() + b";"
        digits = b"%x" % code if rng.random() < 0.5 else b"%X" % code
        return b"&#x" + b"0" * rng.randrange(3) + digits + b";"

    plain = [
        b"text",
        b" ",
        b";",
        b"#",
        b"x",
        b"amp",
        "é".encode(),
        b"\n",
        b"\t",
        b">",
        b"'",
        b'"',
    ]
    if not expat_compatible:
        plain += [b"\xff", b"\r", b"<", b"&#x1;", b"&#31;"]
    texts = []
    for _ in range(n):
        tokens = []
        for _ in range(rng.randint(0, 8)):
            pick = rng.random()
            if pick < 0.5:
                tokens.append(valid())
            elif pick < 0.7 and not expat_compatible:
                tokens.append(rng.choice(XML_MALFORMED))
            else:
                tokens.append(rng.choice(plain))
        texts.append(b"".join(tokens))
    return texts


def expat_text(document: bytes) -> tuple[str | None, str | None]:
    """Parse a document <a x="...">...</a> with expat: (text of the element, attribute x), None if not well-formed."""
    try:
        element = ElementTree.fromstring(document)
    except ElementTree.ParseError:
        return None, None
    return element.text or "", element.get("x")


def check_xml_reference() -> list[str]:
    """Check the reference against xml.sax.saxutils and against expat, an XML parser."""
    failures = []
    quotes = {'"': "&quot;", "'": "&apos;"}
    spaces = {"\t": "&#9;", "\n": "&#10;", "\r": "&#13;"}
    for _, data in cases():
        if not is_utf8(data):
            continue
        chars = data.decode("utf-8")
        for attribute, entities in ((False, quotes), (True, quotes | spaces)):
            if escape_xml(data, attribute) != saxutils.escape(chars, entities).encode(
                "utf-8"
            ):
                failures.append(
                    f"escape_xml({data!r}, {attribute}) differs from xml.sax.saxutils.escape"
                )
        if not all(is_xml10_char(ord(c)) for c in chars):
            continue
        escaped = escape_xml(data, attribute=True)
        for quote in (b'"', b"'"):
            element, value = expat_text(
                b"<a x=" + quote + escaped + quote + b">" + escaped + b"</a>"
            )
            if element != chars or value != chars:
                failures.append(
                    f"expat reads {data!r} back as {element!r} and {value!r}"
                )
        element, _ = expat_text(b"<a>" + escape_xml(data) + b"</a>")
        if element != chars.replace("\r\n", "\n").replace("\r", "\n"):
            failures.append(f"expat reads the element {data!r} back as {element!r}")
    for text in xml_texts(random.Random(SEED), 5000, expat_compatible=True):
        element, _ = expat_text(b"<a>" + text + b"</a>")
        if (
            element is None
            or unescape_xml(text) != element.encode("utf-8")
            or xml_error(text) != 0
        ):
            failures.append(
                f"unescape_xml({text!r}) = {unescape_xml(text)!r}, expat {element!r}"
            )
    for text in XML_MALFORMED:
        if expat_text(b"<a>" + text + b"</a>")[0] is not None or xml_error(text) != 1:
            failures.append(f"{text!r}: expat reads it or xml_error is not 1")
    return failures


def xml_extra() -> list[tuple[str, tuple[Arg, ...]]]:
    """Every byte escaped; unescape_xml and xml_error on random texts; round trips of every 2-byte string."""
    calls: list[tuple[str, tuple[Arg, ...]]] = [
        (name, (bytes([b]),))
        for b in range(256)
        for name in ("escape_xml", "escape_xml_attribute")
    ]
    texts = xml_texts(random.Random(SEED), 4000, expat_compatible=False) + XML_MALFORMED
    calls += [
        (name, (text,)) for text in texts for name in ("unescape_xml", "xml_error")
    ]
    pairs = [bytes([a, b]) for a in range(256) for b in range(256)]
    calls += [
        (name, (data,))
        for data in pairs
        for name in ("xml_roundtrip", "xml_roundtrip_attribute")
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


ASCII_SPACE = " \t\n\x0b\x0c\r"


def white_space() -> str:
    """The characters with the White_Space property in the pinned UCD."""
    return "".join(chr(code) for code in sorted(ucd_sets()["WHITE_SPACE_RANGES"]))


def is_space(data: bytes, unicode: bool = False) -> bool:
    """True if every unit is whitespace (ASCII, or White_Space); false for a null string."""
    chars = text(data)
    spaces = white_space() if unicode else ASCII_SPACE
    return bool(chars) and all(char in spaces for char in chars)


def strip_space(data: bytes, side: str, unicode: bool, remove: bytes = b" ") -> bytes:
    """strip, lstrip, rstrip with whitespace=.true.: the set is remove plus the whitespace, as units."""
    chars = text(remove) + ASCII_SPACE + (white_space() if unicode else "")
    method = {"both": str.strip, "left": str.lstrip, "right": str.rstrip}[side]
    return raw(method(text(data), chars))


def compact_space(data: bytes, unicode: bool = False, sep: bytes = b" ") -> bytes:
    """sep.join of the words: runs of units that are not whitespace (ASCII, or White_Space)."""
    spaces = white_space() if unicode else ASCII_SPACE
    words, word = [], []
    for char in text(data):
        if char in spaces:
            if word:
                words.append("".join(word))
            word = []
        else:
            word.append(char)
    if word:
        words.append("".join(word))
    return raw(text(sep).join(words))


def space_each(codes: list[int]) -> list[int]:
    """1 if the codepoint encoded alone is White_Space, 0 if not (a non-scalar value encodes as U+FFFD)."""
    return [int(is_space(from_codepoints([code]), unicode=True)) for code in codes]


# Whitespace-like units: the White_Space characters, characters that look like spaces but are not White_Space
# (U+001C..U+001F, which Python's str.isspace accepts, U+180E, U+200B, U+2060, U+FEFF), ill-formed bytes and truncated
# sequences of whitespace characters.
SPACE_LIKE = [
    *(c.encode() for c in ASCII_SPACE),
    *(
        chr(c).encode()
        for c in (
            0x85,
            0xA0,
            0x1680,
            0x2000,
            0x2005,
            0x200A,
            0x2028,
            0x2029,
            0x202F,
            0x205F,
            0x3000,
        )
    ),
    *(chr(c).encode() for c in (0x1C, 0x1F, 0x180E, 0x200B, 0x2060, 0xFEFF)),
    b"\x85",
    b"\xa0",
    b"\xc2",
    b"\xe3\x80",
    b"\xe2\x80",
]


def spaced(data: bytes, rng: random.Random) -> list[tuple[Arg, ...]]:
    """Calls (data with whitespace-like units around and inside it,) and (a run of them only,)."""

    def run() -> bytes:
        return b"".join(rng.choice(SPACE_LIKE) for _ in range(rng.randint(0, 4)))

    pieces = units(data)
    for _ in range(rng.randint(0, 3)):
        pieces.insert(rng.randint(0, len(pieces)), run())
    return [(data,), (run() + b"".join(pieces) + run(),), (run(),)]


def spaced_sets(data: bytes, rng: random.Random) -> list[tuple[Arg, ...]]:
    """Calls (spaced data, a set of units to remove or a separator)."""
    members = [b"", b"a", b"x-", "é".encode(), b"\xff", "　".encode()]
    return [(d[0], rng.choice(members)) for d in spaced(data, rng)]


def check_space_reference() -> list[str]:
    """Check White_Space against Python's str.isspace: they differ on U+001C..U+001F only (Python adds them)."""
    ours = {ord(c) for c in white_space()}
    python = {code for code in range(0x110000) if chr(code).isspace()}
    if python - ours != {0x1C, 0x1D, 0x1E, 0x1F} or ours - python:
        return [
            f"White_Space {sorted(ours ^ python)} differs from str.isspace beyond U+001C..U+001F"
        ]
    if set(ASCII_SPACE) != {c for c in white_space() if c < "\x80"}:
        return ["the ASCII whitespace is not the ASCII part of White_Space"]
    return []


def whitespace_extra() -> list[tuple[str, tuple[Arg, ...]]]:
    """White_Space of every Unicode scalar value, in blocks."""
    calls: list[tuple[str, tuple[Arg, ...]]] = []
    for first in range(0, 0x110000, 4096):
        block = [c for c in range(first, first + 4096) if not 0xD800 <= c <= 0xDFFF]
        calls.append(("space_each", (block,)))
    return calls


def natural_key(data: bytes) -> list[tuple[int, int, int, bytes]]:
    """Key of the natural order: per run, (first byte, 0, digits, value) for digits, (first byte, 1, 0, run) otherwise.

    Every run of digits gets the first byte 0x30: a run of other bytes never starts with a digit, so the comparison of a
    number with another run is decided by the first byte as in byte order.
    """
    key = []
    for run in re.findall(rb"[0-9]+|[^0-9]+", data):
        if run[:1].isdigit():
            value = run.lstrip(b"0") or b"0"
            key.append((0x30, 0, len(value), value))
        else:
            key.append((run[0], 1, 0, run))
    return key


SORT_KEYS: dict[str, Callable[[bytes], object]] = {
    "bytes": lambda d: d,
    "nocase": bytes.lower,
    "natural": natural_key,
}


def sort_with(items: list[bytes | None], order: str) -> list[bytes | None]:
    """Stable sort; a not allocated string (None) sorts as an empty one."""
    return sorted(items, key=lambda d: SORT_KEYS[order](d or b""))


def sort_index(items: list[bytes]) -> list[int]:
    """The permutation of the stable byte-order sort, 1-based."""
    return [i + 1 for i in sorted(range(len(items)), key=lambda i: items[i])]


def sort_names(rng: random.Random) -> bytes:
    """A name with digits, leading zeros and both cases, for the natural and caseless orders."""
    stem = rng.choice(
        [b"file", b"File", b"FILE", b"v", b"x", b"", b"a-", "été".encode()]
    )
    digits = (
        b"0" * rng.randrange(3)
        + str(rng.choice([0, 1, 2, 9, 10, 11, 99, 100, 10**20])).encode()
    )
    tail = rng.choice([b"", b".txt", b".", b"b", b"10", b"\xff"])
    return stem + digits + tail


def sort_lists(data: bytes, rng: random.Random) -> list[tuple[Arg, ...]]:
    """Calls (list of strings,): data with its prefixes and units, names with numbers, duplicates."""
    pieces = units(data)
    pool = [
        data,
        b"",
        data[: len(data) // 2],
        b"".join(reversed(pieces)),
        data.upper(),
        data.lower(),
    ]
    pool += [sort_names(rng) for _ in range(6)]
    items = [rng.choice(pool) for _ in range(rng.randint(0, 12))]
    return [(items,)]


def check_sort_reference() -> list[str]:
    """Byte order is codepoint order for well-formed UTF-8; the natural key is consistent with its definition."""
    failures = []
    rng = random.Random(SEED)
    valid = [data for _, data in cases() if is_utf8(data)]
    for _ in range(2000):
        items = [rng.choice(valid) for _ in range(rng.randint(0, 12))]
        if sorted(items) != [s.encode() for s in sorted(s.decode() for s in items)]:
            failures.append(f"byte order differs from codepoint order on {items!r}")
    for a, b in (
        (b"file2", b"file10"),
        (b"v1.9.1", b"v1.10.0"),
        (b"x9", b"x10"),
        (b"a", b"a0"),
        (b"a1", b"ab"),
    ):
        if not natural_key(a) < natural_key(b):
            failures.append(f"natural order: {a!r} is not before {b!r}")
    if natural_key(b"a007") != natural_key(b"a7"):
        failures.append("natural order: a007 and a7 differ")
    return failures


def sort_extra() -> list[tuple[str, tuple[Arg, ...]]]:
    """Stability on many duplicates and lengths 0..64, both orders of 2 and 3 items, not allocated strings."""
    rng = random.Random(SEED)
    calls: list[tuple[str, tuple[Arg, ...]]] = []
    for n in range(65):
        items: list[bytes] = [
            rng.choice([b"a", b"b", b"A", b"a1", b"a01", b"a10"]) for _ in range(n)
        ]
        calls += [
            (name, (items,))
            for name in ("strsort_index", "strsort_nocase", "strsort_natural")
        ]
    for items in itertools.permutations([b"b", b"a", b"ab", b"\xff"], 3):
        calls.append(("strsort_index", (list(items),)))
    for _ in range(200):
        items = [
            rng.choice([None, b"", b"a", b"\x00", b"b"])
            for _ in range(rng.randint(1, 8))
        ]
        calls.append(("strsort_null", (items,)))
    return calls


# Regular expressions (Phase 10): the reference is Python's re, with re.ASCII, on the subject decoded with
# surrogateescape (each ill-formed byte b is the character U+DC00 + b, as StringiFor's code of that unit).
REGEX_FLAGS = {"i": re.IGNORECASE, "m": re.MULTILINE, "s": re.DOTALL}
HEXDIGITS = set(b"0123456789abcdefABCDEF")


def to_python_pattern(pattern: bytes) -> str:
    """Translate a StringiFor pattern for Python: \\z is \\Z, \\xHH above 7F (a byte) is \\udcHH."""
    out, i = [], 0
    while i < len(pattern):
        if pattern[i] == 0x5C and i + 1 < len(pattern):
            nxt = pattern[i + 1 : i + 2]
            if nxt == b"z":
                out.append(b"\\Z")
                i += 2
                continue
            if (
                nxt == b"x"
                and len(pattern) >= i + 4
                and all(c in HEXDIGITS for c in pattern[i + 2 : i + 4])
            ):
                value = int(pattern[i + 2 : i + 4], 16)
                out.append(b"\\x%02x" % value if value < 0x80 else b"\\udc%02x" % value)
                i += 4
                continue
            out.append(pattern[i : i + 2])
            i += 2
            continue
        out.append(pattern[i : i + 1])
        i += 1
    return b"".join(out).decode("utf-8", "surrogateescape")


def char_offsets(data: bytes) -> list[int]:
    """1-based byte position of each character of data decoded with surrogateescape, and len + 1 at the end."""
    offsets, position = [], 1
    for unit in units(data):
        offsets.append(position)
        position += len(unit)
    offsets.append(position)
    return offsets


def regex_run(
    pattern: bytes, flags: bytes, subject: bytes, start: int, how: str
) -> str | list[int]:
    """The match as the driver writes it: "E" on a compile error, "-" if none, else the byte spans of all groups."""
    mode = re.ASCII
    for letter in flags.decode():
        mode |= REGEX_FLAGS[letter]
    try:
        compiled = re.compile(to_python_pattern(pattern), mode)
    except (re.error, OverflowError, RecursionError):
        return "E"
    offsets = char_offsets(subject)
    pos = offsets.index(start) if start in offsets else len(offsets) - 1
    method = {
        "search": compiled.search,
        "match": compiled.match,
        "fullmatch": compiled.fullmatch,
    }[how]
    found = method(text(subject), pos)
    if found is None:
        return "-"
    spans = []
    for group in range(compiled.groups + 1):
        first, end = found.span(group)
        spans += [0, -1] if first < 0 else [offsets[first], offsets[end] - 1]
    return spans


REGEX_ATOMS = [
    b"a",
    b"b",
    b"A",
    b"x",
    b"-",
    b" ",
    b"\n",
    "é".encode(),
    "\U0001f600".encode(),
    b"\xff",
    b".",
    b"\\d",
    b"\\w",
    b"\\s",
    b"\\D",
    b"\\W",
    b"\\S",
    b"\\.",
    b"\\-",
    b"\\xff",
    b"\\x41",
    b"\\u00e9",
    b"[ab]",
    b"[^a]",
    b"[a-c]",
    b"[\\d_]",
    b"[\\W]",
    b"[^\\s]",
    b"[]a]",
    b"[-a]",
    b"[a-]",
    "[é-\U0001f600]".encode(),
    b"[\\x80-\\xff]",
    b"[^\\n]",
    b"[A-Z]",
    b"^",
    b"$",
    b"\\b",
    b"\\B",
    b"\\A",
    b"\\z",
]
REGEX_QUANTIFIERS = [
    b"*",
    b"+",
    b"?",
    b"{2}",
    b"{1,}",
    b"{,2}",
    b"{0,1}",
    b"{1,3}",
    b"{0}",
    b"{",
]
REGEX_SUBJECT_UNITS = [
    b"a",
    b"b",
    b"A",
    b"x",
    b"-",
    b" ",
    b"\n",
    b"_",
    b"1",
    "é".encode(),
    "\U0001f600".encode(),
    b"\xff",
    b"\xe9",
    b"\x00",
    b".",
]


def random_pattern(rng: random.Random, depth: int = 0) -> bytes:
    """A random pattern of the supported syntax (and, at times, of a malformed one)."""
    items = []
    for _ in range(rng.randint(1, 4)):
        pick = rng.random()
        if pick < 0.2 and depth < 3:
            opener = rng.choice([b"(", b"(?:", b"(?P<g%d>" % rng.randrange(100)])
            item = opener + random_pattern(rng, depth + 1) + b")"
        else:
            item = rng.choice(REGEX_ATOMS)
        if rng.random() < 0.35:
            item += rng.choice(REGEX_QUANTIFIERS)
            if rng.random() < 0.3:
                item += b"?"
        items.append(item)
    pattern = b"".join(items)
    if rng.random() < 0.25:
        pattern += b"|" + random_pattern(rng, depth + 1)
    if depth == 0 and rng.random() < 0.05:
        pattern = (
            rng.choice(
                [b"(", b")", b"[", b"\\", b"*", b"a{2,1}", b"\\q", b"(?=a)", b"\\1"]
            )
            + pattern
        )
    return pattern


def random_subject(rng: random.Random) -> bytes:
    """A random subject over units the patterns use."""
    return b"".join(rng.choice(REGEX_SUBJECT_UNITS) for _ in range(rng.randint(0, 10)))


REGEX_FIXED = [
    (b"(|a)*", b"aa"),
    (b"(|a)+", b"aa"),
    (b"(a|)*", b"aa"),
    (b"(a*)*", b"aab"),
    (b"(a*?)*", b"aa"),
    (b"(a?)*?$", b"aa"),
    (b"(?:a|())*", b"aa"),
    (b"a|ab", b"ab"),
    (b"(a+)(b*)", b"aaab"),
    (b"(a+?)(b*)", b"aaab"),
    (b"x*", b"abxd"),
    (b"\\bfoo\\b", b"a foo."),
    (b"^a$", b"a\n"),
    (b"a$", b"a\nb"),
    (b"(?m)^b", b"a\nb"),
    (b"(?s)a.b", b"a\nb"),
    (b"(?i)[a-c]+", b"xAbC"),
    (b"(?i)\xc3\xa9", "É".encode()),
    (b"\\x41\\xff", b"A\xff"),
    (b".", b"\xe2\x82"),
    (b"[^a]+", b"\xff\xfe"),
    (b"(a)|b", b"b"),
    (b"(?P<x>\\w+)=(?P<y>\\d*)", b"k=12;"),
    (b"a{2,3}?", b"aaaa"),
    (b"a{,2}", b"aaa"),
    (b"a{", b"a{"),
    (b"x{}", b"x{}"),
    (b"\\d+\\.?\\d*", b"v1.25"),
]


def regex_calls(data: bytes, rng: random.Random) -> list[tuple[Arg, ...]]:
    """Calls (pattern, flags, subject, start): a random pattern on the corpus string and on random subjects."""
    calls = []
    for subject in (data, random_subject(rng), random_subject(rng)):
        pattern = random_pattern(rng)
        flags = b"".join(f for f in (b"i", b"m", b"s") if rng.random() < 0.2)
        starts = char_offsets(subject)
        calls.append((pattern, flags, subject, 1))
        calls.append((pattern, flags, subject, rng.choice(starts)))
    return calls


def regex_extra() -> list[tuple[str, tuple[Arg, ...]]]:
    """The classic cases on the three ways of matching, and many random patterns on random subjects."""
    rng = random.Random(SEED)
    calls: list[tuple[str, tuple[Arg, ...]]] = []
    for pattern, subject in REGEX_FIXED:
        for name in ("re_search", "re_match", "re_fullmatch"):
            calls.append((name, (pattern, b"", subject, 1)))
    for _ in range(6000):
        pattern, subject = random_pattern(rng), random_subject(rng)
        flags = b"".join(f for f in (b"i", b"m", b"s") if rng.random() < 0.2)
        calls.append(
            (
                rng.choice(["re_search", "re_search", "re_match", "re_fullmatch"]),
                (pattern, flags, subject, 1),
            )
        )
        name = rng.choice(["re_findall", "re_split", "re_sub", "re_subn"])
        count = rng.choice([0, 0, 1, 3])
        calls.append(
            (name, (pattern, flags, subject, count, rng.choice(REGEX_TEMPLATES)))
        )
    return calls


def regex_compiled(pattern: bytes, flags: bytes) -> re.Pattern[str] | None:
    """The Python pattern, None if it does not compile."""
    mode = re.ASCII
    for letter in flags.decode():
        mode |= REGEX_FLAGS[letter]
    try:
        return re.compile(to_python_pattern(pattern), mode)
    except (re.error, OverflowError, RecursionError):
        return None


def regex_findall(pattern: bytes, flags: bytes, subject: bytes) -> str | list[bytes]:
    """findall: group 1 if there is exactly one group, else 0; a group that did not match is empty."""
    compiled = regex_compiled(pattern, flags)
    if compiled is None:
        return "E"
    group = 1 if compiled.groups == 1 else 0
    return [raw(m.group(group) or "") for m in compiled.finditer(text(subject))]


def regex_split(
    pattern: bytes, flags: bytes, subject: bytes, maxsplit: int
) -> str | list[bytes | None]:
    """split, a group that did not match is None (a not allocated string)."""
    compiled = regex_compiled(pattern, flags)
    if compiled is None:
        return "E"
    return [
        None if piece is None else raw(piece)
        for piece in compiled.split(text(subject), maxsplit)
    ]


def regex_sub(
    pattern: bytes,
    flags: bytes,
    subject: bytes,
    count: int,
    template: bytes,
    nsub: bool,
) -> str | bytes | int:
    """sub (the result) or subn (the number of replacements); "E" if the pattern or the template is malformed."""
    compiled = regex_compiled(pattern, flags)
    if compiled is None:
        return "E"
    try:
        result, n = compiled.subn(text(template), text(subject), count)
    except (re.error, IndexError):
        return "E"
    return n if nsub else raw(result)


BS = b"\\"
REGEX_TEMPLATES = [
    b"-",
    b"",
    b"[" + BS + b"g<0>]",
    b"<" + BS + b"1>",
    BS + b"g<1>" + BS + b"g<1>",
    BS + b"n",
    BS + BS,
    BS + b"-",
    BS + b"q",
    BS + b"9",
    BS + b"g<g5>",
    BS + b"g<x",
    BS + b"0",
    "\u00e9".encode(),
    BS + b"g<2>",
    b"a" + BS + b"tb",
    BS + b"12",
]


def regex_op_calls(data: bytes, rng: random.Random) -> list[tuple[Arg, ...]]:
    """Calls (pattern, flags, subject, count or maxsplit, template)."""
    calls = []
    for subject in (data, random_subject(rng)):
        pattern = random_pattern(rng)
        flags = b"".join(f for f in (b"i", b"m", b"s") if rng.random() < 0.2)
        calls.append(
            (
                pattern,
                flags,
                subject,
                rng.choice([0, 0, 1, 2]),
                rng.choice(REGEX_TEMPLATES),
            )
        )
    return calls


def check_regex_reference() -> list[str]:
    """The translation keeps the meaning: a few patterns with the expected Python result."""
    failures = []
    cases_ = [
        (b"\\xff", b"\xff", [1, 1]),
        (b"\\x41", b"A", [1, 1]),
        (b"a\\z", b"a\n", "-"),
        (b"a$", b"a\n", [1, 1]),
        (b".", "\U0001f600".encode(), [1, 4]),
        (b"[\\x80-\\xff]+", b"\x80\xff", [1, 2]),
    ]
    for pattern, subject, expected in cases_:
        got = regex_run(pattern, b"", subject, 1, "search")
        if got != expected:
            failures.append(
                f"reference: {pattern!r} on {subject!r} gives {got!r}, not {expected!r}"
            )
    return failures


# ---------------------------------------------------------------------------------------------------- numbers suite
NUMBER_RE = re.compile(
    rb"[ \t]*([+-]?)(?:(\d+\.?\d*|\.\d+)(?:[eEdD]([+-]?\d+)|(?<=[.\d])([+-]\d{3}))?)[ \t]*\Z"
)
SPECIAL_RE = re.compile(
    rb"[ \t]*([+-]?)(?:(inf|infinity)|(nan(?:\([0-9A-Za-z_]*\))?))[ \t]*\Z", re.IGNORECASE
)
NUMBERS_DEFAULT = 200_000


def parse_number(data: bytes) -> tuple[str, int, Fraction | None] | None:
    """Return (kind, sign, value) of a number string: kind is finite, inf or nan; None if it is not a number."""
    found = SPECIAL_RE.match(data)
    if found:
        sign = -1 if found[1] == b"-" else 1
        return ("inf", sign, None) if found[2] else ("nan", sign, None)
    found = NUMBER_RE.match(data)
    if not found:
        return None
    mantissa = found[2].decode()
    letterless = found[4]
    if letterless and "." not in mantissa:
        return None
    exponent = int(found[3] or letterless or 0)
    whole, _, fraction = mantissa.partition(".")
    value = Fraction(int((whole + fraction) or "0")) * Fraction(10) ** (exponent - len(fraction))
    return "finite", -1 if found[1] == b"-" else 1, value


def round_binary(value: Fraction, bits: int, min_exponent: int, max_exponent: int) -> tuple[int, int] | None:
    """Round a positive value to (m, e), value ~ m * 2**e, half to even; None on overflow."""
    e = value.numerator.bit_length() - value.denominator.bit_length() - bits
    while value >= Fraction(2) ** (e + bits):
        e += 1
    while value < Fraction(2) ** (e + bits - 1):
        e -= 1
    e = max(e, min_exponent)
    scaled = value / Fraction(2) ** e
    m = round(scaled)  # round() of a Fraction is half to even
    if m == 2**bits:
        m, e = 2 ** (bits - 1), e + 1
    return None if e > max_exponent else (m, e)


def number_bits(data: bytes, width: int) -> str:
    """Return the bits of the correctly rounded number, nan, or E if it is not a number."""
    parsed = parse_number(data)
    if parsed is None:
        return "E"
    kind, sign, value = parsed
    if kind == "nan":
        return "nan"
    bits, min_exponent, max_exponent, fraction_bits, exponent_bias = (
        (53, -1074, 971, 52, 1023) if width == 64 else (24, -149, 104, 23, 127)
    )
    infinity = ((1 << (width - fraction_bits - 1)) - 1) << fraction_bits
    code = infinity
    if kind == "finite":
        if value == 0:
            code = 0
        else:
            rounded = round_binary(value, bits, min_exponent, max_exponent)
            if rounded is not None:
                m, e = rounded
                if m < 1 << (bits - 1):
                    code = m
                else:
                    code = ((e - min_exponent + 1) << fraction_bits) | (m & ((1 << fraction_bits) - 1))
    if sign < 0:
        code |= 1 << (width - 1)
    return f"{code:0{width // 4}X}"


def is_real_reference(data: bytes) -> bool:
    """Return whether the string is a real: a number with a point or an exponent, or a special value."""
    parsed = parse_number(data)
    return parsed is not None and (parsed[0] != "finite" or bool(re.search(rb"[.eEdD]", data)))


def is_number_reference(data: bytes) -> bool:
    """Return whether the string is a number."""
    return parse_number(data) is not None


def shortest_r8_reference(code: bytes) -> str:
    """Return Python's repr of the double with those bits."""
    return repr(struct.unpack(">d", code)[0])


def shortest_r4_reference(code: bytes) -> str:
    """Return the shortest closest decimal of the float with those bits, found by exact search, in the layout of repr."""
    value = struct.unpack(">f", code)[0]
    if value != value or value in (float("inf"), float("-inf")) or value == 0:
        return repr(value)
    exact = abs(Fraction(value))
    target = f"{struct.unpack('>I', struct.pack('>f', abs(value)))[0]:08X}"
    for precision in range(1, 10):
        text = f"{float(exact):.{precision - 1}e}"
        scale = Fraction(10) ** (int(text.split("e")[1]) - precision + 1)
        low = int(exact / scale)
        best = None
        for m in (low, low + 1):
            candidate = Fraction(m) * scale
            if candidate and float32_bits(candidate) == target:
                distance = abs(candidate - exact)
                if best is None or distance < best[0] or (distance == best[0] and m % 2 == 0):
                    best = (distance, m)
        if best is not None:
            return layout_repr(value < 0, best[1], int(text.split("e")[1]) - precision + 1)
    raise AssertionError(code)


def float32_bits(value: Fraction) -> str:
    """Return the bits of the binary32 nearest to a positive value."""
    rounded = round_binary(value, 24, -149, 104)
    if rounded is None:
        return "7F800000"
    m, e = rounded
    return f"{m if m < 1 << 23 else ((e + 150) << 23) | (m & ((1 << 23) - 1)):08X}"


def layout_repr(negative: bool, digits: int, exponent: int) -> str:
    """Return digits * 10**exponent in the layout of repr."""
    while digits % 10 == 0:
        digits //= 10
        exponent += 1
    text = str(digits)
    point = len(text) + exponent
    if -3 <= point <= 16:
        if point <= 0:
            body = "0." + "0" * -point + text
        elif point >= len(text):
            body = text + "0" * (point - len(text)) + ".0"
        else:
            body = text[:point] + "." + text[point:]
    else:
        body = text[0] + ("." + text[1:] if len(text) > 1 else "") + f"e{point - 1:+03d}"
    return "-" + body if negative else body


def levenshtein(first: Sequence, second: Sequence) -> int:
    """Return the Levenshtein distance, on the full table."""
    table = [[0] * (len(second) + 1) for _ in range(len(first) + 1)]
    for i in range(len(first) + 1):
        table[i][0] = i
    for j in range(len(second) + 1):
        table[0][j] = j
    for i in range(1, len(first) + 1):
        for j in range(1, len(second) + 1):
            table[i][j] = min(table[i - 1][j] + 1, table[i][j - 1] + 1, table[i - 1][j - 1] + (first[i - 1] != second[j - 1]))
    return table[-1][-1]


def edit_pairs(data: bytes, rng: random.Random) -> list[tuple[Arg, ...]]:
    """Return the data, cut to a size the full table can take, with an edited copy and an unrelated string."""
    pieces = units(data)[:60]
    data = b"".join(pieces)
    edited = list(pieces)
    for _ in range(rng.randint(0, 5)):
        action = rng.randrange(3)
        at = rng.randint(0, len(edited))
        if action == 0:
            edited.insert(at, rng.choice(POOL)[0])
        elif edited and at < len(edited):
            if action == 1:
                del edited[at]
            else:
                edited[at] = rng.choice(POOL)[0]
    return [(data, b"".join(edited)), (data, b""), (b"", data), (data, b"kitten")]


def numbers_extra() -> list[tuple[str, tuple[Arg, ...]]]:
    """Return the calls of the numbers suite: hard reals, bounds, midpoints, the forms accepted and the rejected."""
    rng = random.Random(SEED)
    total = int(os.environ.get("SF_ORACLE_NUMBERS", NUMBERS_DEFAULT))
    texts = [
        "0.1", "1e23", "8.41e21", "2.2250738585072014e-308", "2.2250738585072011e-308", "5e-324", "2.4703282292062328e-324",
        "2.4703282292062327e-324", "4.9406564584124654e-324", "1.7976931348623157e308", "1.7976931348623158e308",
        "1.7976931348623159e308", "1e308", "1e309", "1e-400", "0e999", "-0.0", "-0e-999", "9007199254740993.0",
        "9007199254740992.5", "16777217.0", "16777219.0", "1.17549435e-38", "1.4e-45", "7e-46", "7.1e-46", "3.4028235e38",
        "3.4028236e38", "3.40282367e38", "1e100000", "1e-100000", "1e999999", "1.5e-999999", "0e999999", "1.5-301", "1.5+301", "-.5-101", "5.-101", "1.5-301 ", " \t1.5-301", "1.5d-301", "1.5D+3",
        "12", "+12", "-12 ", "1.", ".5", "+.5", "1e5", "1E5", "1d5", "1.5e+3", "1.5e-3",
        "12x", "1.5.6", "1-2", "2026-11", "2026-11-01", "1.5-30", "1.5-3011", "1.5-30x", "", "   ", "e5", ".", "+", "-", "1e", "1e+",
        "nan", "NaN", "NAN", "-nan", "+nan", " nan ", "nan()", "nan(abc_1)", "NaN(0)", "nan(", "nan)", "nan(a b)", "nanx", "na", "n",
        "inf", "Inf", "INF", "-inf", "+Infinity", "INFINITY", " inf\t", "infi", "infinit", "infinityy", "in", "i",
    ]
    fractions = [str(n) for n in (2**53 + 1, 2**53 + 3, 2**54 + 2, 2**24 + 1, 2**24 + 3, 2**25 + 2)]
    texts += [f + ".0" for f in fractions]
    while len(texts) < total:
        k = rng.randrange(9)
        if k == 0:  # any double, shortest
            texts.append(repr(struct.unpack(">d", rng.getrandbits(64).to_bytes(8, "big"))[0]))
        elif k == 1:  # any double, 17 digits, as a program writes it
            value = struct.unpack(">d", rng.getrandbits(64).to_bytes(8, "big"))[0]
            texts.append(f"{value:.16e}")
        elif k == 2:  # any float, 9 digits
            value = struct.unpack(">f", rng.getrandbits(32).to_bytes(4, "big"))[0]
            texts.append(f"{value:.8e}")
        elif k == 3:  # up to 18 digits, any exponent: the Eisel-Lemire path
            digits = "".join(rng.choice("0123456789") for _ in range(rng.randint(1, 18)))
            at = rng.randint(0, len(digits))
            texts.append(f"{digits[:at]}.{digits[at:]}e{rng.randint(-360, 330)}")
        elif k == 4:  # up to 18 digits around the bounds of the binary32
            digits = "".join(rng.choice("0123456789") for _ in range(rng.randint(1, 18)))
            texts.append(f"{digits}e{rng.randint(-70, 45)}")
        elif k == 5:  # a midpoint of two doubles or two floats of at most 18 digits
            width = rng.choice((53, 24))
            n = (2 * rng.getrandbits(width - 1) + 1) | (1 << width)
            texts.append(f"{n << rng.randint(0, 59 - width)}.0" if width == 53 else f"{n << rng.randint(0, 30)}.0")
        elif k == 6:  # the exponent without its letter
            texts.append(f"{rng.random() * 9 + 1:.{rng.randint(0, 16)}f}{rng.choice('+-')}{rng.randint(100, 330)}")
        elif k == 7:  # the exact midpoint of two floats, or just off it: only all the digits settle these
            width, low_exponent, high_exponent = rng.choice(((53, -1074, 960), (24, -149, 100)))
            m = rng.getrandbits(width) | 1
            value = Fraction(m) * Fraction(2) ** rng.randint(low_exponent - 1, high_exponent)
            digits = str(value.numerator * 5 ** max(0, value.denominator.bit_length() - 1))
            exponent = -(value.denominator.bit_length() - 1)
            tail = rng.choice(("", "1", "0000000000000000000001"))
            if tail:
                digits, exponent = digits + tail, exponent - len(tail)
            texts.append(f"{digits}e{exponent}")
        else:  # more than 18 digits: read
            digits = "".join(rng.choice("0123456789") for _ in range(rng.randint(19, 30)))
            texts.append(f"{digits[0]}.{digits[1:]}e{rng.randint(-340, 320)}")
    calls: list[tuple[str, tuple[Arg, ...]]] = []
    for text in texts:
        data = text.encode()
        calls += [("to_r8", (data,)), ("to_r4", (data,))]
        if "e" not in text[1:] or rng.random() < 0.1:
            calls += [("is_real", (data,)), ("is_number", (data,))]
    specials8 = [0, 1 << 63, 0x7FF << 52, 0xFFF << 52, 0x7FF8 << 48, 1, (1 << 52) - 1, 1 << 52, (0x7FF << 52) - 1, 3 << 52]
    specials4 = [0, 1 << 31, 0xFF << 23, 0x1FF << 23, 0x7FC << 20, 1, (1 << 23) - 1, 1 << 23, (0xFF << 23) - 1]
    specials8 += [(e << 52) for e in range(1, 2047)]  # the powers of 2: the rounding interval is asymmetric
    specials4 += [(e << 23) for e in range(1, 255)]
    specials8 += [struct.unpack(">Q", struct.pack(">d", float(10**e)))[0] for e in range(23)]
    specials8 += [struct.unpack(">Q", struct.pack(">d", float(n)))[0] for n in (9007199254740993, 2**53, 123456789012345678)]
    for _ in range(total // 2):
        specials8.append(rng.getrandbits(64))
        specials4.append(rng.getrandbits(32))
    calls += [("shortest_r8", (c.to_bytes(8, "big"),)) for c in specials8]
    calls += [("shortest_r4", (c.to_bytes(4, "big"),)) for c in specials4[: max(len(specials4) // 10, 5000)]]
    return calls


EXTRA = {
    "numbers": numbers_extra,
    "utf8": utf8_exhaustive,
    "escape": escape_extra,
    "units": units_extra,
    "columns": columns_extra,
    "xml": xml_extra,
    "whitespace": whitespace_extra,
    "sort": sort_extra,
    "regex": regex_extra,
}
SELF_CHECKS = {
    "escape": check_escape_reference,
    "xml": check_xml_reference,
    "whitespace": check_space_reference,
    "sort": check_sort_reference,
    "regex": check_regex_reference,
}


SUITES: dict[str, list[Op]] = {
    "edit": [
        Op("edit_distance", edit_pairs, lambda d, t: levenshtein(d, t)),
        Op("edit_distance_chars", edit_pairs, lambda d, t: levenshtein(units(d), units(t))),
    ],
    "numbers": [
        Op("to_r8", lambda d, r: [], lambda d: number_bits(d, 64)),
        Op("to_r4", lambda d, r: [], lambda d: number_bits(d, 32)),
        Op("is_real", lambda d, r: [], is_real_reference),
        Op("shortest_r8", lambda d, r: [], lambda c: shortest_r8_reference(c)),
        Op("shortest_r4", lambda d, r: [], lambda c: shortest_r4_reference(c)),
        Op("is_number", lambda d, r: [], is_number_reference),
    ],
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
    "regex": [
        Op(
            "re_search", regex_calls, lambda p, f, d, s: regex_run(p, f, d, s, "search")
        ),
        Op("re_match", regex_calls, lambda p, f, d, s: regex_run(p, f, d, s, "match")),
        Op(
            "re_fullmatch",
            regex_calls,
            lambda p, f, d, s: regex_run(p, f, d, s, "fullmatch"),
        ),
        Op("re_findall", regex_op_calls, lambda p, f, d, n, _: regex_findall(p, f, d)),
        Op("re_split", regex_op_calls, lambda p, f, d, n, _: regex_split(p, f, d, n)),
        Op(
            "re_sub",
            regex_op_calls,
            lambda p, f, d, n, t: regex_sub(p, f, d, n, t, nsub=False),
        ),
        Op(
            "re_subn",
            regex_op_calls,
            lambda p, f, d, n, t: regex_sub(p, f, d, n, t, nsub=True),
        ),
    ],
    "sort": [
        Op("strsort", sort_lists, lambda items: sort_with(items, "bytes")),
        Op("strsort_index", sort_lists, sort_index),
        Op("strsort_nocase", sort_lists, lambda items: sort_with(items, "nocase")),
        Op("strsort_natural", sort_lists, lambda items: sort_with(items, "natural")),
        Op("strsort_null", sort_lists, lambda items: sort_with(items, "bytes")),
    ],
    "whitespace": [
        Op("is_space", spaced, is_space),
        Op("is_space_unicode", spaced, lambda d: is_space(d, unicode=True)),
        Op("strip_ws", spaced, lambda d: strip_space(d, "both", unicode=False)),
        Op("lstrip_ws", spaced, lambda d: strip_space(d, "left", unicode=False)),
        Op("rstrip_ws", spaced, lambda d: strip_space(d, "right", unicode=False)),
        Op("strip_ws_unicode", spaced, lambda d: strip_space(d, "both", unicode=True)),
        Op("lstrip_ws_unicode", spaced, lambda d: strip_space(d, "left", unicode=True)),
        Op(
            "rstrip_ws_unicode", spaced, lambda d: strip_space(d, "right", unicode=True)
        ),
        Op("strip_unicode_alone", spaced, lambda d: raw(text(d).strip(" "))),
        Op(
            "strip_remove_ws_unicode",
            spaced_sets,
            lambda d, m: strip_space(d, "both", unicode=True, remove=m),
        ),
        Op("compact", spaced, compact_space),
        Op("compact_unicode", spaced, lambda d: compact_space(d, unicode=True)),
        Op(
            "compact_sep_unicode",
            spaced_sets,
            lambda d, m: compact_space(d, unicode=True, sep=m),
        ),
        Op("space_each", codepoint_lists, space_each),
    ],
    "xml": [
        Op("escape_xml", single, escape_xml),
        Op("escape_xml_attribute", single, lambda d: escape_xml(d, attribute=True)),
        Op("unescape_xml", single, unescape_xml),
        Op("xml_error", single, xml_error),
        Op("xml_roundtrip", single, lambda d: d),
        Op("xml_roundtrip_attribute", single, lambda d: d),
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


def encode_item(item: bytes | int | None) -> str:
    """Encode an item of a list: integer in decimal, string in hexadecimal, "-" for a not allocated string."""
    if item is None:
        return "-"
    return str(item) if isinstance(item, int) else item.hex()


def encode_arg(arg: Arg) -> str:
    """Encode an argument for cases.txt."""
    if isinstance(arg, list):
        return ",".join(encode_item(value) for value in arg) if arg else "[]"
    return str(arg) if isinstance(arg, int) else arg.hex()


def encode_result(result: Result) -> str:
    """Encode a result as the driver writes it."""
    if isinstance(result, str):
        return result
    if isinstance(result, bool):
        return "T" if result else "F"
    if isinstance(result, int):
        return str(result)
    if isinstance(result, list):
        if not result:
            return "[]"
        return ",".join(encode_item(item) for item in result)
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
    stricter: Counter[str] = Counter()
    per_op: Counter[str] = Counter(name for name, _ in calls)
    shown = 0
    for (name, call), got in zip(calls, results, strict=True):
        expected = encode_result(reference[name](*call))
        reason = known_issue(args.compiler, name, call) if got != expected else None
        if args.suite == "regex" and got == "E" and expected != "E":
            stricter[name] += (
                1  # a pattern StringiFor rejects and Python accepts: allowed, counted
            )
        elif reason is not None:
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
    if stricter:
        print(f"patterns rejected by StringiFor only: {sum(stricter.values())} call(s)")
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
