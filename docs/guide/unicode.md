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

A character counts as one, whatever its display width: a CJK character takes two columns in a terminal, see
[display width](#display-width) for `by=SF_COLUMNS`.

## Display width

`width()` gives the number of columns a string takes in a terminal, as C `wcswidth`, and the width methods take
`by=SF_COLUMNS` to align text by columns:

<<< @/examples/snippets/display_width.f90

<<< @/examples/output/display_width.ansi{ansi}

Each unit takes:

| Columns | Units |
|---|---|
| 0 | C0 and C1 controls and DEL; zero-width characters: General_Category Mn, Me and Cf (but U+00AD, the soft hyphen), the Hangul jamo medial vowels and final consonants (U+1160..U+11FF, U+D7B0..U+D7FF) |
| 2 | East_Asian_Width W and F (CJK, fullwidth forms, most emoji) |
| 1 | everything else, a byte that is not part of a well-formed sequence included |

The tables are generated from the Unicode Character Database 17.0.0 (`scripts/utf8/gen_unicode_tables.py`). Grapheme
clusters are not considered: an emoji sequence joined by U+200D counts each of its emoji.

Compared with the Python package [wcwidth](https://pypi.org/project/wcwidth/) 0.9.4, 5374 of the 1112064 scalar values
differ (`python scripts/utf8/wcwidth_report.py` with wcwidth installed). 4796 of them are unassigned in Unicode 17.0,
wcwidth following Unicode 18.0. The others are choices: wcwidth gives 0 to the spacing marks (Mc, 471 codepoints), to
U+2028, U+2029 and the Hangul fillers U+3164 and U+FFA0, 1 to 13 visible format characters (Cf, such as U+0600), 2 to
the 26 regional indicators U+1F1E6..U+1F1FF, and -1 (not printable) to the 64 controls.


## Whitespace

By default the whitespace is ASCII: space, TAB, LF, VT, FF and CR, as C `isspace`. Text copied from web pages,
word processors or CJK documents also holds no-break spaces (U+00A0), typographic spaces (U+2000..U+200A) and the
ideographic space (U+3000). `unicode=.true.` makes `is_space`, `compact` and, with `whitespace=.true.`, `strip`,
`lstrip` and `rstrip` use the Unicode White_Space property instead.

<<< @/examples/snippets/unicode_space-strip.f90

<<< @/examples/snippets/unicode_space-words.f90

<<< @/examples/output/unicode_space.ansi{ansi}

White_Space (UCD 17.0.0, `PropList.txt`) is the 6 ASCII characters above, U+0085 (NEL), U+00A0, U+1680,
U+2000..U+200A, U+2028, U+2029, U+202F, U+205F and U+3000: 25 characters. A byte that is not part of a well-formed
sequence is never whitespace, and neither are the characters that only look empty: the zero width space U+200B,
the word joiner U+2060 and the byte order mark U+FEFF (strip the BOM with `skip_bom=` when reading a file).
`unicode` has no effect on `strip`, `lstrip` and `rstrip` without `whitespace=.true.`.

::: info Python
Python's `str.isspace`, `str.split()` and `str.strip()` also treat U+001C..U+001F (the ASCII information separators)
as whitespace, which White_Space does not. `bytes.split()` and `bytes.strip()` use the 6 ASCII characters, as the
default here.
:::

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

## XML escaping

`escape_xml` makes any text safe as the content of an XML (or HTML) element or as an attribute value; `unescape_xml`
reads the references back.

<<< @/examples/snippets/xml_escape-write.f90

<<< @/examples/snippets/xml_escape-read.f90

<<< @/examples/output/xml_escape.ansi{ansi}

`escape_xml()` writes `& < > " '` as `&amp; &lt; &gt; &quot; &apos;`, so the result fits an element and an attribute
in either quotes. With `attribute=.true.` it also writes TAB, LF and CR as `&#9; &#10; &#13;`: a parser turns those
characters into spaces in an attribute value (and a CR, or a CR LF, into a LF anywhere), so only references keep
them. Use it for attribute values, and for element content whose CRs matter. Every other byte is kept, non-ASCII text
and ill-formed UTF-8 included, so `unescape_xml(escape_xml(s))` is `s` for any bytes.

`unescape_xml()` expands the 5 predefined entities and the character references `&#N;` (decimal) and `&#xH;`
(hexadecimal, either case of digits), each giving a codepoint in UTF-8. The `&` of a malformed reference is kept as it
is and `xml_error()` gives its byte position, 0 if there is none. Malformed is a bare `&` (as in `R&D`), a missing
`;`, an entity that XML does not predefine (`&nbsp;` belongs to HTML; a DTD's own entities are not read), an
uppercase `&#X`, and a value that is not a Unicode scalar value or is 0. Nothing else is interpreted: markup, CDATA
sections and comments are left as they are, and line ends are not normalized.

::: warning Controls in XML
XML 1.0 has no way to write the C0 controls other than TAB, LF and CR (U+0001..U+0008, U+000B, U+000C,
U+000E..U+001F), not even as references, nor U+0000, U+FFFE and U+FFFF. `escape_xml` keeps them as they are, so text
holding one gives a document that an XML 1.0 parser rejects: remove or replace them first if they can occur (for
example with `escape_c`, which writes them as `\xHH`). `unescape_xml` reads `&#1;`..`&#x1F;` as XML 1.1 does; an XML
1.0 parser rejects them. `&#0;` is malformed in every version.
:::

These methods are checked against Python on a corpus of byte strings, on every 2-byte string and on the whole
codespace (`bash scripts/oracle.sh utf8`), and the escapes on random texts, with the reference itself checked against
Python's `unicode_escape` codec, and on the round trip of every 2-byte string (`bash scripts/oracle.sh escape`). The XML
methods are checked the same way (`bash scripts/oracle.sh xml`), with the reference checked against Python's
`xml.sax.saxutils` and against expat, an XML parser, which must read every escaped string back unchanged and reject
every malformed reference. The whitespace methods are checked against White_Space read from the
pinned UCD, on spaced corpus strings and on every scalar value (`bash scripts/oracle.sh whitespace`).
