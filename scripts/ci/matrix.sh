#!/usr/bin/env bash
# StringiFor's tests on one toolchain, run by .github/workflows/matrix.yml on each toolchain of the fobos [scaffold]
# matrix, with the fortran-toolchains environment contract: FC, CC, CXX, TOOLCHAIN, TOOLCHAIN_OS and TOOLCHAIN_FAMILY
# (gnu, nvf, intel). Created by fobis scaffold, then the project's. The same script runs locally, in
# `docker run <image>` and in CI.
#
#   Linux gnu    the tests built by the makefile (make TESTS=yes): the build ci.yml (FoBiS) does not cover
#   otherwise    the tests built by FoBiS with the toolchain's compiler (mode tests-<family>; tests-gnu-debug for gnu)
#
# Where the compiler has no REAL(16) (gfortran on Apple silicon), the FoBiS build goes without -DPENF_R16P and the tests
# using R16P are excluded. Then scripts/run_tests.sh runs every test (the doctests must also print their .result).
set -euo pipefail
echo "toolchain: $TOOLCHAIN ($TOOLCHAIN_OS, $TOOLCHAIN_FAMILY), FC=$FC"
fobis fetch

if [ "$TOOLCHAIN_OS" = linux ] && [ "$TOOLCHAIN_FAMILY" = gnu ]; then
  rm -rf exe
  make TESTS=yes
else
  case $TOOLCHAIN_FAMILY in
    gnu) mode=tests-gnu-debug ;;
    *) mode=tests-$TOOLCHAIN_FAMILY ;;
  esac
  probe=$(mktemp -d)
  printf 'program q\nprint "(I0)", selected_real_kind(33, 4931)\nend program\n' > "$probe/q.f90"
  (cd "$probe" && "$FC" q.f90 -o q)
  args=(--mode "$mode" --fc "$FC")
  if [ "$("$probe/q")" -gt 0 ]; then
    args+=(--preproc " -DPENF_R16P") # the leading space is needed: FoBiS mangles a value starting with a dash
  else
    echo "no REAL(16): building without -DPENF_R16P, the tests using R16P are excluded"
    for test in $(grep -l R16P src/tests/*/*.f90); do
      args+=(--exclude "$test")
    done
  fi
  rm -rf "$probe"
  fobis build "${args[@]}"
fi
bash scripts/run_tests.sh
