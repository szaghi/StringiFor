---
title: Unicode and UTF-8
---

# Unicode and UTF-8

A `string` holds bytes. Text in UTF-8, the encoding of almost every file and terminal today, is stored as it is:
`'café'` is 5 bytes, because `é` is the two bytes `C3 A9`. Positions and lengths (`len`, `index`, `slice`, ...) count
bytes, as the Fortran intrinsics do, so they can always be used with `raw(i:j)`.

The methods on this page read the bytes as UTF-8. They work on *units*: a unit is either a well-formed UTF-8 sequence
(one codepoint) or a single byte that is not part of one. Well-formed is Unicode's
[Table 3-7](https://www.unicode.org/versions/latest/core-spec/chapter-3/#G27506): no overlong form (`C0 AF` is not a
`/`), no surrogate (`ED A0 80`), nothing above U+10FFFF, no truncated sequence, no stray continuation byte. A byte that
is not part of a well-formed sequence is never merged with its neighbours, dropped or rewritten, unless you ask for it
with `to_valid_utf8`: Latin-1 text and binary data go through unchanged.

## Checking and inspecting

<<< @/examples/snippets/utf8_check-inspect.f90

| Method | Returns |
|---|---|
| `is_utf8()` | true if the string is well-formed UTF-8 (ASCII is; an empty string is) |
| `utf8_error()` | the byte position of the first byte that is not part of a well-formed sequence, 0 if none |
| `codepoints()` | the codepoints, one per unit, as an `integer(I4P)` array; a byte that is not part of a well-formed sequence is returned as minus its value, -255..-128 |
| `from_codepoints(codes)` | (module procedure) the string encoded from codepoints; -255..-128 give back the raw byte, any other value that is not a Unicode scalar value gives U+FFFD |

`from_codepoints(s%codepoints())` gives back `s` for any bytes.

## Repairing

<<< @/examples/snippets/utf8_check-repair.f90

<<< @/examples/output/utf8_check.ansi{ansi}

`to_valid_utf8([replacement])` replaces each ill-formed sequence by U+FFFD, or by `replacement`. As Unicode recommends
(chapter 3.9) and Python's `errors='replace'` does, a truncated sequence is replaced once as a whole (`E4 BD` gives one
U+FFFD), and each byte that cannot start a sequence is replaced on its own (`C0 AF` gives two).

These methods are checked against Python on a corpus of byte strings, on every 2-byte string and on the whole
codespace (`bash scripts/oracle.sh utf8`).
