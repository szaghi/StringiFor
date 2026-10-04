---
title: Strings and I/O
---

# Strings and I/O

## The type

```fortran
use stringifor
type(string) :: s
```

A `string` has one component, `raw`, an allocatable character of deferred length and of kind `CK` (the default character
kind). It is allocated by the first assignment and it takes the length of what is assigned:

<<< @/examples/snippets/allocation.f90

<<< @/examples/output/allocation.ansi{ansi}

- `is_allocated()` tells whether the string has been assigned; `len()` is 0 for a string not allocated.
- `free` deallocates it.
- Most methods called on a string not allocated return a string not allocated (or zero, or false).

## Assignment, concatenation, comparison

<<< @/examples/snippets/operators.f90

<<< @/examples/output/operators.ansi{ansi}

| Operator | Operands | Result |
|---|---|---|
| `=` | a string from a string, a character, an integer or a real of any kind | — |
| `//` | string and string, string and character, character and string | `character` |
| `.cat.` | the same | `string` |
| `==`, `/=`, `<`, `<=`, `>=`, `>` | the same | `logical`, the comparison of the characters |

`//` returns a `character` on purpose: it is what makes a string usable wherever Fortran expects a character.

## Printing

<<< @/examples/snippets/print_string.f90

<<< @/examples/output/print_string.ansi{ansi}

::: tip
The `//''` idiom is the shortest way to pass a string where a `character` is expected, a `print` or the argument of any
procedure. `chars()` does the same and it is safe on a string not allocated: it returns an empty character.
:::

The `DT` edit descriptor uses the defined I/O of the type; it requires a compiler that supports defined derived-type
I/O (gfortran ≥ 7.1).

::: warning
A string does not go to an `A` edit descriptor: `print '(A)', s` is not standard Fortran. The defined output of the
type is used only by a `DT` edit descriptor or by list-directed output (12.6.4.8.4), and any other edit descriptor
receives the components of the type, which shall not be allocatable (12.6.3): `raw` is. The compilers do not diagnose
it at compile time: gfortran prints nothing, silently, while ifx stops with a run-time error (severe 125). Pass a
character instead, `s//''` or `s%chars()`, or use `DT`.
:::

## Reading

List-directed and formatted reads accept a string. A list-directed read takes one blank-delimited word, or a quoted
text:

<<< @/examples/snippets/read_stdin.f90

<<< @/examples/output/read_stdin.ansi{ansi}

To read from files, a line or a whole file at a time, see [Files and Paths](./advanced).

Unformatted I/O stores a string exactly: `write(unit) astring` writes its length, an `I8P` integer, then its
characters, and `read(unit) astring` allocates and reads them back, trailing blanks included; a string not allocated is
written as a null one. Unformatted files written by versions before 1.4.0, which held the characters only, are not
readable.

## The Fortran intrinsics

`adjustl`, `adjustr`, `count`, `index`, `len_trim`, `repeat`, `scan`, `trim` and `verify` are overloaded for strings,
as functions and as methods:

<<< @/examples/snippets/intrinsics.f90

<<< @/examples/output/intrinsics.ansi{ansi}

They behave like the intrinsics: `trim` removes the trailing blanks only, `adjustl` keeps the length. To remove the
blanks at both ends use [`strip`](./string-manipulation#cleaning-and-replacing).

::: info
`len` is a method (`s%len()`) but it is not overloaded as a function of the module, to avoid conflicts with the
intrinsic in some compilers.
:::

## Arrays of strings

Each element of an array has its own length, and the methods are elemental: they apply to a whole array.

<<< @/examples/snippets/arrays.f90

<<< @/examples/output/arrays.ansi{ansi}

::: warning
An array of strings must be allocated before it is assigned as a whole: the assignment of the type is a defined one,
and it does not allocate its left-hand side. The methods that return several strings (`split`, `justify`, `glob`,
`read_file`) are subroutines that allocate their result.
:::
