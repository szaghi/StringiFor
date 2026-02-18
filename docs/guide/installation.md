# Installation

## Prerequisites

A Fortran 2003+ compliant compiler is required. GNU gfortran ≥ 9.2.0 and Intel Fortran ≥ 19.0.4 are known to work.

## Download

StringiFor uses **git submodules** for its dependencies. Clone recursively:

```bash
git clone https://github.com/szaghi/StringiFor
cd StringiFor
git submodule update --init
```

### Third-Party Dependencies

The submodules live under `src/third_party/`:

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

To build StringiFor itself and run its tests:

```bash
fpm build
fpm test
```

## Build with FoBiS (primary development tool)

[FoBiS](https://github.com/szaghi/FoBiS) is the officially supported build system for development.

```bash
pip install FoBiS.py
```

### Build all tests

```bash
FoBiS.py build
```

Compiled test executables are placed in `./exe/`.

### Build the library

```bash
# Static library (GNU gfortran)
FoBiS.py build -mode stringifor-static-gnu

# Shared library (GNU gfortran)
FoBiS.py build -mode stringifor-shared-gnu

# Static library (Intel Fortran)
FoBiS.py build -mode stringifor-static-intel

# Shared library (Intel Fortran)
FoBiS.py build -mode stringifor-shared-intel
```

The library is placed in `./lib/` (`libstringifor.a` or `libstringifor.so`).

### Debug builds

```bash
FoBiS.py build -mode tests-gnu-debug
FoBiS.py build -mode tests-intel-debug
```

### List all modes

```bash
FoBiS.py build -lmodes
```

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
