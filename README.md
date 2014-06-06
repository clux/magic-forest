# Magic Forest Benchmarks
Because benchmarking languages is only useful if you know how you would use the languages you are comparing.

## Usage
Only tests JavaScript and C++11 at the moment as these are the languages I use frequently.

```js
$ ./forest 305 295 300
```

```cpp
$ clang++ -O3 -std=c++11 forest.cpp -o forest
./forest 305 295 300
```

## Goal
Nice thing about this problem:

- not easily parallelizable 
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
