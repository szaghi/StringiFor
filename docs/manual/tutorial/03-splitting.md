# 3. Splitting and joining

A row of the table is one line of text: the values are between the commas.

## Split

<<< @/examples/snippets/report_3-split.f90

`split` is a subroutine: it allocates `tokens` with one string for each piece, of the length of that piece. The cells
still carry the blank after each comma, and here is one of the strengths of the type: the methods are elemental, so
`cells%strip()` strips every element of the array in one statement.

## Join

<<< @/examples/snippets/report_3-join.f90

`join` is the opposite of `split`: it concatenates the elements of an array, with a separator between them. The
separator is `sep`, or the string on which `join` is called when `sep` is not passed.

## Partition

<<< @/examples/snippets/report_3-partition.f90

`partition` splits once, at the first separator, and returns three strings: what is before, the separator, what is
after. `count` counts the occurrences of a substring.

## Running it

<<< @/examples/output/report_3.ansi{ansi}

The whole program:

<<< @/examples/snippets/report_3.f90

::: tip What you learned
`split` into an allocatable array, `join` back, `partition` for one split; methods applied to a whole array.
Reference: [String Manipulation](/guide/string-manipulation#splitting-and-joining).
:::

Next: [4. Numbers](./04-numbers).
