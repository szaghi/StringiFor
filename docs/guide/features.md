---
title: Features
---

# Features

## Design Goals

| Goal | Description |
|------|-------------|
| **Seamless interchangeability** | Works transparently with standard `character` variables via overloaded `//`, `=`, and comparison operators |
| **Rich built-in methods** | `split`, `replace`, `join`, `basename`, `camelcase`, `to_number`, and many more as type-bound procedures |
| **Low memory consumption** | Only one `character(kind=CK, len=:), allocatable` member — arrays of strings can hold elements of different lengths |
| **Safe** | Almost all methods are `elemental` or `pure` |
| **Robust** | Test-Driven Developed — a comprehensive doctest suite is embedded directly in the source |

## String Manipulation

- Case conversion: `upper`, `lower`, `swapcase`, `capitalize`, `camelcase`, `snakecase`, `startcase`
- Search and replace: `replace`, `search`, `index`, `count`, `scan`, `verify`
- Splitting and joining: `split`, `split_chunked`, `partition`, `join`, `strjoin`
- Padding and trimming: `fill`, `strip`, `adjustl`, `adjustr`, `trim`
- Transformation: `reverse`, `unique`, `insert`, `slice`, `escape`, `unescape`
- Encoding: `encode` / `decode` (Base64 via BeFoR64)
- Terminal output: `colorize` (ANSI styles via FACE)

## Number Casting

- Assign any PENF integer or real kind directly to a `string` via overloaded `assignment(=)`
- Cast back with `to_number(kind=...)` — supports all PENF kinds: `I1P`, `I2P`, `I4P`, `I8P`, `R4P`, `R8P`, `R16P`
- Inquiry methods: `is_number`, `is_integer`, `is_real`, `is_digit`

## File and Path Utilities

- Read/write files line-by-line or as streams: `read_file`, `write_file`, `read_line`, `read_lines`, `write_line`, `write_lines`
- Path components: `basedir`, `basename`, `extension`
- File-system glob: `glob`
- Unique temporary names: `tempname`

## Operators

| Operator | Returns | Notes |
|----------|---------|-------|
| `=` | — | From `character`, `string`, or any PENF numeric kind |
| `//` | `character` | Enables seamless use with Fortran intrinsics |
| `.cat.` | `string` | Concatenation keeping the `string` type |
| `==`, `/=` | `logical` | Equality / inequality |
| `<`, `<=`, `>=`, `>` | `logical` | Lexicographic comparison |

## Fortran Built-in Replacements

Generic interfaces that accept `type(string)` in place of `character`:

`adjustl` · `adjustr` · `count` · `index` · `len_trim` · `repeat` · `scan` · `trim` · `verify`

## Compiler Support

| Compiler | Minimum Version | Status |
|----------|----------------|--------|
| GNU gfortran | ≥ 9.2.0 | Full support |
| Intel `ifort` / `ifx` | ≥ 19.0.4 | Full support |
| IBM XL | — | Not tested |
| g95 | — | Not tested |
| NAG | — | Not tested |
| PGI | — | Not tested |
