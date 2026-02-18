# Comparison to Other Approaches

The lack of built-in string manipulation in Fortran has led to several different solutions over the years. This page compares StringiFor to the three main alternatives identified by Clive Page [[1]](#ref1).

## The Four Approaches

### 1. Standard `character` type

Fixed-length at compile time. Simple and universally supported, but severely limited:

```fortran
character(len=3) :: s
s = 'abcdefgh'   ! silently truncated to 'abc'
```

### 2. Deferred-length allocatable character

Introduced in Fortran 2003. Removes the fixed-length constraint but array elements must still all have the same length:

```fortran
character(len=:), allocatable :: s
character(len=:), allocatable :: arr(:)

s = 'Hello '
s = s // 'World'    ! no trim() needed, length adapts

allocate(character(len=99) :: arr(10))  ! all 10 elements are len=99
```

### 3. `aniso_varying_string` (Ian Harvey's ISO implementation)

A derived type wrapping a deferred-length allocatable character, implementing ISO/IEC 1539-2:2000. Solves the array-element problem but has I/O and slicing limitations:

```fortran
type(varying_string), allocatable :: arr(:)
allocate(arr(10))   ! elements can have different lengths
```

### 4. StringiFor

Shares the same philosophy as `aniso_varying_string` — a derived type wrapping a single `character(kind=CK, len=:), allocatable` member — but adds an extensive OOP API modelled after Python's string methods.

```fortran
type(string), allocatable :: arr(:)
allocate(arr(10))   ! elements can have different lengths
```

## Issue-by-Issue Comparison

| Issue | `character` | Deferred-length | `aniso_varying_string` | StringiFor |
|-------|:-----------:|:---------------:|:----------------------:|:----------:|
| Fixed length at compile time | ✗ | ✓ | ✓ | ✓ |
| Silent truncation on assignment | ✗ | ✓ | ✓ | ✓ |
| `trim()`-cluttered code | ✗ | ✓ | ✓ | ✓ |
| Significant trailing spaces | ✗ | ✓ | ✓ | ✓ |
| Single definition syntax | ✗ | ✗ | ✓ | ✓ |
| Array allocation (variable lengths) | ✗ | ✗ | ✓ | ✓ |
| Array initialization | ✗ | ✗ | ✓ | ✓ |
| I/O support | ✓ | ✓ | ~ | ~ |
| Substring (slice) notation | ✓ | ✓ | ~ | ~ |
| Fortran intrinsics as-is | ✓ | ✓ | ~ | ~ |

**✓** = good support · **~** = partial support · **✗** = bad or no support

### Notes on partial I/O support

Both `aniso_varying_string` and StringiFor support I/O through defined I/O type-bound procedures (`read(formatted)`, `write(formatted)`, etc.). The `DT` edit descriptor (defined I/O) is fully supported in gfortran ≥ 7.1. For simpler portability, the `//''` concatenation idiom converts a `string` to a `character` on the fly:

```fortran
print "(A)", my_string//''
```

### Notes on slice notation

Standard slice notation (`s(2:5)`) cannot be applied to a derived type. StringiFor provides the `slice` method and the `chars([first][, last])` method as equivalents:

```fortran
! Standard character
print "(A)", s(2:5)

! StringiFor equivalents
print "(A)", my_string%slice(first=2, last=5)//''
print "(A)", my_string%chars(2, 5)
```

## StringiFor's Distinctive Features

Beyond solving the same issues as `aniso_varying_string`, StringiFor adds:

- **Number casting** — assign any PENF integer or real directly to a `string`; cast back with `to_number(kind=...)`
- **File I/O** — `read_file`, `write_file`, `read_line` for common file-handling patterns
- **Path manipulation** — `basedir`, `basename`, `extension`
- **Case conversion** — `camelcase`, `snakecase`, `startcase`, `capitalize`, `swapcase`
- **Encoding** — Base64 `encode`/`decode` via BeFoR64
- **Color output** — ANSI terminal colorization via FACE
- **Glob** — file-system pattern matching
- **Namespace safety** — all functionality is accessible through the single `string` type; no global namespace pollution unless the overloaded intrinsic interfaces are explicitly imported

## References

<a name="ref1"></a>[1] Clive Page, *[Improved String-handling in Fortran](http://www.fortran.bcs.org/2015/suggestion_string_handling.pdf)*, October 2015.

[2] Ian Harvey, *[aniso_varying_string](http://www.megms.com.au/aniso_varying_string.htm)*, 2016.
