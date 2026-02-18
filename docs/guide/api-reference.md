# API Reference

Complete listing of all `string` type-bound procedures and module-level interfaces provided by `use stringifor`.

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
| `adjustl()` | Left-adjust (remove leading spaces) |
| `adjustr()` | Right-adjust (remove trailing spaces) |
| `camelcase()` | All words capitalized, spaces removed |
| `capitalize()` | First character upper, rest lower |
| `colorize(color, style)` | ANSI terminal colorization via FACE |
| `decode()` | Base64 decode |
| `encode()` | Base64 encode |
| `escape([escape_char])` | Escape backslashes (or custom character) |
| `fill(width[, right][, fill_char])` | Pad with zeros (or custom char) to reach width |
| `insert(substring, pos)` | Insert substring at given position |
| `join(array[, sep])` | Join an array of strings with receiver as default separator |
| `lower()` | All characters lowercase |
| `partition(sep)` | Split at sep; return `string(3)` = [before, sep, after] |
| `replace(old, new)` | Replace all occurrences of `old` with `new` |
| `reverse()` | Reverse character order |
| `slice([first][, last][, stride])` | Substring by index range |
| `snakecase()` | Words lowercase, joined by `_` |
| `split(tokens, sep)` | Tokenize into allocatable array |
| `split_chunked(tokens, sep, n)` | Tokenize into fixed-size chunks |
| `startcase()` | Title case — each word capitalized |
| `strip([remove])` | Remove leading/trailing characters |
| `swapcase()` | Swap upper↔lower case |
| `unescape([escape_char])` | Unescape doubled backslashes |
| `unique(substring)` | Collapse repeated occurrences of substring to one |
| `upper()` | All characters uppercase |

## Inquiry Methods

| Method | Returns | Description |
|--------|---------|-------------|
| `chars([first][, last])` | `character(:)` | Raw character data, optionally sliced |
| `end_with(suffix)` | `logical` | True if string ends with suffix |
| `is_allocated()` | `logical` | True if `raw` member is allocated |
| `is_digit()` | `logical` | True if all characters are digits |
| `is_integer()` | `logical` | True if string represents an integer |
| `is_lower()` | `logical` | True if all characters are lowercase |
| `is_number()` | `logical` | True if string represents an integer or real |
| `is_real()` | `logical` | True if string represents a real number |
| `is_upper()` | `logical` | True if all characters are uppercase |
| `len()` | `integer` | Total length (like `LEN`) |
| `len_trim()` | `integer` | Length without trailing spaces |
| `start_with(prefix)` | `logical` | True if string starts with prefix |
| `count(substring)` | `integer` | Number of non-overlapping occurrences |

## Number Casting

| Method | Description |
|--------|-------------|
| `to_number(kind)` | Cast string to the numeric kind of the `kind` argument |

The `kind` argument selects the return type — pass any literal of the target PENF kind:

```fortran
real(R8P)    :: x
integer(I4P) :: n

x = s%to_number(kind=1._R8P)
n = s%to_number(kind=0_I4P)
```

## File I/O Methods (type-bound)

| Method | Description |
|--------|-------------|
| `read_file(file[, form][, iostat][, iomsg])` | Read entire file into this string |
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
| `basedir()` | Directory component of a path |
| `basename([extension][, strip_last_extension])` | File name component, optionally stripped |
| `extension()` | File extension (with leading dot) |
| `glob(matches[, pattern])` | Glob pattern matching |
| `search(tag_start, tag_end)` | Find first region delimited by tags |
| `tempname([prefix])` | Generate a unique temporary file/directory name |

## Miscellaneous

| Method | Description |
|--------|-------------|
| `free()` | Deallocate `raw` member |
| `strjoin(array, sep)` | Join 1D or 2D arrays with separator |

## Module-Level Procedures

| Procedure | Description |
|-----------|-------------|
| `glob(pattern, list)` | Glob search returning matching paths |
| `strjoin(array, sep)` | Join arrays of strings or characters |
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

`I1P`, `I2P`, `I4P`, `I8P`, `R4P`, `R8P`, `R16P` (R16P requires `-Dr16p` preprocessor flag)

## Character Kind Constant

`CK` — the default character kind (`selected_char_kind('DEFAULT')`). Use it when defining character variables that will interact with the `raw` member:

```fortran
character(kind=CK, len=:), allocatable :: buf
```
