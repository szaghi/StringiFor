#!/bin/bash

echo "Run all tests"
for e in $( ls -F -a ./exe/ | grep "[*]$" ); do
  ./exe/$e | grep -i "Are all tests passed? " | awk -v exe="$e" '{print "is test "exe" passed? "$5}'
done
