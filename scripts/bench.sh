#!/usr/bin/env bash
# Benchmarks of the UTF-8 work (issue #51, design rule R5): time the methods the plan touches and compare runs.
#
# Usage: bash scripts/bench.sh run [-o FILE] [BYTES ...]   build (scripts/utf8/build.sh) and time; CSV to FILE or stdout
#          the driver runs BENCH_REPEAT times (default 3), pinned to CPU BENCH_CPU (default 2; "" for no pinning), and
#          each timing is the minimum over the runs: on a hybrid CPU (P and E cores) one unpinned run varies by 20%
#        bash scripts/bench.sh compare BASELINE NEW [--tolerance PERCENT]   fail if ASCII timings are slower (default 5%)
#        FC=nvfortran bash scripts/bench.sh run ...        another compiler
# Baselines live in scripts/utf8/baselines/, named <version>-<host>-<compiler>.csv; never overwrite one, add a new file.
# Noise: two pinned 3-run results of the same code differ by up to 6% on single timings (median 1%, i9-13900KF), so a
# timing that fails the comparison is re-measured before it counts as a regression.
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
command=${1:-}; shift || true
case "$command" in
  run)
    out=/dev/stdout
    if [ "${1:-}" = -o ]; then out=$2; shift 2; fi
    bin=$(bash "$root/scripts/utf8/build.sh" | tail -n 1)
    fc=${FC:-gfortran}
    tmp=$(mktemp -d)
    trap 'rm -rf -- "$tmp"' EXIT
    {
      printf '# compiler: %s\n' "$("$fc" --version 2>&1 | grep -m 1 -E '[0-9]+\.[0-9]+')"
      printf '# flags: %s\n' "${FFLAGS:--O2}"
      printf '# host: %s, %s\n' "$(hostname)" "$(grep -m 1 'model name' /proc/cpuinfo | cut -d: -f2- | sed 's/^ //')"
      printf '# source: %s\n' "$(git -C "$root" describe --tags --always --dirty)"
      printf '# src/lib sha256: %s\n' "$(cat "$root"/src/lib/*.F90 | sha256sum | cut -c1-16)"
      printf '# date: %s\n' "$(date '+%F %T')"
      printf '# pinned to cpu: %s\n' "${BENCH_CPU-2}"
    } > "$tmp/meta.csv"
    pin=()
    if [ -n "${BENCH_CPU-2}" ] && command -v taskset > /dev/null; then pin=(taskset -c "${BENCH_CPU-2}"); fi
    runs=()
    for i in $(seq 1 "${BENCH_REPEAT:-3}"); do
      { cat "$tmp/meta.csv"; "${pin[@]}" "$bin/bench_driver" "$@"; } > "$tmp/run$i.csv"
      runs+=("$tmp/run$i.csv")
    done
    python3 -I "$root/scripts/utf8/bench.py" merge "${runs[@]}" > "$out"
    ;;
  compare)
    exec python3 -I "$root/scripts/utf8/bench.py" compare "$@" ;;
  *)
    sed -n '2,8p' "$0" >&2; exit 2 ;;
esac
