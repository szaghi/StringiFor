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

## Cleaning and replacing

<<< @/examples/snippets/strip.f90

<<< @/examples/output/strip.ansi{ansi}

`strip([remove_nulls][, remove])` removes the blanks at both ends; with `remove`, a set of characters, it removes every
leading and trailing character belonging to the set. `remove_nulls=.true.` cuts the string at its first null character.

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
| `count(substring[, ignore_isolated])` | number of non-overlapping occurrences |
| `index(substring[, back])`, `scan(set[, back])`, `verify(set[, back])` | like the intrinsics |

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
