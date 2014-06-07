# Magic Forest Benchmarks
Because benchmarking languages is only useful if you know how you would use the languages you are comparing.

# Implementation
Only the brute forcing solution is used for all languages.

- Build up the entire tree mutation by mutation from the initial forest
- In mutation step, create all possible variations, then filter out invalids, then sort and remove duplicates
- Continue doing mutation steps until a stable solution is found

## Usage
Only tests JavaScript and C++11 atm:

```js
$ ./forest 305 295 300
```

```cpp
$ clang++ -O3 -std=c++11 forest.cpp -o forest
./forest 305 295 300
```

## Goal
Nice thing about this problem:

- not easily parallelizable (when restricting yourself to the brute force solution)
- easy algorithm to port to other languages
- easy to shape to how you would use it in the other language
- reference implementations in many languages available

All files in here are based on resources from [the original post](http://unriskinsight.blogspot.co.uk/2014/06/fast-functional-goats-lions-and-wolves.html).

## Notes
TL;DR benchmarks results.

The C++ version, rewritten to be more readable than the reference implementation, is just as fast.
The JS version, rewritten to HOW I WOULD USE JS (functional and concise), is slightly faster, but a LOT shorter.

C++ version is roughly 14 times faster than the JS version.
The C++ version is only 40% more (active) code than the JS version.
