# Magic Forest Benchmarks
Personal comparisons of languages based on what I consider idiomatic use of these languages.

This is based on the old blog post [Fast Functional Goats, Lions and Wolves](http://unriskinsight.blogspot.co.uk/2014/06/fast-functional-goats-lions-and-wolves.html) which gathered some publicity in 2014, but was broken by people finding an analytical solution.

## Rules
Only the brute forcing solution is used for all languages.

- Build up the entire tree mutation by mutation from the initial forest
- In mutation step, create all possible variations, then filter out invalids, then sort and remove duplicates
- Continue doing mutation steps until a stable solution is found
- No third party libraries
- Language idiomatic solution (no obscure/largely expanding optimizations - what would your colleague write?)

No analytical solutions, nor optimized search paths will be employed. Perform the sanity check below:

## Sanity
To verify you are actually doing all the work, print every element in the array/vector in `mutate` before returning it (i.e. after sort + dedup steps). With the standard `305 295 300` input, there should be an extra `4810614` extra lines of output.

## Usage

```bash
# node
time ./forest.js 305 295 300

# python
time ./forest.py 305 295 300

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

- rust 1.19 (stable) is roughly 70 times faster than python 3
- rust 1.19 (stable) is roughly 40 times faster than node 6.11
- rust 1.19 (stable) is roughly 5% faster than c++14 with gcc 7
- c++14 with gcc 7 is roughly 10% faster than c++14 with llvm 4
- c++14 had no noticeable performance change from c++11
- python2 is roughly 5% faster than python3

### Comments
Python probably suffers the most given its lack of an inplace sort/dedup combo (as far as I can tell). There's also appears to be no nice way to size the lists without the `[None] *x` hacks that makes everything ugly. Current solution is probably the cleanest one to read though (if you can ignore the weird semantics of `list(set(comprehension)))`).

Node runs the same task as python in almost half the time despite having to implement it's own filter for removing duplicate ordered elements. It's also a clean functional solution. Historically native loops have been faster than stuff like `reduce`, but we're not going back to those days (so have not tested further).

Modern cpp solution is very readable at only a few more lines than the scripting language counterparts. A bit of mental overhead on emplace, awkward iterator sempantics with back inserters, but even that is pretty standard modern cpp really. There's a more standalone function approach here than rust due to not having traits, and also that passing member functions can look awkward in long `<algorithm>` instructions.

Rust outperforming C++ was unexpected, but it all seems to come down to how many iterator operations you have to do. The original rust solution I saw online was not using `retain` and this saved quite a bit on performance. I chose to go through cargo to get default release optimizations in a stable environment and to clarify that this is a very standard and idiomatic solution without specific flags. It's also the only language herein that was able to derive all the obvious implementations of equality, comparison and print representation.

Some rust extra notes:
- debug builds (i.e. no --release or -O3) are three times slower
- a more cpp style `is_valid` function without pattern matching in rust made no noticeable performance increase, and the pattern matching feels more reabable despite being longer
- using a `::new` wrapper in `mutate` gave an extremely insignificant performance hit, and looks nicer
- arg parsing without a library was awkwardly unwrappy - would not recommend `std::env:args` (knocked it down from the cleanest to read language implementation)
