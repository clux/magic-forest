# Magic Forest Benchmarks
Personal comparisons of languages based on how I would use them.

# Implementation
Only the brute forcing solution is used for all languages.

- Build up the entire tree mutation by mutation from the initial forest
- In mutation step, create all possible variations, then filter out invalids, then sort and remove duplicates
- Continue doing mutation steps until a stable solution is found

No analytical solutions, or optimized search paths will be employed.

## Usage

```bash
# javascript
$ ./forest 305 295 300
# c++11
$ clang++ -O3 -std=c++11 forest.cpp -o forest
./forest 305 295 300
```

## Notes
All files in here are based on resources from [the original post](http://unriskinsight.blogspot.co.uk/2014/06/fast-functional-goats-lions-and-wolves.html), but rewritten to be nice looking.

TL;DR benchmarks results.

- C++ rewrite is just as fast as original.
- JS rewrite is just a lot shorter and slightly faster.
- C++ version is roughly 14 times faster than the JS version.
