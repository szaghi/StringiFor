---
layout: home

hero:
  name: StringiFor
  text: Strings Fortran Manipulator
  tagline: "A string type for modern Fortran with the methods you miss from Python: split, join, replace, strip, slice, justify, cast to and from numbers, read and write files. One type, one module, pure Fortran 2008."
  actions:
    - theme: brand
      text: Tutorial
      link: /manual/tutorial/01-first-string
    - theme: alt
      text: Cookbook
      link: /manual/cookbook
    - theme: alt
      text: Reference
      link: /guide/features
    - theme: alt
      text: API
      link: /api/
    - theme: alt
      text: View on GitHub
      link: https://github.com/szaghi/StringiFor

features:
  - icon: 🔤
    title: A real string type
    details: "One type holding a string of any length: arrays whose elements have different lengths, no trim() everywhere, no silent truncation."
    link: /manual/tutorial/01-first-string
    linkText: A first string
  - icon: 🔗
    title: A drop-in for character
    details: "Assignment, //, the comparison operators and the intrinsics (trim, index, len_trim, repeat, ...) accept a string wherever a character goes."
    link: /guide/basic-io
    linkText: Strings and I/O
  - icon: ✂️
    title: Split, join, slice
    details: "split and partition into tokens (the empty CSV fields kept, if you want), join arrays back, slice with a stride, reverse characters or words, replace, strip, compact whitespace, squeeze repeats, transliterate sets of characters."
    link: /guide/string-manipulation
    linkText: String manipulation
  - icon: 🔠
    title: Case and layout
    details: "upper, lower, capitalize, camelCase, snake_case, Start Case; letters, digits, punctuation and blanks told apart; pad, center or justify to a width, expand tabs, wrap a paragraph in fully justified lines."
    link: /guide/string-manipulation#case-conversion
    linkText: Case conversion
  - icon: 🔢
    title: Numbers in, numbers out
    details: "Assign any integer or real kind to a string, cast back with to_number, or with read_number and an error status; ask is_number, is_integer, is_real; hexadecimal representation with hex."
    link: /guide/numbers
    linkText: Numbers
  - icon: 📁
    title: Files and paths
    details: "Read a file into an array of lines or one string, write it back, read line by line; basedir, basename, extension, glob, wildcard match, temporary names."
    link: /guide/advanced
    linkText: Files and paths
  - icon: ⚖️
    title: Comparisons that know more
    details: "Longest common prefix of many strings, version numbers compared field by field, start_with, end_with, count."
    link: /guide/string-manipulation#comparing
    linkText: Comparing
  - icon: 🎨
    title: Encoding and colours
    details: "Base64 encode and decode, escape and unescape, ANSI colours and styles for the terminal."
    link: /guide/advanced#colours-for-the-terminal
    linkText: Colours
  - icon: ⚡
    title: Elemental by design
    details: "Almost every method is pure or elemental: apply it to a whole array of strings in one statement, use it in pure procedures."
    link: /manual/cookbook#a-method-on-every-element-of-an-array
    linkText: Arrays of strings
  - icon: 🧪
    title: Tested by its own documentation
    details: "Every method carries doctests in its source; every example of these pages is a program that is compiled and run to produce the output shown."
    link: /manual/
    linkText: The examples
  - icon: 🛠️
    title: Standard Fortran, any build
    details: "Fortran 2008, built with FoBiS, fpm, CMake or Make. Three small dependencies, fetched for you."
    link: /guide/installation
    linkText: Installation
  - icon: 🔓
    title: Multi-licensed
    details: "GPL v3 for FOSS projects; BSD 2-Clause, BSD 3-Clause or MIT for closed source and commercial ones: pick the license that fits."
    link: #copyrights
    linkText: Copyrights
---

## Quick start

A real session with a small StringiFor program: every answer is one method of the `string` type.

<p align="center"><img src="./examples/images/quickstart.svg" alt="a terminal session of a StringiFor program: upper case, snake case, reversed words, justified text, version comparison, hexadecimal, number detection"></p>

This is the whole program: a `select case` on the command, one method for each answer.

<<< @/examples/snippets/quickstart.f90

## Grows with your program

The same methods take you from a line of text to a report read from a file, cleaned, computed and laid out. This is the
output of the program that the [tutorial](/manual/tutorial/01-first-string) builds step by step:

<p align="center"><img src="./examples/images/report_6.svg" alt="the report printed by the program of the tutorial"></p>

Learn StringiFor step by step in the [tutorial](/manual/tutorial/01-first-string), find quick answers in the [cookbook](/manual/cookbook), look up every detail in the [reference](/guide/features#feature-map).

## Authors

- Stefano Zaghi — [@szaghi](https://github.com/szaghi)

Contributions are welcome — see the [Contributing](/guide/contributing) page.

## Copyrights

This project is distributed under a multi-licensing system:

- **FOSS projects**: [GPL v3](http://www.gnu.org/licenses/gpl-3.0.html)
- **Closed source / commercial**: [BSD 2-Clause](http://opensource.org/licenses/BSD-2-Clause), [BSD 3-Clause](http://opensource.org/licenses/BSD-3-Clause), or [MIT](http://opensource.org/licenses/MIT)

> Anyone interested in using, developing, or contributing to this project is welcome — pick the license that best fits your needs.
