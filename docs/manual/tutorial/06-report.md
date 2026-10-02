# 6. A polished report

The last chapter prints the report on the terminal: a title, aligned columns, the notes of the cheapest car wrapped in
a paragraph.

## A title, in colour

<<< @/examples/snippets/report_6-title.f90

`colorize` returns the characters of the string wrapped in the ANSI codes of a colour and of a style. `repeat` is the
Fortran intrinsic.

## Aligned columns

<<< @/examples/snippets/report_6-table.f90

- `fill` pads a string to a width: on the left by default, on the right with `right=.true.`, with zeros unless
  `filling_char` says otherwise.
- The price becomes a rounded integer assigned back to the cell; `slice(first=2)` drops its sign. `slice` takes a first
  and a last position and a stride, all optional, and returns a `character`.

## A justified paragraph

<<< @/examples/snippets/report_6-notes.f90

`justify` wraps the words of a string in lines of a given width, spreading the blanks so that every line but the last
one is as wide as the others. Like `split`, it is a subroutine that allocates the lines.

## Running it

<p align="center"><img src="../../examples/images/report_6.svg" alt="the report printed by the program"></p>

The whole program:

<<< @/examples/snippets/report_6.f90

::: tip What you learned
`colorize`, `fill`, `slice`, `justify`: a report in a short program.
Reference: [String Manipulation](/guide/string-manipulation), [Files and Paths](/guide/advanced#colours-for-the-terminal).
:::

Next: the [cookbook](../cookbook), short recipes for everyday tasks.
