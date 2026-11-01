# 7. Patterns

The report needed only fixed separators. When the text has a shape rather than a separator, as an address, a date or a
setting, describe the shape with a regular expression.

## Search

<<< @/examples/snippets/regex_tour-search.f90

`compile` turns the pattern into a `regex` once; `search` finds the leftmost match. `(?P<user>\w+)` is a group named
`user`: one or more word characters. `group` returns the text of a group by number or name, `span` its first and last
byte.

## All the matches

<<< @/examples/snippets/regex_tour-all.f90

`finditer` returns every match, left to right; `findall` would return only their texts.

## Replace and split

<<< @/examples/snippets/regex_tour-sub.f90

In the template of `sub`, `\g<user>` is the text of the group `user`. `re_split` is one of the module procedures that
take the pattern as a character: handy once, but a `regex` compiled once is faster in a loop.

## Errors

<<< @/examples/snippets/regex_tour-errors.f90

<<< @/examples/output/regex_tour.ansi{ansi}

A malformed pattern gives the byte where the problem is and what it is.

::: tip What you learned
`compile`, `search`, `group`, `finditer`, `sub`, `re_split`.
Reference: [Regular Expressions](/guide/regex).
:::

Next: [8. Unicode text](./08-unicode).
