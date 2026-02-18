# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

StringiFor is a pure Fortran (2003+) library providing an OOP-designed `string` type that extends standard Fortran character handling with Python-like string methods. It is Test-Driven Developed using embedded doctests.

## Build Commands

The primary and officially supported build tool is **FoBiS** (Fortran Building System).

```bash
# Build all tests (default: tests-gnu mode, output in ./exe/)
FoBiS.py build

# Build in debug mode
FoBiS.py build -mode tests-gnu-debug

# Build static library (output: ./lib/libstringifor.a)
FoBiS.py build -mode stringifor-static-gnu

# Build shared library (output: ./lib/libstringifor.so)
FoBiS.py build -mode stringifor-shared-gnu

# Intel Fortran variants
FoBiS.py build -mode tests-intel
FoBiS.py build -mode stringifor-static-intel
FoBiS.py build -mode stringifor-shared-intel

# List all available modes
FoBiS.py build -lmodes
```

**Alternative: Fortran Package Manager (fpm)**
```bash
fpm build
fpm test
```

**Alternative: GNU Make**
```bash
make                        # static library with gfortran
make TESTS=yes              # build tests suite
make COMPILER=intel         # use Intel Fortran
make COMPILER=intel TESTS=yes
```

## Running Tests

```bash
# After FoBiS.py build, run all test executables
bash scripts/run_tests.sh

# Run a single test executable directly
./exe/<test_name>

# Run doctests with coverage (FoBiS doctest system)
FoBiS.py doctests -mode tests-gnu-debug -coverage \
  --exclude_from_doctests penf.F90 penf_b_size.F90 penf_stringify.F90 \
  befor64_pack_data_m.F90 befor64.F90 -keep_volatile_doctests \
  -doctests_preprocessor fpp
```

## Doctest Format (TDD)

Tests are embedded directly in source code as Fortran doctests. The format used in `stringifor_string_t.F90`:

```fortran
!<```fortran
!< type(string) :: astring
!< astring = 'hello'
!< print '(L1)', astring%upper() == 'HELLO'
!<```
!=> T <<<
```

FoBiS extracts these blocks and compares output against `!=>` lines. Pre-extracted doctests live in `src/tests/stringifor_string_t/` and `src/tests/stringifor/` as `*-doctest-N.f90` / `*-doctest-N.result` pairs.

## Architecture

### Source Layout

- **`src/lib/stringifor.F90`** — Top-level public module. A thin wrapper that re-exports everything from `stringifor_string_t`, adds PENF numeric kinds (`I1P`–`I8P`, `R4P`–`R16P`), and provides module-level file I/O subroutines (`read_file`, `read_lines`, `write_file`, `write_lines`).
- **`src/lib/stringifor_string_t.F90`** — Core implementation. Defines the `string` derived type and all its Type Bound Procedures (TBPs). This is where all string methods live.
- **`src/third_party/`** — Git submodules:
  - **PENF** — Portable numeric kind parameters (`I1P`, `R4P`, etc.) and `str()` conversion
  - **FACE** — ANSI color/style terminal output (used by `string%colorize`)
  - **BeFoR64** — Base64 encode/decode (used by `string%encode`/`string%decode`)

### The `string` Type

The entire public API centers on one derived type:

```fortran
type :: string
  character(kind=CK, len=:), allocatable :: raw  ! the only data member
  contains
    ! ~50+ type-bound procedures (TBPs)
end type
```

All methods are TBPs (`procedure, pass(self)` or `generic`). The type overloads:
- `assignment(=)` for character, integer (all PENF kinds), and real (all PENF kinds)
- `//` concatenation (returns standard character for seamless integration)
- `.cat.` operator (returns `string`)
- Comparison operators `==`, `/=`, `<`, `<=`, `>=`, `>`
- Fortran built-in replacements: `adjustl`, `adjustr`, `count`, `index`, `len_trim`, `repeat`, `scan`, `trim`, `verify`
- Defined I/O: `read(formatted)`, `write(formatted)`, `read(unformatted)`, `write(unformatted)`

Module-level `glob` and `strjoin` procedures are also exposed publicly.

### Preprocessor Flags

The source files use `.F90` extension (preprocessed Fortran). Relevant flags:
- `-Dr16p` / `_R16P` — enables 16-byte real (`R16P`) support
- `_NVF` — disables `I2P` (2-byte integer) for NVIDIA Fortran compatibility

## Fortran Coding Style

From `CONTRIBUTING.md`:
- `implicit none` in all modules and programs
- `intent` declared for all procedure arguments
- Argument order: pass argument → `intent(in out)` → `intent(in)` → `intent(out)` → optional
- Indent with **2 spaces** (no tabs)
- Use `>`, `<`, `==` instead of `.gt.`, `.lt.`, `.eq.`
- Human-readable variable names; single-character names only for loop counters
- No trailing whitespace; blank lines must be truly empty (no spaces)

## Documentation

```bash
# Build HTML docs with ford
FoBiS.py rule -ex makedoc

# Clean docs
FoBiS.py rule -ex deldoc
```

Docs are generated from inline `!<` doc comments in source files using [ford](https://github.com/cmacmackin/ford). Configuration is in `doc/main_page.md`.

## Submodule Setup

After cloning, initialize dependencies:
```bash
git submodule update --init
```
