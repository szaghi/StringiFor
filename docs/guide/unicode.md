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

## Methods that work on characters

These methods treat a unit as one character, so they never cut a character in two; their positions are still byte
positions, usable with `raw(i:j)`:

<<< @/examples/snippets/utf8_units.f90

<<< @/examples/output/utf8_units.ansi{ansi}

| Method | By units |
|---|---|
| `reverse()` | the units are reversed, the bytes of each keep their order |
| `match(pattern)` | `?` and a class `[...]` match one unit; a range compares codepoints |
| `scan(set)`, `verify(set)` | `set` is a set of units; the result is the byte position of the first byte of the unit found |
| `strip`, `lstrip`, `rstrip` with `remove=` | `remove` is a set of units |
| `squeeze([set])` | runs of a repeated unit are reduced; `set` is a set of units |
| `transliterate(old_set, new_set)` | the k-th unit of `old_set` becomes the k-th unit of `new_set`, so the result can be longer |

The other methods need no change: UTF-8 is self-synchronising, so a well-formed substring can only match at a
character boundary, and `index`, `count`, `replace`, `split`, `partition`, `start_with`, `end_with` give the same
results whether the text is read as bytes or as characters. On ASCII text every method gives what it always gave.

## Positions and widths in characters

Positions, lengths and widths count bytes by default, as the Fortran intrinsics, so they can always be used with
`raw(i:j)`. The optional argument `by=SF_CHARS` counts characters instead; `SF_BYTES` is the default.

<<< @/examples/snippets/by_chars.f90

<<< @/examples/output/by_chars.ansi{ansi}

| Methods | With `by=SF_CHARS` |
|---|---|
| `len`, `len_last_word` | the length in characters |
| `index`, `scan`, `verify` | the number of the character holding the byte found (0 if none) |
| `slice(first, last, stride)`, `insert(substring, pos)` | the positions count characters, which are never cut |
| `center`, `ljust`, `rjust`, `fill`, `justify`, `expand_tabs` | the width counts characters |
| `byte_pos(char_pos)`, `char_pos(byte_pos)` | (always) convert a position from one unit to the other |

A character counts as one, whatever its display width: a CJK character takes two columns in a terminal (display
widths come later, [#51](https://github.com/szaghi/StringiFor/issues/51)).

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

## C escapes

`unescape_c` expands C-style escapes, so non-ASCII text can be written in ASCII source; `escape_c` writes any bytes
as printable ASCII, for logs and diagnostics, and `unescape_c` reads them back exactly.

<<< @/examples/snippets/c_escapes-literal.f90

<<< @/examples/snippets/c_escapes-log.f90

<<< @/examples/snippets/c_escapes-errors.f90

<<< @/examples/output/c_escapes.ansi{ansi}

| Escape | Gives |
|---|---|
| `\\` `\'` `\"` | a backslash, a quote |
| `\a` `\b` `\f` `\n` `\r` `\t` `\v` | BEL, BS, FF, LF, CR, TAB, VT |
| `\e` | ESC |
| `\0` to `\377` | one **byte**, 1 to 3 octal digits |
| `\xHH` | one **byte**, exactly 2 hexadecimal digits |
| `\uXXXX`, `\UXXXXXXXX` | one **codepoint** encoded in UTF-8, exactly 4 or 8 hexadecimal digits; not a surrogate, at most U+10FFFF |

`\xHH` and the octal escapes give a byte, as in C, not a codepoint as in Python: `\xe9` is the byte E9 (Latin-1 `é`),
`\u00e9` is `é` in UTF-8. So any bytes, ill-formed UTF-8 included, can be written, and `escape_c` is exact: it writes
`\\` for a backslash, the short escapes for the usual controls, `\xHH` for the other controls, for DEL and for the
bytes that are not part of a well-formed sequence, `\uXXXX` or `\UXXXXXXXX` (lowercase digits) for the other
characters. With `ascii=.false.` the well-formed characters are kept, except the C1 controls U+0080..U+009F. Quotes
are not escaped.

The backslash of a malformed escape (an unknown one, too few digits, a surrogate, a value too large) is kept as it is;
`escapes_error()` gives the byte position of the first one, 0 if there is none.

::: warning Backslashes in Fortran source
gfortran and ifx keep a backslash in a character literal as it is (unless `-fbackslash`, or `-assume bscc`), so
`'caf\u00e9'` reaches `unescape_c` unchanged. nvfortran reads backslash escapes in literals by default: compile with
`-Mbackslash`, or write the backslash as `char(92)`.
:::

These methods are checked against Python on a corpus of byte strings, on every 2-byte string and on the whole
codespace (`bash scripts/oracle.sh utf8`), and the escapes on random texts, with the reference itself checked against
Python's `unicode_escape` codec, and on the round trip of every 2-byte string (`bash scripts/oracle.sh escape`).
