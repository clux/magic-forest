[private]
default:
  @just --list --unsorted

crystal:
  crystal build forest.cr --release -o crystalforest

fortran:
  gfortran -O3 forest.f08 -o fortranforest

scala:
  scalac -d scalatmp/ -opt:_ forest.sc

go:
  go build -o goforest forest.go

haskell:
  ghc -O3 forest.hs -o ghcforest # creates forest.{hi,o} pointlessly

cpp:
  # two variants - gcc + clang
  g++ -O3 -std=c++14 forest.cpp -o cppforest
  clang++ -O3 -std=c++14 forest.cpp -o cppforestclang

rust:
  rustc -C opt-level=3 forest.rs -o rustforest

kotlin:
  kotlinc forest.kt
