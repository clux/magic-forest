# Magic Forest Benchmarks
Personal comparisons of languages based on what I consider idiomatic use of these languages. Don't read too much into these.

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
# python
time ./forest.py 305 295 300

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

# haskell (ghc)
ghc -O forest.hs
time ./forest 305 295 300
```

## Personal Results
Last tested 29th July 2017 on an i7 7700K, using latest packages in Arch: stable rust (1.19), python 3, node 6 LTS, go 1.8, c++ with both llvm4 and gcc7, haskell with ghc8.

- rust is roughly 800 times faster than haskell
- rust is roughly 70 times faster than python
- rust is roughly 40 times faster than node
- rust is roughly 3 times faster than go
- rust is roughly 5% faster than gcc/c++
- gcc/c++ is roughly 10% faster than llvm/c++
- c++14 compiler flag had no noticeable performance change from c++11
- python2 is roughly 5% faster than python3

### Comments
#### Haskell
Haskell is just terrible for this. The exponentially growing lists that keep being duplicated just cause the thing to grind to a halt with my normal parameters. Bang patterns sped it up by a factor of 3 (not super idiomatic), but you really need `Data.Vector` here for this. Unfortunately for Haskell, bypassing both laziness and purity is too far from idiomatic for me to bother with it. [Someone has done it](https://github.com/logicchains/MagicForest/blob/master/hsForest.hs), but it looks terrible.

#### Python
Python probably suffers from its lack of an inplace sort/dedup combo (as far as I can tell). There's also appears to be no nice way to size the lists without the `[None] *x` hacks that makes everything ugly. Current solution is probably one of the cleanest one to read though (if you can ignore the weird semantics of `list(set(comprehension)))`).

#### Node
Node runs the same task as python in almost half the time despite having to implement it's own filter for removing duplicate ordered elements. It's also a clean functional solution. Historically native loops have been faster than stuff like `reduce`, but on node 6, using `forEach` with a correctly sized `new Array(3*forests.length)` as a starting point in `mutate` turned out to be quite detrimental to performance (14->18s).

#### C++
Modern cpp solution is very readable at only a few more lines than the scripting language counterparts. A bit of mental overhead on emplace, awkward iterator sempantics with back inserters, but even that is pretty standard modern cpp really. There's a more standalone function approach here than rust due to not having traits, and also that passing member functions can look awkward in long `<algorithm>` instructions.

#### Go
This version feels very much like python. Same type of hack to sort and deduplicate an array, but using a map with throwaway values instead to force it out of key uniqueness. It's probably not super optimal, but then it's also kind of cheating by deduplicating earlier than all other languages (in the creation phase). Not sure if abusing comparables like this is a common practice, but all other googled solutions for this were too large to consider. The explicit filters functions having to be inlined everywhere makes this solution the ugliest one of them all. It's vastly faster than any of the scripting languages though.

Go and Rust were the only two languages to automatically derive the obvious implementations of equality, comparison and print representation.

### Rust
Rust outperforming C++ was unexpected, but it all seems to come down to how many iterator operations you have to do. The original rust solution I saw online was not using `retain` and this saved quite a bit on performance. Personally, this feels like one of the cleanest and least magic implementations of the bunch.

Some rust extra notes:
- using `cargo build --release` with the same file as `main.rs` had no change in performance despite more flags sent to `rustc` by cargo - chose to use `rustc` directly just for folder structure because of this
- missing release optimizations are 3-8 times slower (depending on whether you use cargo debug builds or rustc without any flags)
- a more cpp style `is_valid` function without pattern matching in rust made no noticeable performance increase, and the pattern matching feels more reabable despite being longer
- using a `::new` wrapper in `mutate` gave an extremely insignificant performance hit, and looks nicer
