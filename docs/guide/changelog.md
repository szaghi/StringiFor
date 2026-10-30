---
title: Changelog
---

## Upgrading to 1.9.0

Release 1.9.0 reads UTF-8 text as characters ([Unicode and UTF-8](./unicode)). On ASCII text nothing changes. On
non-ASCII text the methods that worked on single bytes now work on units, a unit being a well-formed UTF-8 sequence or a
byte that is not part of one:

- **`reverse`** keeps the bytes of each character in order: `'ab'` followed by `é` reverses to `é` then `'ba'`, it gave
  invalid UTF-8.
- **`match`**: `?` and a class `[...]` match one character, `'caf?'` matches `café`; a range compares codepoints.
- **`scan`, `verify`, `strip`/`lstrip`/`rstrip` with `remove=`, `squeeze` with a set** take a set of characters: `ã`
  no longer matches the set `é` (they share their first byte), and a backward `verify` gives the first byte of a
  character, not its last one.
- **`squeeze`** reduces runs of a repeated non-ASCII character, which it did not see.
- **`transliterate`** maps characters to characters, so `old_set` and `new_set` can hold non-ASCII ones and the result
  can be longer than the string.

Bytes that are not well-formed UTF-8 (Latin-1 text, binary data) are units on their own and keep their old
behaviour. The only difference for them is Latin-1 or binary content that happens to contain a well-formed sequence
(the Latin-1 `Ã©` is the bytes C3 A9, `é` in UTF-8): that pair is now one unit.

Two defects are fixed too: `split_chunked` crashed on a string made only of separators, it now gives no tokens as
`split` does; `end_with` read one byte before a null string.

## Upgrading to 1.4.0

Release 1.4.0 makes the string methods linear in time and memory and fixes their edge cases. Three changes can alter
the results of existing programs:

- **`replace` is not recursive.** The replaced text is not searched again, as in Python `str.replace`: `'aaaa'` with
  `'aa'` replaced by `'a'` gives `'aa'` (it gave `'a'`), and a `new` containing `old` no longer loops forever.
  `count=0` replaces nothing (it replaced one occurrence).
- **Unformatted I/O of a `string` stores its length.** `write(unit) astring` writes the length (an `I8P` integer)
  then the characters, and `read` reads them back exactly; strings were truncated at 100 characters. Unformatted
  files written by an earlier version are not readable.
- **Defined results on edge cases.** `to_number` on a string that is not a number gives 0 (integer kinds) or a quiet
  NaN (real kinds), it was undefined; `split` of a string made only of separators gives no tokens, it gave the string
  itself; `count` (of characters) no longer undercounts; `count('')` and `unique('')` no longer loop forever.

<!--@include: ../../CHANGELOG.md-->
