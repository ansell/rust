#!/bin/sh

repo=$(cd "$(dirname "$0")/.." && pwd)
exitcode=0

for e in $repo/exercises/*; do
   if [ -f "$e/.meta/ignore-count-ignores" ]; then
      continue
   fi
   if [ -d "$e/tests" ]; then
      for t in $e/tests/*.rs; do
        tests=$(grep "^\s*\#\[test\]" $t | wc -l | tr -d '[:space:]')
        ignores=$(grep "^\s*\#\[ignore\]" $t | wc -l | tr -d '[:space:]')
        want_ignores=$(expr $tests - 1)
        if [ "$ignores" != "$want_ignores" ]; then
          echo "\033[1;31m$t: Has $tests tests and $ignores ignores (should be $want_ignores)\033[0m"
          exitcode=1
        fi
      done
   fi
done

exit $exitcode
