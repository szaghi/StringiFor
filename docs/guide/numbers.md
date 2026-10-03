---
title: Numbers
---

# Numbers

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

::: warning
On a string that does not hold a suitable number the result is 0 for an integer kind and a quiet NaN for a real kind:
check with `is_number` or `is_integer` first to tell a parsed 0 from a failure.
:::

## From a number to a string

<<< @/examples/snippets/number_string.f90

<<< @/examples/output/number_string.ansi{ansi}

- An integer is written with its sign; a real with its sign and all the significant digits of its kind, so the string
  holds the nearest representable value. For another layout, write the number with a format into a character.
- `hex([bits][, uppercase])` returns the hexadecimal representation of the integer in the string, or a string not
  allocated if it is not an integer. A negative number is in two's complement on `bits` bits (default 64); the number
  is truncated to its lowest `bits` bits.
