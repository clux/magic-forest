# Magic Forest Benchmarks
Personal comparisons of languages based on what I consider idiomatic use of these languages.

# Implementation
Only the brute forcing solution is used for all languages.

- Build up the entire tree mutation by mutation from the initial forest
- In mutation step, create all possible variations, then filter out invalids, then sort and remove duplicates
- Continue doing mutation steps until a stable solution is found

No analytical solutions, nor optimized search paths will be employed.

## Usage

```bash
# node 6
time ./forest.js 305 295 300
# c++14
clang++ -O3 -std=c++14 forest.cpp -o cppforest
time ./cppforest 305 295 300
```

## Notes
All files in here are based on resources from [the original post](http://unriskinsight.blogspot.co.uk/2014/06/fast-functional-goats-lions-and-wolves.html), but rewritten to be nice looking.

TL;DR benchmarks results.

- C++ rewrite is just as fast as original.
- JS rewrite is just a lot shorter and slightly faster.
- C++ version is roughly 34 times faster than the JS version.
