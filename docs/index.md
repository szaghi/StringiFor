---
layout: home

hero:
  name: StringiFor
  text: Strings Fortran Manipulator
  tagline: A pure Fortran 2008+ library providing an OOP string type with Python-like methods.
  actions:
    - theme: brand
      text: Guide
      link: /guide/
    - theme: alt
      text: API Reference
      link: /api/
    - theme: alt
      text: View on GitHub
      link: https://github.com/szaghi/StringiFor

features:
  - icon: 🔤
    title: Rich String API
    details: Split, join, replace, search, camelCase, snakeCase, pad, strip, slice, reverse, justify, version comparison and more — all as type-bound procedures on a single string type.
  - icon: 🔢
    title: Seamless Number Casting
    details: Assign any integer or real (all PENF kinds) directly to a string, cast back with to_number(), or get the hexadecimal representation with hex(). No format strings needed.
  - icon: 📁
    title: File & Path Utilities
    details: Read and write files line-by-line or as streams. Manipulate file paths with basedir, basename, and extension methods.
  - icon: 🛠️
    title: Multi Build & Install
    details: Build with FoBiS, fpm, CMake or GNU Make. Install as a static or shared library, or pull in directly as a FoBiS or fpm dependency.
  - icon: 🧪
    title: OOP/TDD Designed
    details: A single string type with all functionality as type-bound procedures. Every method is covered by embedded doctests — safe, pure, and elemental where possible.
  - icon: 🆓
    title: Free & Open Source
    details: Multi-licensed — GPLv3 for FOSS projects, BSD 2/3-Clause or MIT for commercial use. Fortran 2008+ standard compliant.
---

## Quick start

A minimal *plate*:

```fortran
use stringifor
type(string) :: s

s = 'Hello, World!'
print "(A)", s%upper()//'' ! HELLO, WORLD!
print "(A)", s%lower()//'' ! hello, world!
```

## Authors

- Stefano Zaghi — [@szaghi](https://github.com/szaghi)

Contributions are welcome — see the [Contributing](/guide/contributing) page.

## Copyrights

This project is distributed under a multi-licensing system:

- **FOSS projects**: [GPL v3](http://www.gnu.org/licenses/gpl-3.0.html)
- **Closed source / commercial**: [BSD 2-Clause](http://opensource.org/licenses/BSD-2-Clause), [BSD 3-Clause](http://opensource.org/licenses/BSD-3-Clause), or [MIT](http://opensource.org/licenses/MIT)

> Anyone interested in using, developing, or contributing to this project is welcome — pick the license that best fits your needs.
