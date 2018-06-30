#!/bin/bash

build_all() {
  mkdir -p scalatmp javatmp # jvm clashes
  go build -o goforest forest.go
  crystal build forest.cr --release -o crystalforest
  ghc -O3 forest.hs -o ghcforest # creates forest.{hi,o} pointlessly
  g++ -O3 -std=c++14 forest.cpp -o cppforest
  clang++ -O3 -std=c++14 forest.cpp -o cppforestclang
  rustc -C opt-level=3 forest.rs -o rustforest
  gfortran -O3 forest.f08 -o fortranforest # creates more pointless files
  scalac -d scalatmp/ -opt:_ forest.sc # and more
  kotlinc forest.kt
  cp forest.rpy forest-r.py && rpython --output rpyforest forest-r.py
  (cp forest.java javatmp/Main.java && cd javatmp && javac Main.java)
}

run_all() {
  echo "Rust" && time ./rustforest 305 295 300
  echo "C++" && time ./cppforest 305 295 300
  echo "C++ (llvm)" && time ./cppforestclang 305 295 300
  echo "Kotlin" && time kotlin ForestKt 305 295 300
  echo "RPython" && time ./rpyforest 305 295 300
  echo "Fortran" && time ./fortranforest 305 295 300
  echo "Java" && cd javatmp && time java Main 305 295 300 && cd -
  echo "Go" && time ./goforest 305 295 300
  echo "Crystal" && time ./crystalforest 305 295 300
  echo "Scala" && cd scalatmp && time scala Main 305 295 300 && cd -
  echo "Haskell" && time ./ghcforest 305 295 300
  echo "Python (PYPY3)" && time pypy3 forest.py 305 295 300
  echo "Elixir" && time ./forest.ex 305 295 300
  echo "NodeJS" && time ./forest.js 305 295 300
  echo "Ruby" && time ./forest.rb 305 295 300
  echo "Python 3" && time ./forest.py 305 295 300
  echo "Shell" && time ./forest.sh 305 295 300
}

main() {
  set -ex
  build_all
  run_all
}

main
