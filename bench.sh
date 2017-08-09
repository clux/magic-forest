#!/bin/bash

build_all() {
  go build -o goforest forest.go
  ghc -O forest.hs -o ghcforest # creates forest.{hi,o} pointlessly
  g++ -O3 -std=c++14 forest.cpp -o cppforest
  clang++ -O3 -std=c++14 forest.cpp -o cppforestclang
  rustc -C opt-level=3 forest.rs -o rustforest
  gfortran -O3 forest.f08 -o fortranforest # creates more pointless files
}

run_all() {
  echo "Rust" && time ./rustforest 305 295 300
  echo "C++" && time ./cppforest 305 295 300
  echo "C++ (llvm)" && time ./cppforestclang 305 295 300
  echo "Go" && time ./goforest 305 295 300
  echo "NodeJS" && time ./forest.js 305 295 300
  echo "Elixir" && time ./forest.ex 305 295 300
  echo "Python 3" && time ./forest.py 305 295 300
  echo "Python (PYPY3)" && time pypy3 forest.py 305 295 300
  echo "Haskell" && time ./ghcforest 305 295 300
  echo "Fortran" && time ./fortranforest 305 295 300
}

main() {
  set -ex
  build_all
  run_all
}

main
