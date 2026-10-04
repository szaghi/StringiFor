---
title: Methods Summary
---

# Methods Summary

Every type-bound procedure of `string` and every procedure of the module, with its arguments (the optional ones in
brackets). The pages of the reference explain them with examples; the [API](/api/) documents the source.

## Fortran Built-in Replacements

These generic interfaces shadow Fortran intrinsics so they accept `type(string)` arguments transparently:

| Name | Intrinsic replaced |
|------|--------------------|
| `adjustl` | `ADJUSTL` |
| `adjustr` | `ADJUSTR` |
| `count` | `COUNT` |
| `index` | `INDEX` |
| `len_trim` | `LEN_TRIM` |
| `repeat` | `REPEAT` |
| `scan` | `SCAN` |
| `trim` | `TRIM` |
| `verify` | `VERIFY` |

::: info
`len` is available as a type-bound method (`s%len()`) but is not re-exported as a module-level generic to avoid conflicts with the intrinsic in certain compilers.
:::

## Transformation Methods

| Method | Description |
|--------|-------------|
| `adjustl()` | Left-adjust (move leading spaces to the end) |
| `adjustr()` | Right-adjust (move trailing spaces to the beginning) |
| `camelcase([sep])` | All words capitalized, separators removed |
| `capitalize()` | First character upper, rest lower |
| `center(width[, fill_char])` | Centered in `width` characters, as Python `str.center` |
| `colorize([color_fg][, color_bg][, style])` | ANSI terminal colorization via FACE; returns `character` |
| `common_prefix(other)` / `common_prefix(array)` | Longest common prefix shared with another string/character, or with all elements of a string array |
| `compact([sep])` | Words separated by one `sep` (default space), whitespace runs collapsed and the ends removed |
| `decode(codec)` | Decode; `codec='base64'` is the only codec available, an unknown one gives a not allocated string |
| `encode(codec)` | Encode; `codec='base64'` is the only codec available, an unknown one gives a not allocated string |
| `escape(to_escape[, esc])` | Escape the character `to_escape` with a backslash (or with `esc`) |
| `expand_tabs([tab_size])` | Tabs replaced by spaces up to the next tab stop, every `tab_size` columns (default 8) |
| `fill(width[, right][, filling_char])` | Pad with zeros (or custom char) to reach width |
| `hex([bits][, uppercase])` | Hexadecimal representation of the integer held by the string (two's complement on `bits` bits, default 64) |
| `insert(substring, pos)` | Insert substring at given position |
| `join(array[, sep])` | Join an array of strings or characters with receiver as default separator |
| `justify(lines, width)` | Pack the words into fully justified lines (subroutine, allocates `lines`) |
| `ljust(width[, fill_char])` | Left justified in `width` characters, as Python `str.ljust` |
| `lower()` | All characters lowercase |
| `partition([sep])` | Split at the first sep (default space); return `string(3)` = [before, sep, after] |
| `quote([quote_char])` | Between quotes (default `"`), the inner ones doubled |
| `repeat(ncopies)` | Concatenate `ncopies` copies of the string |
| `replace(old, new[, count])` | Replace all (or the first `count`) occurrences of `old` with `new`, left to right; the replaced text is not searched again |
| `reverse()` | Reverse character order |
| `reverse_words([sep])` | Reverse the order of the words |
| `rjust(width[, fill_char])` | Right justified in `width` characters, as Python `str.rjust` |
| `slice([first][, last][, stride])` | Section `first:last:stride`, bounds clamped into the string; returns `character` |
| `snakecase([sep])` | Words lowercase, joined by `_` |
| `split(tokens[, sep][, max_tokens][, keep_empty])` | Tokenize into allocatable array (subroutine); sequential separators count as one, a string of only separators has no tokens; with `keep_empty` the empty fields are tokens |
| `split_chunked(tokens, chunks[, sep])` | Tokenize in chunks of `chunks` tokens (subroutine) |
| `squeeze([set])` | Runs of a repeated character (of `set` if passed) reduced to one, as `tr -s` |
| `startcase([sep])` | Title case — each word capitalized |
| `strip([remove_nulls][, remove])` | Remove leading/trailing spaces, or the characters of the set `remove` |
| `swapcase()` | Swap upper↔lower case |
| `transliterate(old_set, new_set)` | Characters of `old_set` replaced by the ones of `new_set`, as `tr` |
| `trim()` | Remove trailing spaces |
| `unescape(to_unescape[, unesc])` | Remove the backslash (or `unesc`) escaping the character `to_unescape` |
| `unique([substring])` | Collapse repeated occurrences of substring (default space) to one |
| `unquote()` | Inverse of `quote`, for a string between the same `'` or `"` |
| `upper()` | All characters uppercase |

## Inquiry Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `chars()` | `character(:)` | Raw character data (null if not allocated) |
| `compare_version(other[, sep])` | `integer` | Field-by-field version comparison: `-1`, `0` or `1` |
| `count(substring[, ignore_isolated])` | `integer` | Number of non-overlapping occurrences |
| `end_with(suffix[, start][, end][, ignore_null_eof])` | `logical` | True if string ends with suffix |
| `index(substring[, back])` | `integer` | Position of substring (like `INDEX`) |
| `is_allocated()` | `logical` | True if `raw` member is allocated |
| `is_alnum()` | `logical` | True if all characters are letters or digits |
| `is_alpha()` | `logical` | True if all characters are letters |
| `is_digit()` | `logical` | True if all characters are digits |
| `is_integer([allow_spaces])` | `logical` | True if string represents an integer |
| `is_lower()` | `logical` | True if all characters are lowercase |
| `is_number([allow_spaces])` | `logical` | True if string represents an integer or real |
| `is_punct()` | `logical` | True if all characters are punctuation (as C `ispunct`) |
| `is_real([allow_spaces])` | `logical` | True if string represents a real: a decimal point or an exponent is required, an integer is not a real |
| `is_space()` | `logical` | True if all characters are whitespace (as C `isspace`) |
| `is_upper()` | `logical` | True if all characters are uppercase |
| `is_xdigit()` | `logical` | True if all characters are hexadecimal digits |
| `match(pattern)` | `logical` | True if the whole string matches a wildcard pattern (`*`, `?`, `[seq]`, `[!seq]`) |
| `len()` | `integer` | Total length (like `LEN`) |
| `len_last_word([sep])` | `integer` | Length of the last word, trailing separators ignored |
| `len_trim()` | `integer` | Length without trailing spaces |
| `scan(set[, back])` | `integer` | Position of the first character belonging to `set` (like `SCAN`) |
| `start_with(prefix[, start][, end])` | `logical` | True if string starts with prefix |
| `verify(set[, back])` | `integer` | Position of the first character not belonging to `set` (like `VERIFY`) |

## Number Casting

| Method | Description |
|--------|-------------|
| `to_number(kind)` | Cast string to the numeric kind of the `kind` argument |
| `read_number(number[, iostat][, iomsg])` | Cast string to the kind of `number`, reporting a failure in `iostat`/`iomsg` (elemental subroutine) |

The `kind` argument selects the return type — pass any literal of the target PENF kind:

```fortran
real(R8P)    :: x
integer(I4P) :: n

x = s%to_number(kind=1._R8P)
n = s%to_number(kind=0_I4P)
```

A cast to a real kind accepts both real and integer strings; a cast to an integer kind requires an integer string. If the
string does not hold a suitable number the result is 0 for an integer kind and a quiet NaN for a real kind: check with
`is_number` / `is_integer` first to tell a parsed 0 from a failure, or use `read_number`, which reports it.

## File I/O Methods (type-bound)

| Method | Description |
|--------|-------------|
| `read_file(file[, is_fast][, form][, iostat][, iomsg])` | Read entire file into this string |
| `read_line(unit[, form][, iostat][, iomsg])` | Read one line from connected unit |
| `read_lines(unit[, form][, iostat][, iomsg])` | Read all lines from connected unit |
| `write_file(file[, form][, iostat][, iomsg])` | Write this string to file |
| `write_line(unit[, form][, iostat][, iomsg])` | Write one line to connected unit |
| `write_lines(unit[, form][, iostat][, iomsg])` | Write all lines to connected unit |

## File I/O Subroutines (module-level)

```fortran
call read_file(file, lines[, form][, iostat][, iomsg])
call read_lines(unit, lines[, form][, iostat][, iomsg])
call write_file(file, lines[, form][, iostat][, iomsg])
call write_lines(unit, lines[, form][, iostat][, iomsg])
```

`lines` is `type(string), allocatable :: lines(:)` for `read_*` and `type(string), intent(in) :: lines(1:)` for `write_*`.

## Path / Search Methods

| Method | Description |
|--------|-------------|
| `basedir([sep])` | Directory component of a path |
| `basename([sep][, extension][, strip_last_extension])` | File name component, optionally stripped |
| `extension()` | File extension (with leading dot) |
| `glob(pattern, list)` | Pathnames matching a shell pattern, only its wildcards special; `list` is a `string` or `character` allocatable array (subroutine, Unix only) |
| `search(tag_start, tag_end[, in_string][, in_character][, istart][, iend])` | Find first region delimited by tags |
| `tempname([is_file][, prefix][, path])` | Generate a unique temporary file/directory name |

## Miscellaneous

| Method | Description |
|--------|-------------|
| `free()` | Deallocate `raw` member |
| `strjoin(array[, sep][, is_trim][, is_col])` | Join 1D or 2D arrays with separator; `is_trim` applies to character arrays, `is_col` to 2D ones |

## Module-Level Procedures

| Procedure | Description |
|-----------|-------------|
| `glob(self, pattern, list)` | Glob search returning matching paths; `self` is a `string` |
| `strjoin(array[, sep][, is_trim][, is_col])` | Join arrays of strings or characters |
| `read_file`, `read_lines` | File reading subroutines |
| `write_file`, `write_lines` | File writing subroutines |

## Operators

| Operator | Left | Right | Returns | Description |
|----------|------|-------|---------|-------------|
| `=` | `string` | `string`, `character`, or any PENF numeric | — | Assignment |
| `//` | `string` | `string` or `character` | `character` | Concatenation |
| `.cat.` | `string` | `string` or `character` | `string` | Concatenation |
| `==` | `string` | `string` or `character` | `logical` | Equality |
| `/=` | `string` | `string` or `character` | `logical` | Inequality |
| `<` | `string` | `string` or `character` | `logical` | Lexicographic less-than |
| `<=` | `string` | `string` or `character` | `logical` | Less-or-equal |
| `>=` | `string` | `string` or `character` | `logical` | Greater-or-equal |
| `>` | `string` | `string` or `character` | `logical` | Greater-than |

## PENF Kind Parameters

Re-exported from PENF for convenience:

`I1P`, `I2P`, `I4P`, `I8P`, `R4P`, `R8P`, `R16P`

- `R16P` support (assignment and `to_number`) requires the `-DPENF_R16P` preprocessor flag.
- `I2P` support is disabled when the `_NVF` macro is defined (NVIDIA Fortran compatibility).

## Character Kind Constant

`CK` — the default character kind (`selected_char_kind('DEFAULT')`). Use it when defining character variables that will interact with the `raw` member:

```fortran
character(kind=CK, len=:), allocatable :: buf
```
