---
title: Files and Paths
---

# Files and Paths

## Reading

<<< @/examples/snippets/readfile.f90

<<< @/examples/output/readfile.ansi{ansi}

| Procedure | What it reads |
|---|---|
| `call read_file(file, lines[, form][, iostat][, iomsg])` | a whole file, into an allocatable array with one string for each line |
| `call read_lines(unit, lines[, form][, iostat][, iomsg])` | the same, from a connected unit |
| `call s%read_file(file[, is_fast][, form][, iostat][, iomsg])` | a whole file into one string, line ends included |
| `call s%read_lines(unit[, form][, iostat][, iomsg])` | the same, from a connected unit |
| `call s%read_line(unit[, form][, iostat][, iomsg])` | one line from a connected unit |

The first two are procedures of the module, the others methods. `is_fast=.true.` reads the file as a stream, in one
read.

Line by line:

<<< @/examples/snippets/readline.f90

<<< @/examples/output/readline.ansi{ansi}

`iostat` is zero when a line has been read, an empty one included; at the end of the file it is the end-of-file code
(`is_iostat_end(iostat)` is true) and the string is left unchanged. A last line without a line terminator is read like
the others.

## Writing

<<< @/examples/snippets/writefile.f90

<<< @/examples/output/writefile-cat.ansi{ansi}

| Procedure | What it writes |
|---|---|
| `call write_file(file, lines[, form][, iostat][, iomsg])` | an array of strings, one for each line |
| `call write_lines(unit, lines[, form][, iostat][, iomsg])` | the same, to a connected unit |
| `call s%write_file(file[, form][, iostat][, iomsg])` | one string, as it is |
| `call s%write_line(unit[, form][, iostat][, iomsg])` | one string to a connected unit, as one line |
| `call s%write_lines(unit[, form][, iostat][, iomsg])` | one string to a connected unit, each of the lines it contains as a line |

## Unformatted files

Every procedure accepts `form='unformatted'`: the file is then read or written as a stream (`access='stream'`), the
lines separated by the new-line character.

```fortran
call read_file(file='data.bin', lines=lines, form='unformatted')
call write_file(file='data.bin', lines=lines, form='unformatted')
```

## Paths

<<< @/examples/snippets/paths.f90

<<< @/examples/output/paths.ansi{ansi}

| Method | Result |
|---|---|
| `basedir([sep])` | the directory of a path |
| `basename([sep][, extension][, strip_last_extension])` | the file name, optionally without an extension |
| `extension()` | the last extension, with its dot |

`sep` is the separator of the directories, `/` by default. A file name without a directory has an empty `basedir`.

## Listing files

<<< @/examples/snippets/glob.f90

<<< @/examples/output/glob.ansi{ansi}

`glob(pattern, list)` returns the paths matching a pattern, with the rules of the shell; `list` is an allocatable
array of strings or of deferred-length characters, allocated with zero size when nothing matches. It is also a procedure
of the module, `call glob(self, pattern, list)`.

::: warning
`glob` runs the `ls` command: it works on Unix-like systems only.
:::

## Temporary names

<<< @/examples/snippets/tempname.f90

<<< @/examples/output/tempname.ansi{ansi}

`tempname([is_file][, prefix][, path])` returns a name that no file (or, with `is_file=.false.`, no directory) of `path`
has, starting with `prefix`. The name changes at each call: the example prints only what does not.

## Encoding

<<< @/examples/snippets/encode_base64.f90

<<< @/examples/output/encode_base64.ansi{ansi}

`encode(codec)` and `decode(codec)` take the name of the codec; `base64` is the only one available. The decoded string
has exactly the encoded length: its blanks are preserved, and the padding of the code can be omitted.

## Colours for the terminal

<<< @/examples/snippets/colors.f90

<p align="center"><img src="../examples/images/colors.svg" alt="three coloured lines in a terminal"></p>

`colorize([color_fg][, color_bg][, style])` returns a `character`: the string wrapped in the ANSI escape codes of the
colours and of the style, whose names are the ones of [FACE](https://github.com/szaghi/FACE) (`red`, `green`,
`yellow_intense`, ...; `bold_on`, `italics_on`, `underline_on`, ...).
