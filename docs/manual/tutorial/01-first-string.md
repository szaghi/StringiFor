# 1. A first string

`report` starts with its title. A `string` is declared like any other variable and it has no length to choose: it
takes the length of what is assigned to it.

<<< @/examples/snippets/report_1.f90

- A `string` is assigned from a `character` of any length, or from another `string`.
- `//` concatenates strings and characters and gives a standard `character`: this is how a string goes wherever Fortran
  expects a character, a `print` included. `title//''` is the shortest way to say "the characters of `title`".
- `chars()` returns the same characters; the `DT` edit descriptor prints the string through its defined I/O.
- `.cat.` concatenates like `//`, but gives a `string`.
- The comparison operators work between strings, and between a string and a character.
- The methods are called on the variable: `title%startcase()`, `heading%len()`, `subtitle%upper()`. They return a new
  value and leave the string unchanged.

## Running it

<<< @/examples/output/report_1.ansi{ansi}

::: tip What you learned
A string has no fixed length; `//` turns it into a character and `.cat.` keeps it a string; methods return new values.
Reference: [Strings and I/O](/guide/basic-io).
:::

Next: [2. Cleaning and transforming](./02-cleaning).
