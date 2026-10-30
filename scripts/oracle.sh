#!/usr/bin/env bash
# Run a suite of the oracle harness of the UTF-8 work (issue #51): build the library and the driver with one compiler
# (scripts/utf8/build.sh), then compare the results of the driver with the Python reference (scripts/utf8/oracle.py).
#
# Usage: bash scripts/oracle.sh SUITE [oracle.py options]      e.g. bash scripts/oracle.sh invariant --self-test
#        FC=nvfortran bash scripts/oracle.sh SUITE              another compiler
#        bash scripts/oracle.sh --list                          the suites
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
if [ "${1:-}" = --list ]; then exec python3 -I "$root/scripts/utf8/oracle.py" --list; fi
bin=$(bash "$root/scripts/utf8/build.sh" | tail -n 1)
python3 -I "$root/scripts/utf8/oracle.py" "$@" --driver "$bin/oracle_driver" --compiler "$(basename "${FC:-gfortran}")" \
  --work "$root/build/utf8/oracle-$(basename "${FC:-gfortran}")"
