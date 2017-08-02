#!/bin/bash

build_all() {
  go build -o goforest forest.go
  ghc -O forest.hs -o ghcforest # creates forest.{hi,o} pointlessly
  g++ -O3 -std=c++14 forest.cpp -o cppforest
  rustc -C opt-level=3 forest.rs -o rustforest
}

verify_output() {
  local -r noderes=$(./forest.js 105 95 100 | wc -l)
  local -r pyres=$(./forest.py 105 95 100 | wc -l)
  local -r gores=$(./goforest 105 95 100 | wc -l)
  local -r cppres=$(./cppforest 105 95 100 | wc -l)
  # haskell's traceShowId prints to stderr
  local -r ghcres=$(./ghcforest 105 95 100 2>&1 | wc -l)
  local -r iexres=$(./forest.ex 105 95 100 | wc -l)
  local -r rustres=$(./rustforest 105 95 100 | wc -l)


  [[ $noderes == 200216 ]]
  [[ $pyres == 200216 ]]
  [[ $gores == 200216 ]]
  [[ $ghcres == 200216 ]]
  [[ $iexres == 200216 ]]
  [[ $rustres == 200216 ]]
  [[ $cppres == 200216 ]]
}

main() {
  set -ex
  patch -p1 < debug.diff
  build_all
  verify_output
}

main
