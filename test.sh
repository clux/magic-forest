#!/bin/bash

build_all() {
  go build -o goforest forest.go
  #ghc -O forest.hs -o ghcforest # creates forest.{hi,o} pointlessly
  g++ -O3 -std=c++14 forest.cpp -o cppforest
  rustc -C opt-level=3 forest.rs -o rustforest
  gfortran -O3 forest.f08 -o fortranforest
}

verify_output() {
  [[ $(./cppforest 55 45 50 | wc -l) == 28866 ]]
  [[ $(./rustforest 55 45 50 | wc -l) == 28866 ]]
  [[ $(./fortranforest 55 45 50 | wc -l) == 28868 ]]
  [[ $(./goforest 55 45 50 | wc -l) == 28866 ]]
  #[[ $(./ghcforest 55 45 50 2>&1 | wc -l) == 28866 ]]
  [[ $(./forest.js 55 45 50 | wc -l) == 28866 ]]
  [[ $(./forest.py 55 45 50 | wc -l) == 28866 ]]
  [[ $(./forest.sh 55 45 50 | wc -l) == 28866 ]]
  [[ $(./forest.rb 55 45 50 | wc -l) == 28866 ]]
  [[ $(./forest.ex 55 45 50 | wc -l) == 28866 ]]
}

main() {
  set -ex
  #patch -p1 < debug.diff
  build_all
  verify_output
}

main
