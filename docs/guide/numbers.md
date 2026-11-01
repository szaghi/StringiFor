---
title: Numbers
---

# Numbers

<p align="center"><img src="../examples/images/numbers_cast.svg" alt="a terminal session on numbers: is_integer, is_real, is_number, to_number, read_number with its error, assigning numbers, hex, summing the numbers of a text"></p>

## The kinds

`use stringifor` exports the portable kinds of [PENF](https://github.com/szaghi/PENF):

| Parameter | Type | Bytes |
|---|---|---|
| `I1P` | integer | 1 |
| `I2P` | integer | 2 |
| `I4P` | integer | 4 |
| `I8P` | integer | 8 |
| `R4P` | real | 4 |
| `R8P` | real | 8 |
| `R16P` | real | 16 |

- `R16P` is supported (in the assignment and in `to_number`) when the library is compiled with the `-DPENF_R16P`
  preprocessor flag.
- `I2P` is not supported when the `_NVF` macro is defined (NVIDIA Fortran compatibility).

## Is it a number?

<<< @/examples/snippets/number_check.f90

<<< @/examples/output/number_check.ansi{ansi}

| Method | True if the string is |
|---|---|
| `is_integer([allow_spaces])` | an integer, with an optional sign |
| `is_real([allow_spaces])` | a real: digits with a decimal point or an exponent (or both); an integer is not a real |
| `is_number([allow_spaces])` | an integer or a real |
| `is_digit()` | made of digits only |

Leading and trailing blanks are accepted, unless `allow_spaces=.false.`.

## From a string to a number

<<< @/examples/snippets/number_cast.f90

<<< @/examples/output/number_cast.ansi{ansi}

`to_number(kind)` returns the number in the string. The argument selects the kind of the result and nothing else: its
value is ignored, pass any constant of the wanted kind (`1_I4P`, `1._R8P`). A cast to a real kind accepts a real or an
integer string, a cast to an integer kind an integer string.

A plain decimal number (a sign, digits, a decimal point, an exponent) is converted without the
`read` statement, and correctly rounded: any integer in the range of the kind, and any `R4P` or `R8P` real, by one exact
operation when the digits and the power of ten are exact in the kind and by the Eisel-Lemire algorithm otherwise. About 50
ns per number with gfortran, against about 500 ns for `read`. A real of more digits is settled on its first 18 when both
ways of rounding them give the same result, and otherwise by comparing all its digits exactly. So `R4P` and `R8P` do not
depend on the compiler. `R16P` goes through `read`, so its results are the compiler's.

### The forms of a real

<<< @/examples/snippets/number_forms.f90

<<< @/examples/output/number_forms.ansi{ansi}

- The exponent letter can be `e`, `E`, `d` or `D`. After a decimal point it can also be missing, with a sign and exactly 3
  digits: `1.5-101` is what the E and ES edit descriptors write for a three digit exponent. `read` also takes `1-2` as
  `1e-2`; here it is not a number, or `2026-11` would be one.
- `nan`, `nan(chars)`, `inf` and `infinity`, in any case and with a sign, are reals, for `is_real` and `is_number` too.
- Past the range of the kind, the result is an infinity or a zero with `iostat` 0.

::: warning
On a string that does not hold a suitable number the result is 0 for an integer kind and a quiet NaN for a real kind:
check with `is_number` or `is_integer` first to tell a parsed 0 from a failure, or use `read_number`.
:::

### With an error status

<<< @/examples/snippets/checked_cast.f90

<<< @/examples/output/checked_cast.ansi{ansi}

`read_number(number[, iostat][, iomsg])` is a subroutine: the kind is the one of `number`, and the failure is reported
as by a `read` statement, `iostat` being 0 on success and positive otherwise, `iomsg` explaining it. On failure `number`
gets the same value as `to_number`, 0 or NaN. It is elemental: on an array of strings, `number` and `iostat` are arrays.

## From a number to a string

<<< @/examples/snippets/number_string.f90

<<< @/examples/output/number_string.ansi{ansi}

<<< @/examples/snippets/shortest_text.f90

<<< @/examples/output/shortest_text.ansi{ansi}

- An integer is written with its sign; a real with its sign and all the significant digits of its kind, so the string
  holds the nearest representable value. For another layout, write the number with a format into a character.
- `shortest(number)`, a module procedure for `R4P` and `R8P`, returns the shortest text that reads back as exactly that
  number, the closest of them if more than one, in the layout of Python's `repr`. The assignment keeps its format.
- `hex([bits][, uppercase])` returns the hexadecimal representation of the integer in the string, or a string not
  allocated if it is not an integer. A negative number is in two's complement on `bits` bits (default 64); the number
  is truncated to its lowest `bits` bits.
