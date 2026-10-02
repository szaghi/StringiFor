---
title: About StringiFor
---

# About StringiFor

StringiFor (Strings Fortran Manipulator) is a pure Fortran library that provides one type, `string`: a string of any
length with the methods that standard `character` variables lack. Its design borrows from the string type of Python:
`split`, `join`, `replace`, `strip`, `startswith`-like inquiries, and many more, as type-bound procedures.

Modern Fortran improved character handling with deferred-length allocatable characters, but an array of them still has
elements of one length, and common operations (upper case, tokens, path pieces, casting to numbers) are left to every
program. StringiFor fills that gap with a small, consistent API in standard Fortran 2008; a `string` works wherever a
`character` does, through the overloaded assignment, `//`, comparison operators and intrinsics. It depends only on three
small libraries by the same author, PENF (numeric kinds), FACE (ANSI colours) and BeFoR64 (base64), which every build
system fetches.

This documentation reads in order, and each page links to the next one:

1. [Installation](./installation): get StringiFor into your project.
2. The [tutorial](/manual/tutorial/01-first-string): six short chapters that build a complete program, step by step.
3. The [cookbook](/manual/cookbook): short recipes, one for each "how do I ...?".
4. The reference, from the [feature map](./features#feature-map) on: every method, every argument.

The [API](/api/) documents the source itself. Why a string type at all, and how StringiFor compares to the other
approaches, is discussed in [Comparison](./comparison).

Every code sample of the tutorial, of the cookbook and of the reference is part of a program that is compiled and run to
produce the outputs shown (see [`docs/examples`](https://github.com/szaghi/StringiFor/tree/master/docs/examples)).

## Authors

- Stefano Zaghi — [@szaghi](https://github.com/szaghi)

Contributions are welcome — see the [Contributing](contributing) page.

## Copyrights

StringiFor is distributed under a multi-licensing system:

| Use case | License |
|---|---|
| FOSS projects | [GPL v3](http://www.gnu.org/licenses/gpl-3.0.html) |
| Closed source / commercial | [BSD 2-Clause](http://opensource.org/licenses/BSD-2-Clause) |
| Closed source / commercial | [BSD 3-Clause](http://opensource.org/licenses/BSD-3-Clause) |
| Closed source / commercial | [MIT](http://opensource.org/licenses/MIT) |
