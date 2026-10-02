#!/usr/bin/env bash
# Regenerate the tracked copies of the doctests from the doc comments of the library sources.
#
#   src/lib/*.F90                             the doctests, embedded in the doc comments
#   src/tests/<module>/<module>-doctest-N.*   generated: the programs and their expected results, tracked so that
#                                             they are built and run also without FoBiS (make TESTS=yes, CMake)
#
# The doctests are extracted, built and run by FoBiS in a clean build (exe/obj and exe/mod are removed first: stale
# objects built with other flags would be reused); the copies are replaced only if every doctest passes. The doctests
# are numbered by their position in the source, so adding one renumbers the following ones.
#
# Usage: bash scripts/sync_doctests.sh
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
build=$root/exe # the build directory of the mode tests-gnu-debug, git-ignored
modules="stringifor stringifor_string_t"

cd "$root"
rm -rf "$build/obj" "$build/mod" "$build/doctests-src"
log=$(mktemp)
trap 'rm -f "$log"' EXIT

fobis doctests --mode tests-gnu-debug --preproc " -DPENF_R16P" \
  --exclude-from-doctests penf.F90 --exclude-from-doctests penf_b_size.F90 \
  --exclude-from-doctests penf_stringify.F90 --exclude-from-doctests penf_allocatable_memory.F90 \
  --exclude-from-doctests befor64_pack_data_m.F90 --exclude-from-doctests befor64.F90 \
  --keep-volatile-doctests --doctests-preprocessor fpp > "$log" 2>&1 || { cat "$log"; exit 1; }

# a doctest that crashes is reported neither as passed nor as failed, and FoBiS exits 0: count them
executed=$(grep -c 'executing doctest' "$log" || true)
passed=$(grep -c 'doctest passed' "$log" || true)
if [[ $executed -eq 0 || $executed -ne $passed ]]; then
  cat "$log"
  printf 'error: %s doctests executed, %s passed: the tracked copies are left untouched\n' "$executed" "$passed" >&2
  exit 1
fi

for module in $modules; do
  rm -f "src/tests/$module/$module"-doctest-*
  cp "$build/doctests-src/$module/$module"-doctest-* "src/tests/$module/"
done
printf '%s doctests passed and copied into src/tests\n' "$passed"
