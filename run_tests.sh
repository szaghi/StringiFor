#!/bin/bash

all_passed () {
  local array="$1[@]"
  local ok=1
  for element in "${!array}"; do
    if [ "$element" == 'F' ]; then
      ok=0
      break
    fi
  done
  echo $ok
}

echo "Run all tests"
declare -a tests_executed
for e in $( ls -F -a ./exe/ | grep "[*]$" ); do
  is_passed=`./exe/$e | grep -i "Are all tests passed? " | awk '{print $5}'`
  tests_executed=("${tests_executed[@]}" "$is_passed")
  echo "  run test $e, is passed? $is_passed"
done
passed=$(all_passed tests_executed)
echo "Number of tests executed ${#tests_executed[@]}"
if [ $passed -eq 1 ]; then
  echo "All tests passed"
  exit 0
else
  echo "Some tests failed"
  exit 1
fi
