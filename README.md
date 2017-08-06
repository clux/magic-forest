# Magic Forest Benchmarks
Personal comparisons of languages based on what I consider idiomatic use of these languages. Don't read too much into these.

This is based on the old blog post [Fast Functional Goats, Lions and Wolves](http://unriskinsight.blogspot.co.uk/2014/06/fast-functional-goats-lions-and-wolves.html) which gathered some publicity in 2014, but was broken by people finding an analytical solution.

## Rules
Only the brute forcing solution is used for all languages.

- Build up the entire tree mutation by mutation from the initial forest
- In mutation step, create all possible variations, then filter out invalids, then sort and remove duplicates
- Continue doing mutation steps until a stable solution is found
- No third party libraries
- Language idiomatic solution (no obscure/largely expanding optimizations)

No analytical solutions, nor optimized search paths will be employed. Perform the sanity check below:

## Sanity
To verify you are actually doing all the work, print every element in the array/vector in `mutate` before returning it (i.e. after sort + dedup steps). With the arguments `105 95 100` input, there should be an extra `200214` lines of output from debug prints (see [debug.diff](./debug.diff) and [test.sh](./test.sh)).

## Usage
Build and run all sequentially with [bench.sh](./bench.sh) or run them individually:

```bash
# python
time ./forest.py 305 295 300

# python (pypy)
time pypy forest.py 305 295 300

# node
time ./forest.js 305 295 300

# go
go build forest.go
time ./forest 305 295 300

# c++ (gcc)
g++ -O3 -std=c++14 forest.cpp -o cppforest
time ./cppforest 305 295 300

# c++ (llvm)
clang++ -O3 -std=c++14 forest.cpp -o cppforestllvm
time ./cppforestllvm 305 295 300

# rust
rustc -C opt-level=3 forest.rs
time ./forest 305 295 300

# elixir
time ./forest.ex 305 295 300

# haskell (ghc)
ghc -O forest.hs
time ./forest 305 295 300
```

## Personal Results
Last tested 29th July 2017 on an i7 7700K, using latest packages in Arch: stable rust (1.19), python 3.6 and pypy 5.8, node 6.11 LTS, go 1.8, c++ with both llvm4 and gcc7, haskell with ghc8, elixir 1.5.0.

- rust: 300ms
- c++/gcc: 300ms
- c++/llvm: 310ms
- go: 1.150s
- haskell: 3s
- python/pypy3: 4s
- elixir: 6s
- node: 14s
- python/3: 24s

All results are based on the above input data `305 295 300`, where the exponential nature of the problem really highlights the differences between languages.

### Discussion
#### Haskell
The cleanest solution here by far if you like the functional style; about half the number of lines of the go solution, but taking twice as long.

This one is interesting because the solution time went from 4 minutes to 3seconds after switching from native lists to `Data.Set`. Native lists probably went into the cache miss territory with these sizes, but it's still a mind-boggling speedup.

#### Python
Performs badly under the default interpreter, but is really solid under pypy. Solution is almost as nice to read as the Haskell implementation.

Sort/dedup done by wrapping the list in a `set()`. Hard to tell how that really works, but it's what everyone uses. There's appears to be no nice way to size the lists without the `[None] * x` hacks.

Current solution is really nice to read.

#### Node
Lands bang in the middle of the two python implementations. Solid effort for having to implement its own duplicate element filter.

It's also a clean functional solution. Historically native loops have been faster than stuff like `reduce`, but on node 6, using `forEach` with a correctly sized `new Array(3*forests.length)` as a starting point in `mutate` actually turned out to be quite detrimental to performance (14->18s).

#### Go
This version feels very similar to python.

There's a similar type of hack to sort and deduplicate an array, here using a map with throwaway values instead to force it out of key uniqueness. It's probably not super optimal, and it's also kind of cheating by deduplicating earlier than all other languages (in the creation phase). Not sure if abusing comparables like this is a common practice, but all other googled solutions for this were too large to consider.

The explicit filters functions having to be inlined everywhere makes this solution the ugliest one of them all. It's vastly faster than any of the scripting languages though.

#### C++
Modern cpp solution is very readable at only a few more lines than the scripting language counterparts. A bit of mental overhead on emplace, awkward iterator sempantics with back inserters, but even that is pretty standard modern cpp really.

It turns out that creating a new list with the unique iterator than erasing from it is faster, but we're trying to keep languages between semantics similar.

There's a more standalone function approach here than rust due to not having traits, and also that passing member functions can look awkward in long `<algorithm>` instructions.

The choice of `-std=c++11` vs `-std=c++14` made no difference in performance.

Deleting or adding the default constructor of forest actually gained 10% performance, we're not sure why.

gcc seems to be consistently around 5% faster than clang.

#### Rust
Rust impressively ties C++ with completely normal code. It all seems to come down to how many iterator operations you have to do. The original rust solution I saw online was not using `retain` and this saved quite a bit on performance.

Perhaps the least magic implementation of the bunch. It's not as nice or short as python / haskell, but at least you can reason about its performance.

Wrapping `forest.rs` inside a `cargo` built project provided no change in performance when building with `cargo build --release` despite more numerous compiler/linker flags.

#### Meta
Interestingly, all the compiled languages apart from C++ were able to automatically derive the obvious implementations of equality, comparison and a sensible print representation.
