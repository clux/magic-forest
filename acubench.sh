#!/bin/bash

build_all() {
  mkdir -p scalatmp # scala clashes with kotlin
  go build -o goforest forest.go
  crystal build forest.cr --release -o crystalforest
  ghc -O3 forest.hs -o ghcforest # creates forest.{hi,o} pointlessly
  g++ -O3 -std=c++14 forest.cpp -o cppforest
  clang++ -O3 -std=c++14 forest.cpp -o cppforestclang
  rustc -C opt-level=3 forest.rs -o rustforest
  gfortran -O3 forest.f08 -o fortranforest # creates more pointless files
  scalac -d scalatmp/ -opt:_ forest.sc # and more
  swiftc -O forest.swift -o swiftforest
  kotlinc forest.kt
  cp forest.rpy forest-r.py && rpython --output rpyforest forest-r.py
  (cp forest.java javatmp/Main.java && cd javatmp && javac Main.java)
}

run_all() {
  echo "Rust" && hyperfine --warmup 3 "./rustforest 305 295 300"
  echo "C++" && hyperfine --warmup 3 "./cppforest 305 295 300"
  echo "C++ (llvm)" && hyperfine --warmup 3 "./cppforestclang 305 295 300"
  echo "Kotlin" && hyperfine --warmup 3 "kotlin ForestKt 305 295 300"
  echo "RPython" && hyperfine --warmup 3 "./rpyforest 305 295 300"
  echo "Fortran" && hyperfine --warmup 3 "./fortranforest 305 295 300"
  echo "Java" && cd javatmp && hyperfine --warmup 3 "java Main 305 295 300" && cd -
  echo "Go" && hyperfine --warmup 3 "./goforest 305 295 300"
  echo "Crystal" && hyperfine --warmup 3 "./crystalforest 305 295 300"
  echo "Julia" && hyperfine --warmup 3 "./forest.jl 305 295 300"
  echo "Scala" && cd scalatmp && hyperfine --warmup 3 "scala Main 305 295 300" && cd -
  echo "Haskell" && hyperfine --warmup 3 "./ghcforest 305 295 300"
  echo "Python (PYPY3)" && hyperfine --warmup 3 "pypy3 forest.py 305 295 300"
  echo "Elixir" && hyperfine --warmup 3 "./forest.ex 305 295 300"
  echo "NodeJS" && hyperfine --warmup 3 "./forest.js 305 295 300"
  echo "Ruby" && hyperfine --warmup 3 "./forest.rb 305 295 300"
  echo "Python 3" && hyperfine --warmup 3 "./forest.py 305 295 300"
  echo "Shell" && hyperfine --warmup 3 "./forest.sh 305 295 300"
}

main() {
  set -ex
  build_all
  run_all
}

main
