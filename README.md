# Magic Forest Benchmarks
Personal comparisons of languages based on what I consider idiomatic use of these languages.

# Implementation
Only the brute forcing solution is used for all languages.

- Build up the entire tree mutation by mutation from the initial forest
- In mutation step, create all possible variations, then filter out invalids, then sort and remove duplicates
- Continue doing mutation steps until a stable solution is found

No analytical solutions, nor optimized search paths will be employed.

# Sanity
To verify you are actually doing all the work, print every element in the array/vector in `mutate` before returning it (i.e. after sort + dedup steps). With the standard `305 295 300` input, there should be an extra `4810614` extra lines of output.

## Usage

```bash
# node
time ./forest.js 305 295 300

# c++14 (gcc)
g++ -O3 -std=c++14 forest.cpp -o cppforest
time ./cppforest 305 295 300
# c++14 (llvm)
clang++ -O3 -std=c++14 forest.cpp -o cppforestllvm
time ./cppforestllvm 305 295 300

# rust (default release optimizations)
(cd rust && cargo build --release)
time ./rust/target/release/forest 305 295 300
```

## Personal Results
Last tested July 2017

- rust 1.19 (stable) is roughly 40 times faster than node 6.11
- rust 1.19 (stable) is roughly 5% faster than c++14 with gcc 7
- c++14 with gcc 7 is roughly 10% faster than c++14 with llvm 4
- c++14 had no noticable performance change from c++11

## Notes
All files in here are based on resources from [the original post](http://unriskinsight.blogspot.co.uk/2014/06/fast-functional-goats-lions-and-wolves.html), but rewritten to be nice looking.
