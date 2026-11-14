# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

StringiFor is a pure Fortran (2003+) library providing an OOP-designed `string` type that extends standard Fortran character handling with Python-like string methods. It is Test-Driven Developed using embedded doctests.

## Build Commands

The primary and officially supported build tool is **FoBiS** (Fortran Building System, CLI binary `fobis`, version 3.8+).
The legacy single-dash long options (`-mode`, `-lmodes`, `-ex`) are deprecated: FoBiS still translates them to the double-dash forms, but always write the double-dash forms.

```bash
# Build all tests (default: tests-gnu mode, output in ./exe/)
fobis build

# Build in debug mode
fobis build --mode tests-gnu-debug

# Build static library (output: ./lib/libstringifor.a)
fobis build --mode stringifor-static-gnu

# Build shared library (output: ./lib/libstringifor.so)
fobis build --mode stringifor-shared-gnu

# Intel Fortran variants (ifx, FoBiS compiler intel_nextgen; source /opt/intel/oneapi/<version>/oneapi-vars.sh first)
fobis build --mode tests-intel
fobis build --mode stringifor-static-intel
fobis build --mode stringifor-shared-intel

# List all available modes
fobis build --lmodes

# List the rules defined in fobos
fobis rule --ls
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
make COMPILER=intel         # use Intel Fortran (ifx)
make COMPILER=intel TESTS=yes
```

## Running Tests

CI also builds and runs the tests on every toolchain of `[scaffold] matrix` (`linux-gnu linux-oneapi macos-gnu`:
`matrix.yml`, scaffold-managed, runs the project's `scripts/ci/matrix.sh`): on linux-gnu the makefile build
(`make TESTS=yes`), elsewhere the FoBiS build with the toolchain's compiler (ifx 2026.2, Homebrew's gfortran 16);
where the compiler has no REAL(16) (gfortran on Apple silicon) the R16P tests are excluded.
Every scaffold workflow is a thin caller of a reusable workflow of `szaghi/fortran-toolchains` pinned at `@v1` (repo
`~/fortran/fortran-toolchains`), rendered from the `fobos` `[scaffold]` section; `toolchain = linux-gnu` is the `gnu-16.2`
image (gfortran 16.2, FoBiS, formal), where `ci.yml` (coverage), `docs.yml`, `fpm.yml` (`fpm = true`: the hand-written
tests declared in `fpm.toml`), `docs-examples.yml` (`docs_examples = docs/examples`) and `doctests-sync.yml`
(`doctests_sync = src/tests`: `scripts/sync_doctests.sh` must leave `src/tests` unchanged; it needs `cpp` on `PATH`:
without it, in a bare `ubuntu:24.04` container, the regenerated copies differ from the tracked ones in whitespace,
mechanism not traced) run. The project-owned `utf8-harness.yml` runs in the same image.

```bash
# After fobis build, run all test executables
bash scripts/run_tests.sh
# (a test with a .result file, as the doctests, must also print it; --vmem KB caps the memory of each test:
# use --vmem 4000000 on a machine with little memory)

# Run a single test executable directly
./exe/<test_name>

# Run the doctests embedded in the sources (FoBiS doctest system)
fobis doctests --mode tests-gnu-debug --preproc " -DPENF_R16P" \
  --exclude-from-doctests penf.F90 --exclude-from-doctests penf_b_size.F90 \
  --exclude-from-doctests penf_stringify.F90 --exclude-from-doctests penf_allocatable_memory.F90 \
  --exclude-from-doctests befor64_pack_data_m.F90 --exclude-from-doctests befor64.F90 \
  --keep-volatile-doctests --doctests-preprocessor fpp

# Same, with coverage instrumentation and coverage summary
fobis rule --ex makecoverage
```

Doctests gotchas:
- `--preproc " -DPENF_R16P"` needs the **leading space** inside the quotes: without it FoBiS mangles the value into
  `--DPENF-R16P`. Without the define the `to_real_R16P` doctest does not compile and the whole run aborts with exit 1.
- Changing `--preproc` does not trigger a rebuild: remove `exe/obj` and `exe/mod` first, or stale objects are reused.
- The extracted doctests are kept in `exe/doctests-src/`. The tracked copies under `src/tests/` are what a plain
  `fobis build`, CMake and `make TESTS=yes` compile (the makefile and CMake pick up every program in `src/tests/*/`,
  there is no list to maintain): after adding or changing a doctest, regenerate them with
  `bash scripts/sync_doctests.sh` and commit the result. The `Doctests sync` workflow
  (`.github/workflows/doctests-sync.yml`, scaffold-managed) fails if they differ from what the sources contain.

UTF-8 harness (issue #51; `docs/guide/contributing.md`, section *UTF-8 harness*): `bash scripts/oracle.sh SUITE`
(methods against a Python reference over a byte-string corpus), `bash scripts/bench.sh run|compare` (timings against
`scripts/utf8/baselines/`, pinned to one CPU), `python3 -I scripts/utf8/gen_unicode_tables.py [--check]` (the generated
`src/lib/stringifor_unicode_tables.F90`: never edit it by hand). `python3 -I scripts/utf8/gen_number_tables.py [--check]` does the same for `src/lib/stringifor_number_tables.F90`; `build/utf8/gfortran/bin/number_scaling` times the number parsing against `read`. The drivers live in `scripts/utf8/src/`, outside
`src/`, so FoBiS, make and CMake never build them; `scripts/utf8/build.sh` compiles the library sources itself (any
`FC`, no defines unless `DEFINES` is set: `DEFINES=-D_NVF FC=nvfortran` tests the `_NVF` variant). Compiler defects found by the oracle go in `KNOWN_COMPILER_ISSUES`
(`scripts/utf8/oracle.py`), never into the reference.

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

A method cannot be invoked on a function result in Fortran (`astring%upper()%is_allocated()` does not compile): assign the result to a `string` variable first.

## Architecture

### Source Layout

- **`src/lib/stringifor.F90`** — Top-level public module. A thin wrapper that re-exports everything from `stringifor_string_t`, adds PENF numeric kinds (`I1P`–`I8P`, `R4P`–`R16P`), and provides module-level file I/O subroutines (`read_file`, `read_lines`, `write_file`, `write_lines`).
- **`src/lib/stringifor_encodings.F90`** — Other encodings to UTF-8: `to_utf8` (US-ASCII, ISO-8859-1, windows-1252, UTF-16/UTF-32 LE/BE; pieces with `carry`, invalid sequences replaced as Python `errors='replace'`), `bom_encoding`/`bom_length`, `canonical_encoding` (IANA aliases). Checked by `bash scripts/oracle.sh encodings` against Python codecs. Module procedures only (no `string` method); internal helpers take explicit arguments (nvfortran: internal procedures read stale host values).
- **`src/lib/stringifor_string_t.F90`** — Core implementation. Defines the `string` derived type and all its Type Bound Procedures (TBPs). This is where all string methods live.
- **`src/third_party/`** — Dependencies fetched by `fobis fetch` (declared in the `[dependencies]` section of `fobos`, pinned in `src/third_party/fobos.lock`; not git submodules):
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
- `-DPENF_R16P` — enables 16-byte real (`R16P`) support
- `_NVF` — disables `I2P` (2-byte integer) and selects the `repeat` workaround for NVIDIA Fortran; optional with nvfortran 26.9
  (the oracle passes without it). Workarounds for nvfortran bugs every build hits key on `__NVCOMPILER`, not on `_NVF` alone (issue #53)

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
# Build the docs: API pages with formal, site with VitePress
fobis rule --ex makedoc

# Clean docs
fobis rule --ex deldoc
```

The site is built with **VitePress** from `docs/`. The hand-written guide lives in `docs/guide/`; the API pages in `docs/api/` are generated from the inline `!<` doc comments by `formal` (`formal-ford2vitepress`), configured by `docs/ford.md`. New public methods must be added by hand to `docs/guide/api-reference.md` and `docs/guide/features.md`.

The visual identity (Sumi, mark 3.3 Ofude in Akebono) lives in `docs/public/{logo,favicon,icons}` and the palette in `docs/.vitepress/theme/custom.css`: the SVG paths are generated geometry, never edit them by hand (regenerate the kit); full logo at 48 px and above, the favicon tile below; light assets on light grounds, `-dark` on dark ones; links rose (`--vp-c-brand-1`), buttons violet (`--vp-c-brand-3`), seal and accent are fills only, never text; no gradients, glows or shadows behind the mark. A new home-page feature takes a brushed icon from `docs/public/icons/`, not an emoji.

The pages are organised like FLAP's (`~/fortran/FLAP`): one linear sidebar in `docs/.vitepress/config.mts` (Start here, Tutorial, Recipes, Reference, Project), the tutorial and the cookbook in `docs/manual/`, the reference in `docs/guide/`.

Every code sample and output of the tutorial, cookbook and reference is generated: the programs in `docs/examples/src` (`!run ID COMMAND` lines declare the runs shown, `!region NAME` ... `!endregion NAME` the parts included alone, `!as NAME` the name its runs call it by, `!image ID` an SVG of a run, `!cast NAME ID ...` an animated SVG of a terminal session) are built and run by `bash scripts/docs_examples.sh`, which rewrites `docs/examples/snippets`, `docs/examples/output` and `docs/examples/images`; pages include them with `<<< @/examples/snippets/NAME.f90` and `<<< @/examples/output/ID.ansi{ansi}`. Never paste an output by hand: add a run, rerun the script and commit the result. The `Docs examples` workflow (`.github/workflows/docs-examples.yml`, scaffold-managed, gfortran 16.2 in the toolchain image: 13.3 and 14.2 end the list-directed read of `read_stdin` with `End of file`, a compiler bug deliberately not worked around, stated in `docs/guide/installation.md`) fails on any difference, so the outputs must not depend on the compiler: print with explicit formats. The quick start in `README.md` is a copy of `docs/examples/snippets/quickstart.f90`: update it when that program changes. Do not name an example after a shell keyword or a common command (`case`, `split`, `join`).

## Dependency Setup

After cloning, fetch the dependencies:
```bash
fobis fetch           # fetch and build PENF, FACE, BeFoR64 into src/third_party/
fobis fetch --update  # re-fetch and rebuild
```
