---
title: Changelog
---

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
