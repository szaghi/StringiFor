# 5. Files and paths

The table is in a file, [`data/cars.csv`](https://github.com/szaghi/StringiFor/blob/master/docs/examples/files/data/cars.csv),
whose name `report` now takes from the command line:

```
year, make, model, price, notes
1997, Ford, E350, 3000.00, ac abs moon
1999, Chevy, Venture, 4900.50, extended edition
2001, Fiat, Punto, 2500, a small city car with a low fuel consumption and a surprisingly large boot
```

## The pieces of a path

<<< @/examples/snippets/report_5-paths.f90

`basedir`, `basename` and `extension` take a path apart. `basename` can also drop the last extension: this is how
`report` names its output after its input. `match` compares the whole string with a wildcard pattern, `*` any sequence
of characters, `?` one character, `[...]` a character of a set; `glob` uses the same patterns to list the files that
match.

## Reading

<<< @/examples/snippets/report_5-read.f90

`read_file` reads the whole file and allocates one string for each line, each of its own length. It takes the name of
the file as a character: `input%chars()`.

## Writing

<<< @/examples/snippets/report_5-write.f90

Each row is split, cleaned and joined again as a row of a Markdown table; `write_file` writes an array of strings, one
for each line.

## Running it

<<< @/examples/output/report_5.ansi{ansi}

<<< @/examples/output/report_5-md.ansi{ansi}

The whole program:

<<< @/examples/snippets/report_5.f90

::: tip What you learned
`read_file` and `write_file` for whole files; `basedir`, `basename`, `extension` for the paths; `match` for wildcard
patterns.
Reference: [Files and Paths](/guide/advanced).
:::

Next: [6. A polished report](./06-report).
