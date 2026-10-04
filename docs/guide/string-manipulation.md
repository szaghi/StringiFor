---
title: String Manipulation
---

# String Manipulation

All the methods are type-bound procedures of `string`. Unless stated otherwise they return a new `string` and they do
not change the one they are called on.

## Case conversion

<<< @/examples/snippets/letter_case.f90

<<< @/examples/output/letter_case.ansi{ansi}

The word-level styles split the string in words, at the blanks or at `sep`:

<<< @/examples/snippets/wordcase.f90

<<< @/examples/output/wordcase.ansi{ansi}

| Method | Result |
|---|---|
| `upper()`, `lower()`, `swapcase()` | every letter changed |
| `capitalize()` | first character upper case, the rest lower case |
| `startcase([sep])` | every word capitalized |
| `camelcase([sep])` | every word capitalized, separators removed |
| `snakecase([sep])` | every word lower case, joined by `_` |
| `is_upper()`, `is_lower()` | true if every character is an upper (lower) case letter |

## Character classes

<<< @/examples/snippets/char_classes.f90

<<< @/examples/output/char_classes.ansi{ansi}

| Method | True if all the characters are |
|---|---|
| `is_alpha()` | letters |
| `is_alnum()` | letters or digits |
| `is_digit()` | digits |
| `is_xdigit()` | hexadecimal digits, `0-9`, `a-f`, `A-F` |
| `is_punct()` | punctuation: printable, not letters, digits or space (as C `ispunct`) |
| `is_space()` | whitespace: space, tab, new line, vertical tab, form feed, carriage return (as C `isspace`) |
| `is_lower()`, `is_upper()` | not uppercase, not lowercase letters |

The classes are the ASCII ones. A null string is in no class, as in Python.

## Cleaning and replacing

<<< @/examples/snippets/strip.f90

<<< @/examples/output/strip.ansi{ansi}

`strip([remove_nulls][, remove][, whitespace])` removes the blanks at both ends; with `remove`, a set of characters, it
removes every leading and trailing character belonging to the set; `whitespace=.true.` removes tabs, new lines, vertical
tabs, form feeds and carriage returns too, as Python `str.strip()`. `lstrip([remove][, whitespace])` and
`rstrip([remove][, whitespace])` do the same at the beginning or at the end only. `remove_nulls=.true.` cuts the string at
its first null character.

<<< @/examples/snippets/replace.f90

<<< @/examples/output/replace.ansi{ansi}

| Method | Result |
|---|---|
| `replace(old, new[, count])` | every occurrence of `old` replaced by `new`, or the first `count` ones, left to right; the replaced text is not searched again |
| `unique([substring])` | every run of `substring` (default a blank) collapsed to one occurrence |
| `insert(substring, pos)` | `substring` inserted at position `pos` |
| `escape(to_escape[, esc])` | the character `to_escape` preceded by a backslash, or by `esc` |
| `unescape(to_unescape[, unesc])` | the backslash before `to_unescape` removed, or replaced by `unesc` |

<<< @/examples/snippets/escape.f90

<<< @/examples/output/escape.ansi{ansi}

<<< @/examples/snippets/tidy.f90

<<< @/examples/output/tidy.ansi{ansi}

| Method | Result |
|---|---|
| `compact([sep])` | the words separated by one `sep` (default a blank): whitespace runs collapsed, the ends removed, as Python `sep.join(s.split())` |
| `squeeze([set])` | every run of a repeated character reduced to one, only for the characters of `set` if passed, as `tr -s` |
| `expand_tabs([tab_size])` | the tabs replaced by blanks up to the next tab stop, every `tab_size` columns (default 8), as Python `str.expandtabs` |
| `transliterate(old_set, new_set)` | each character of `old_set` replaced by the one at the same position in `new_set`; a shorter `new_set` repeats its last character, a null one deletes, as `tr` |
| `quote([quote_char])` | the string between quotes (default `"`), the inner ones doubled, as Fortran list-directed output and CSV |
| `unquote()` | the inverse of `quote`, for a string starting and ending with the same `'` or `"`; any other string unchanged |

## Splitting and joining

<<< @/examples/snippets/split_words.f90

<<< @/examples/output/split_words.ansi{ansi}

`split(tokens[, sep][, max_tokens][, keep_empty])` is a subroutine: it allocates `tokens`. Repeated separators count as
one and the separators at the ends are ignored; `max_tokens` is the number of splits, the last token keeps the rest.
`split_chunked(tokens, chunks[, sep])` gives the same tokens splitting in chunks of `chunks` tokens.

With `keep_empty=.true.` nothing is collapsed and the empty fields are tokens, as Python `str.split(sep)`: the fields of
a CSV record keep their position.

<<< @/examples/snippets/csv_fields.f90

<<< @/examples/output/csv_fields.ansi{ansi}

<<< @/examples/snippets/partition.f90

<<< @/examples/output/partition.ansi{ansi}

`partition([sep])` splits once, at the first separator, into three strings.

<<< @/examples/snippets/join_strings.f90

<<< @/examples/output/join_strings.ansi{ansi}

`join(array[, sep])` joins an array of strings or of characters; the separator is `sep`, or the string itself. Elements
not allocated, or empty characters, are skipped. `strjoin(array[, sep][, is_trim][, is_col])` is the same as a function
of the module, with no separator string; `is_trim=.false.` keeps the trailing blanks of the characters.

`strjoin` also joins a 2D array, by columns or by rows:

<<< @/examples/snippets/strjoin2d.f90

<<< @/examples/output/strjoin2d.ansi{ansi}

## Slicing and reversing

<<< @/examples/snippets/slice.f90

<<< @/examples/output/slice.ansi{ansi}

`slice([first][, last][, stride])` returns the section `first:last:stride` as a `character`. `stride` defaults to 1,
`first` and `last` to the bounds of the string (`1` and `len`, or `len` and `1` when the stride is negative). The bounds
are clamped into the string: a slice never goes out of bounds, and it is empty when the section is.

<<< @/examples/snippets/reverse.f90

<<< @/examples/output/reverse.ansi{ansi}

## Searching

<<< @/examples/snippets/search.f90

<<< @/examples/output/search.ansi{ansi}

| Method | Result |
|---|---|
| `start_with(prefix[, start][, end])`, `end_with(suffix[, start][, end][, ignore_null_eof])` | true if the string, or its part `start:end`, starts (ends) with it |
| `count(substring[, ignore_isolated][, overlapping])` | number of occurrences, not overlapping (as Python `str.count`) unless `overlapping=.true.` |
| `index(substring[, back][, occurrence])` | like the intrinsic; `occurrence=k` gives the k-th occurrence, not overlapping, from the end if `back` |
| `scan(set[, back])`, `verify(set[, back])` | like the intrinsics |

`search` returns the first text enclosed by two tags, tags included:

<<< @/examples/snippets/tags.f90

<<< @/examples/output/tags.ansi{ansi}

`search(tag_start, tag_end[, in_string][, in_character][, istart][, iend])` searches the string itself, or the one
passed as `in_string` or `in_character`; `istart` and `iend` return where the text starts and ends.

## Padding and layout

<<< @/examples/snippets/pad.f90

<<< @/examples/output/pad.ansi{ansi}

`fill(width[, right][, filling_char])` pads to `width` characters, on the left unless `right=.true.`, with zeros unless
`filling_char` is passed. A string already as wide as `width`, or wider, is returned unchanged.

<<< @/examples/snippets/align.f90

<<< @/examples/output/align.ansi{ansi}

`center(width[, fill_char])`, `ljust(width[, fill_char])` and `rjust(width[, fill_char])` center, left justify and right
justify the string in `width` characters, padding with blanks or with `fill_char`, as the Python methods of the same
name: a string already as wide as `width` is returned unchanged, and an odd padding of `center` puts the extra character
on the left if `width` is odd, on the right otherwise.

<<< @/examples/snippets/justify.f90

<<< @/examples/output/justify.ansi{ansi}

`justify(lines, width)` is a subroutine: it allocates `lines`. The words are packed greedily and the blanks spread
between them, the leftmost gaps taking the extra ones; the last line and the lines of one word are left-justified and
padded. A word longer than `width` is not broken. `len_last_word([sep])` is the length of the last word, trailing
separators ignored.

## Comparing

<<< @/examples/snippets/prefix.f90

<<< @/examples/output/prefix.ansi{ansi}

`common_prefix(other)` takes a string or a character; `common_prefix(array)` an array of strings, and returns what the
string and all its elements start with.

<<< @/examples/snippets/version.f90

<<< @/examples/output/version.ansi{ansi}

`compare_version(other[, sep])` returns -1, 0 or 1. The versions are compared field by field (the fields separated by
`.`, or by `sep`): two fields made of digits only are compared as integers of any size, the others as text; missing
fields count as zero.

::: warning
The comparison is not semantic-versioning aware: `1.0.0-rc1` compares greater than `1.0.0`.
:::
