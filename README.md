# StringiFor

>#### Strings Fortran Manipulator with steroids
>a pure Fortran 2008+ library providing an OOP `string` type with Python-like methods for modern Fortran projects.

[![GitHub tag](https://img.shields.io/github/v/tag/szaghi/StringiFor)](https://github.com/szaghi/StringiFor/tags)
[![GitHub issues](https://img.shields.io/github/issues/szaghi/StringiFor)](https://github.com/szaghi/StringiFor/issues)
[![CI](https://github.com/szaghi/StringiFor/actions/workflows/ci.yml/badge.svg)](https://github.com/szaghi/StringiFor/actions/workflows/ci.yml)
[![coverage](https://img.shields.io/endpoint?url=https://szaghi.github.io/StringiFor/coverage.json)](https://github.com/szaghi/StringiFor/actions/workflows/ci.yml)
[![License](https://img.shields.io/badge/license-GPLv3%20%7C%20BSD%20%7C%20MIT-blue.svg)](#copyrights)

| 🔤 **Rich String API**<br>`upper`, `lower`, `camelcase`, `snakecase`, `split`, `join`, `replace`, `search`, `slice`, `strip`, `justify`, `compare_version` — Python-like methods on modern Fortran strings | 🔢 **Number Casting**<br>Assign any [PENF](https://github.com/szaghi/PENF) integer or real kind directly to a `string`; cast back with `to_number(kind=...)`; hexadecimal representation with `hex` | 📁 **File & Path I/O**<br>`read_file`, `write_file`, `read_line`, `write_line`, `basedir`, `basename`, `extension`, `glob` — batteries included | 🎨 **Encoding & Color**<br>Base64 `encode`/`decode` via BeFoR64; ANSI terminal `colorize` via FACE |
|:---:|:---:|:---:|:---:|
| ⚡ **Pure & Elemental**<br>Almost all methods are `pure` or `elemental` — thread-safe, no side effects | 🔗 **Seamless Interop**<br>Overloaded `=`, `//`, and comparison operators — `string` is a drop-in for standard `character` | 🔓 **Multi-licensed**<br>GPL v3 · BSD 2/3-Clause · MIT | 📦 **Multiple build systems**<br>fpm, FoBiS, CMake, Make |

For full documentations (guide, tutorial, examples, etc...) see the [StringiFor website](https://szaghi.github.io/StringiFor/).

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
print "(A)", s//''              ! +0.31415899999999999E+001
print "(L1)", s%is_real()       ! T
```

---

## Install

### FoBiS

**Standalone** — clone, fetch dependencies, and build:

```bash
git clone https://github.com/szaghi/StringiFor && cd StringiFor
fobis fetch                                    # fetch PENF, FACE, BeFoR64
fobis build --mode stringifor-static-gnu        # build static library
```

Or install directly in one command:

```bash
fobis install szaghi/StringiFor --mode stringifor-static-gnu
fobis install szaghi/StringiFor --mode stringifor-static-gnu --prefix /path/to/prefix
```

**As a project dependency** — declare StringiFor in your `fobos` and run `fetch`:

```ini
[dependencies]
deps_dir = src/third_party
StringiFor   = https://github.com/szaghi/StringiFor
```

```bash
fobis fetch           # fetch and build
fobis fetch --update  # re-fetch and rebuild
```

### fpm

Add to your `fpm.toml`:

```toml
[dependencies]
StringiFor = { git = "https://github.com/szaghi/StringiFor" }
```

```bash
fpm build
```

### CMake

```bash
cmake -B build && cmake --build build
```

### Makefile

```bash
make              # static library
make TESTS=yes    # build the tests suite
```
