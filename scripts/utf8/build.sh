#!/usr/bin/env bash
# Build the library and the drivers of the UTF-8 harnesses (issue #51, Phase 0) with one compiler.
#
# The library sources (src/lib and the fetched dependencies, run `fobis fetch` first) are compiled directly, not by
# FoBiS, so that any compiler works with the same command and lib/ (FoBiS builds, docs examples) is left alone.
# Everything goes to build/utf8/<compiler>/ (git-ignored); the drivers are scripts/utf8/src/*.f90.
#
# Usage: bash scripts/utf8/build.sh            gfortran, or the compiler in $FC (FC=nvfortran ...)
#        FFLAGS="-O0 -g" bash scripts/utf8/build.sh   other flags (default -O2)
# Prints the directory of the executables on the last line.
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
fc=${FC:-gfortran}
fflags=${FFLAGS:--O2}
defines=''
modflag=-J # where the compiler writes the .mod files
case "$(basename "$fc")" in
  nvfortran*) defines='-D_NVF'; modflag=-module ;; # no I2P with nvfortran
  ifx*|ifort*) modflag=-module ;;
esac
tp=$root/src/third_party
lib_sources=(
  "$tp/PENF/src/lib/penf_global_parameters_variables.F90"
  "$tp/PENF/src/lib/penf_b_size.F90"
  "$tp/PENF/src/lib/penf_stringify.F90"
  "$tp/PENF/src/lib/penf_allocatable_memory.F90"
  "$tp/PENF/src/lib/penf.F90"
  "$tp/FACE/src/lib/face.F90"
  "$tp/BeFoR64/src/lib/befor64_pack_data_m.F90"
  "$tp/BeFoR64/src/lib/befor64.F90"
  "$root/src/lib/stringifor_unicode_tables.F90"
  "$root/src/lib/stringifor_utf8.F90"
  "$root/src/lib/stringifor_string_t.F90"
  "$root/src/lib/stringifor.F90"
)
for src in "${lib_sources[@]}"; do
  [ -f "$src" ] || { echo "build.sh: missing $src (run 'fobis fetch')" >&2; exit 1; }
done

out=$root/build/utf8/$(basename "$fc")
rm -rf -- "$out"
mkdir -p "$out/obj" "$out/mod" "$out/bin"
cd "$out/obj"
for src in "${lib_sources[@]}"; do
  # shellcheck disable=SC2086
  "$fc" $fflags $defines -c "$src" -I"$out/mod" $modflag "$out/mod" > "$out/build.log" 2>&1 ||
    { cat "$out/build.log" >&2; echo "build.sh: $src failed" >&2; exit 1; }
done
for src in "$root"/scripts/utf8/src/*.f90; do
  name=$(basename "$src" .f90)
  # shellcheck disable=SC2086
  "$fc" $fflags -I"$out/mod" $modflag "$out/mod" -o "$out/bin/$name" "$src" "$out"/obj/*.o > "$out/build.log" 2>&1 ||
    { cat "$out/build.log" >&2; echo "build.sh: $src failed" >&2; exit 1; }
done
echo "$out/bin"
