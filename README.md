# StringiFor

**Strings Fortran Manipulator** — a pure Fortran 2003+ library providing an OOP `string` type with Python-like methods for modern Fortran projects.

[![CI](https://github.com/szaghi/StringiFor/actions/workflows/ci.yml/badge.svg)](https://github.com/szaghi/StringiFor/actions)
[![Coverage](https://img.shields.io/codecov/c/github/szaghi/StringiFor.svg)](https://app.codecov.io/gh/szaghi/StringiFor)
[![GitHub tag](https://img.shields.io/github/tag/szaghi/StringiFor.svg)](https://github.com/szaghi/StringiFor/releases)
[![License](https://img.shields.io/badge/license-GPLv3%20%7C%20BSD%20%7C%20MIT-blue.svg)](#copyrights)

---

## Features

- Single `string` type — seamlessly interchangeable with standard `character` via overloaded `//`, `=`, and comparison operators
- Case conversion: `upper`, `lower`, `camelcase`, `snakecase`, `startcase`, `swapcase`, `capitalize`
- Splitting and joining: `split`, `partition`, `join`, `strjoin`
- Search and replace: `replace`, `search`, `index`, `count`, `unique`
- Number casting: assign any PENF integer/real to a `string`; cast back with `to_number(kind=...)`
- File I/O: `read_file`, `write_file`, `read_line`, `write_line`
- Path utilities: `basedir`, `basename`, `extension`, `glob`
- Encoding: Base64 `encode`/`decode`, ANSI terminal `colorize`
- OOP/TDD designed — almost all methods are `elemental` or `pure`

**[Documentation](https://szaghi.github.io/StringiFor/)** | **[API Reference](https://szaghi.github.io/StringiFor/api/)**

---

## Authors

- Stefano Zaghi — [@szaghi](https://github.com/szaghi)

Contributions are welcome — see the [Contributing](https://szaghi.github.io/StringiFor/guide/contributing) page.

## Copyrights

This project is distributed under a multi-licensing system:

- **FOSS projects**: [GPL v3](http://www.gnu.org/licenses/gpl-3.0.html)
- **Closed source / commercial**: [BSD 2-Clause](http://opensource.org/licenses/BSD-2-Clause), [BSD 3-Clause](http://opensource.org/licenses/BSD-3-Clause), or [MIT](http://opensource.org/licenses/MIT)

> Anyone interested in using, developing, or contributing to this project is welcome — pick the license that best fits your needs.

---

## Quick start

```fortran
use stringifor
implicit none
type(string) :: s

s = 'Hello, World!'
print "(A)", s%upper()//''      ! HELLO, WORLD!
print "(A)", s%replace(old='World', new='Fortran')//''  ! Hello, Fortran!
print "(A)", s%camelcase()//''  ! Hello,World!

s = 3.14159_R8P
print "(A)", s//''              ! +3.14159000000000E+00
print "(L1)", s%is_real()       ! T
```

---

## Install

### fpm (recommended)

Add to your `fpm.toml`:

```toml
[dependencies]
StringiFor = { git = "https://github.com/szaghi/StringiFor.git" }
```

Then:

```sh
fpm build
fpm test
```

### Clone and build

```sh
git clone https://github.com/szaghi/StringiFor
cd StringiFor
git submodule update --init
```

| Tool | Command |
|------|---------|
| fpm | `fpm build` |
| FoBiS.py | `FoBiS.py build -mode stringifor-static-gnu` |
| GNU Make | `make` |
