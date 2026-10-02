# 2. Cleaning and transforming

Text from a file or from a user is rarely clean. The header of the table of `report` arrives with blanks everywhere.

## Blanks

<<< @/examples/snippets/report_2-clean.f90

- `strip` removes the blanks at both ends.
- `replace` substitutes every occurrence of `old` with `new`; an empty `new` deletes.
- `upper` (and `lower`) change the case.

## Words

<<< @/examples/snippets/report_2-words.f90

`unique` collapses every run of a repeated substring to one occurrence. `startcase`, `snakecase` and `camelcase` split
the string in words and rewrite them in a style; `capitalize` makes upper case the first character only.

## A set of characters

<<< @/examples/snippets/report_2-strip.f90

With `remove`, `strip` removes from both ends every character of a set, in any order they occur.

## Running it

<<< @/examples/output/report_2.ansi{ansi}

The whole program:

<<< @/examples/snippets/report_2.f90

::: tip What you learned
`strip`, `replace`, `unique`, the case methods. Each returns a new string: assign it back to change the variable.
Reference: [String Manipulation](/guide/string-manipulation).
:::

Next: [3. Splitting and joining](./03-splitting).
