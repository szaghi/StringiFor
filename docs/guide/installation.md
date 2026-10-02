# Installation

## Prerequisites

A Fortran 2008+ compliant compiler is required. GNU gfortran ≥ 9.2.0 and Intel Fortran ≥ 19.0.4 are known to work.

## Download

Clone the repository:

```bash
git clone https://github.com/szaghi/StringiFor
cd StringiFor
```

Dependencies are declared in the `fobos` file and fetched automatically by FoBiS into `src/third_party/`:

```bash
fobis fetch           # fetch and build all dependencies
fobis fetch --update  # re-fetch and rebuild
```

### Third-Party Dependencies

Dependencies are fetched into `src/third_party/`:

| Library | Purpose |
|---------|---------|
| [PENF](https://github.com/szaghi/PENF) | Portable numeric kind parameters (`I1P`–`I8P`, `R4P`–`R16P`) and number-to-string conversion |
| [FACE](https://github.com/szaghi/FACE) | ANSI terminal color/style support (used by `string%colorize`) |
| [BeFoR64](https://github.com/szaghi/BeFoR64) | Base64 encode/decode (used by `string%encode`/`string%decode`) |

## Build with fpm (recommended for new projects)

[Fortran Package Manager](https://fpm.fortran-lang.org) resolves dependencies automatically. Add to your project's `fpm.toml`:

```toml
[dependencies]
StringiFor.git = "https://github.com/szaghi/StringiFor"
```

To build StringiFor itself:

```bash
fpm build
```

::: info
The test suite is not wired into fpm: run it with FoBiS, as described below.
:::

## Build with FoBiS (primary development tool)

[FoBiS](https://github.com/szaghi/FoBiS) is the officially supported build system for development.

```bash
pip install FoBiS.py
```

### Build all tests

```bash
fobis build
```

Compiled test executables are placed in `./exe/`.

### Build the library

```bash
# Static library (GNU gfortran)
fobis build --mode stringifor-static-gnu

# Shared library (GNU gfortran)
fobis build --mode stringifor-shared-gnu

# Static library (Intel Fortran)
fobis build --mode stringifor-static-intel

# Shared library (Intel Fortran)
fobis build --mode stringifor-shared-intel
```

The library is placed in `./lib/` (`libstringifor.a` or `libstringifor.so`).

### Debug builds

```bash
fobis build --mode tests-gnu-debug
fobis build --mode tests-intel-debug
```

### List all modes

```bash
fobis build --lmodes
```

### Install in one command

FoBiS can clone, build and install the library without a manual checkout:

```bash
fobis install szaghi/StringiFor --mode stringifor-static-gnu
fobis install szaghi/StringiFor --mode stringifor-static-gnu --prefix /path/to/prefix
```

### Use as a dependency of your FoBiS project

Declare StringiFor in the `fobos` file of your project and run `fobis fetch`:

```ini
[dependencies]
deps_dir   = src/third_party
StringiFor = https://github.com/szaghi/StringiFor
```

## Build with CMake

```bash
cmake -B build
cmake --build build
```

When StringiFor is the top-level project the tests are built too; disable them with `-DBUILD_TESTING=OFF`.

## Build with GNU Make

A `makefile` is provided for static library builds:

```bash
# Build static library with GNU gfortran (./lib/libstringifor.a)
make

# Build the tests suite
make TESTS=yes

# Use Intel Fortran instead
make COMPILER=intel
make COMPILER=intel TESTS=yes
```

## Running the Test Suite

After a FoBiS or Make build that includes tests:

```bash
bash scripts/run_tests.sh
```

Each executable in `./exe/` is run and its output checked for pass/fail.
