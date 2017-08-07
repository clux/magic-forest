#!/bin/bash

build_all() {
  go build -o goforest forest.go
  ghc -O forest.hs -o ghcforest # creates forest.{hi,o} pointlessly
  g++ -O3 -std=c++14 forest.cpp -o cppforest
  rustc -C opt-level=3 forest.rs -o rustforest
  gfortran -O3 forest.f08 -o fortranforest
}

verify_output() {
  [[ $(./fortranforest 105 95 100 | wc -l) == 200218 ]]
  [[ $(./forest.js 105 95 100 | wc -l) == 200216 ]]
  [[ $(./forest.py 105 95 100 | wc -l) ]]
  [[ $(./goforest 105 95 100 | wc -l) == 200216 ]]
  [[ $(./ghcforest 105 95 100 2>&1 | wc -l) == 200216 ]]
  [[ $(./forest.ex 105 95 100 | wc -l) == 200216 ]]
  [[ $(./rustforest 105 95 100 | wc -l) == 200216 ]]
  [[ $(./cppforest 105 95 100 | wc -l) == 200216 ]]
}

main() {
  set -ex
  patch -p1 < debug.diff
  build_all
  verify_output
}

main
