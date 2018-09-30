#!/bin/bash

build_all() {
  mkdir -p scalatmp javatmp # jvm clashes
  go build -o goforest forest.go
  ghc -O forest.hs -o ghcforest
  crystal build forest.cr --release -o crystalforest
  g++ -O3 -std=c++14 forest.cpp -o cppforest
  rustc -C opt-level=3 forest.rs -o rustforest
  gfortran -O3 forest.f08 -o fortranforest
  scalac -d scalatmp/ forest.sc
  kotlinc forest.kt
  cp forest.rpy forest-r.py && rpython --output rpyforest forest-r.py
  (cp forest.java javatmp/Main.java && cd javatmp && javac Main.java)
}

verify_output() {
  [[ $(./rustforest 55 45 50 | wc -l) == 28866 ]]
  [[ $(./cppforest 55 45 50 | wc -l) == 28866 ]]
  [[ $(./crystalforest 55 45 50 | wc -l) == 28866 ]]
  [[ $(./fortranforest 55 45 50 | wc -l) == 28868 ]]
  [[ $(./goforest 55 45 50 | wc -l) == 28866 ]]
  cd scalatmp && [[ $(scala Main 55 45 50 | wc -l) == 28866 ]] && cd -
  cd javatmp && [[ $(java Main 55 45 50 | wc -l) == 28866 ]] && cd -
  [[ $(kotlin ForestKt 55 45 50 | wc -l) == 28866 ]]
  [[ $(./ghcforest 55 45 50 2>&1 | wc -l) == 28866 ]]
  [[ $(./forest.js 55 45 50 | wc -l) == 28866 ]]
  [[ $(./forest.py 55 45 50 | wc -l) == 28866 ]]
  [[ $(./forest.sh 55 45 50 | wc -l) == 28866 ]]
  [[ $(./forest.rb 55 45 50 | wc -l) == 28866 ]]
  [[ $(./forest.ex 55 45 50 | wc -l) == 28866 ]]
  [[ $(./forest.jl 55 45 50 | wc -l) == 28866 ]]
  [[ $(./rpyforest 55 45 50 | wc -l) == 28866 ]]
}

main() {
  set -ex
  patch -p1 < debug.diff
  build_all
  verify_output
}

main
