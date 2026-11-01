# 8. Unicode text

A `string` holds bytes. Text in UTF-8 is stored as it is, so everything so far works on it unchanged, but one question
now has three answers: how long is this text? This chapter builds a small table of names in several scripts and meets
each of them.

## Writing non-ASCII text

<<< @/examples/snippets/unicode_text-literals.f90

Keep Fortran sources in ASCII and write the other characters with `unescape_c`, which expands `\uXXXX`, `\n`, `\t` and
the other C escapes; it is elemental, so it works on the whole array. `escape_c` goes the other way: it writes any
bytes as printable ASCII, which is what you want in a log. `escapes_error()` gives the byte of the first malformed
escape, 0 if there is none.

## Bytes, characters, columns

<<< @/examples/snippets/unicode_text-sizes.f90

`len()` counts bytes: `é` is 2 bytes, `日` is 3. It is the default because a byte position is what `raw(i:j)` takes.
`len(by=SF_CHARS)` counts characters (codepoints), and `width()` the columns a terminal uses: `日` takes two of them.

## Aligning a column

<<< @/examples/snippets/unicode_text-align.f90

The first table is wrong: a width in bytes leaves `Renée` one dot short, and `日本語` has no padding at all. `ljust`,
`rjust`, `center`, `fill`, `justify` and `expand_tabs` take `by=SF_COLUMNS` to count columns, or `by=SF_CHARS` to count
characters. Columns are what aligns on a terminal.

## Positions

<<< @/examples/snippets/unicode_text-positions.f90

`index`, `scan`, `verify`, `slice`, `insert` and `len_last_word` also take `by=SF_CHARS`. `byte_pos` and `char_pos`
convert between the two, to mix them with `raw(i:j)`. The last line shows why the unit matters: 4 bytes end in the
middle of `é`, and the half that is left is an ill-formed byte.

## Codepoints

<<< @/examples/snippets/unicode_text-codes.f90

`codepoints` returns the value of each character, and `from_codepoints` builds a string from such values. Methods such
as `reverse` already work on whole characters, so you rarely need these two.

## Text that is not UTF-8

<<< @/examples/snippets/unicode_text-check.f90

A file in Latin-1 is not valid UTF-8: its `é` is the single byte E9. `is_utf8` and `utf8_error` find this.
`to_valid_utf8` replaces each ill-formed sequence by U+FFFD, or by `replacement`. Nothing else ever drops or changes
such a byte: it counts as one character and goes through unchanged.

## Whitespace

<<< @/examples/snippets/unicode_text-space.f90

Text copied from a web page holds no-break spaces (U+00A0) that the default whitespace, ASCII as in C, does not see.
`unicode=.true.` on `is_space`, `compact` and, with `whitespace=.true.`, on `strip`, `lstrip` and `rstrip` uses the
Unicode set.

## Running it

<<< @/examples/output/unicode_text.ansi{ansi}

::: tip What you learned
`unescape_c`, `escape_c`, `len(by=)`, `width`, `ljust(by=)`, `byte_pos`, `char_pos`, `codepoints`, `from_codepoints`,
`is_utf8`, `utf8_error`, `to_valid_utf8`, `unicode=`.
Reference: [Unicode and UTF-8](/guide/unicode).
:::

Next: the [cookbook](../cookbook), short recipes for everyday tasks.
