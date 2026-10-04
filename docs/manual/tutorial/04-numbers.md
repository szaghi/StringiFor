# 4. Numbers

The prices are text. Before computing with them `report` must know that they are numbers, and convert them.

## Is it a number?

<<< @/examples/snippets/report_4-check.f90

`is_number` is true for an integer or a real; `is_integer` and `is_real` tell them apart: a real has a decimal point or
an exponent, `2500` is an integer and not a real.

## From a string to a number

<<< @/examples/snippets/report_4-cast.f90

`to_number` returns the number in the string. Its argument is not a value to convert: it only selects the kind of the
result, here a `real(R8P)`. The kinds are the portable ones of [PENF](https://github.com/szaghi/PENF), exported by
`stringifor`: `I1P`, `I2P`, `I4P`, `I8P`, `R4P`, `R8P`. A cast to a real kind accepts an integer string too.

::: warning
`to_number` does not report an error: on something that is not a number it gives 0 (integer kinds) or NaN (real
kinds). Check with `is_number` (or `is_integer`) first, or use `read_number`.
:::

## With an error status

<<< @/examples/snippets/report_4-read.f90

`read_number` is a subroutine that does what `to_number` does and reports a failure as a `read` statement: `iostat` is 0
on success and positive otherwise, `iomsg` says what went wrong. The kind of the result is the one of the variable passed.

## From a number to a string

<<< @/examples/snippets/report_4-assign.f90

A number of any kind is assigned to a string like a character. `to_number` is elemental, like most methods: applied to
the array of prices it gives the array of numbers, that `sum` adds. `hex` gives the hexadecimal representation of the
integer in the string.

## Running it

<<< @/examples/output/report_4.ansi{ansi}

An integer keeps its sign, a real is written with all the significant digits of its kind: a string holds the number
exactly as it is. When you want a layout, print the number with a format, as `report` does for the highest price.

The whole program:

<<< @/examples/snippets/report_4.f90

::: tip What you learned
`is_number`, `is_integer`, `is_real`; `to_number(kind=...)` and `read_number` with an error status; numbers assigned
to strings; `hex`.
Reference: [Numbers](/guide/numbers).
:::

Next: [5. Files and paths](./05-files).
