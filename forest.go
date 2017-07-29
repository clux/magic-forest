package main

import (
  "fmt"
  "os"
  "strconv"
)

type Forest struct {
  goats  int32
  wolves int32
  lions  int32
}

func (f Forest) forestStable() bool {
  if f.goats == 0 {
    return f.wolves == 0 || f.lions == 0
  }
  return f.wolves == 0 && f.lions == 0
}

func (f Forest) forestInvalid() bool {
  return f.goats < 0 || f.wolves < 0 || f.lions < 0
}

func mutate(forests []Forest) []Forest {
  next := make([]Forest, 0, len(forests) * 3)
  m := make(map[Forest]struct{})
  for _, v := range forests {
    m[Forest{v.goats-1, v.wolves-1, v.lions+1}] = struct{}{}
    m[Forest{v.goats-1, v.wolves+1, v.lions-1}] = struct{}{}
    m[Forest{v.goats+1, v.wolves-1, v.lions-1}] = struct{}{}
  }
  // remove invalids and deduplicate by using the entire struct as a key in a map
  // this feels inefficient due to all the empty throwaway structs in the map values
  for k := range m {
    if !k.forestInvalid() {
      next = append(next, k)
    }
  }
  return next
}

func noStableForests(forests []Forest) bool {
  for _, x := range forests {
    if x.forestStable() {
      return false
    }
  }
  return true
}

func solve(forest Forest) []Forest {
  xs := make([]Forest, 0, 3)
  xs = append(xs, forest)
  for len(xs) > 0 && noStableForests(xs) {
    xs = mutate(xs)
  }
  // return the stable remains
  stable := make([]Forest, 0, len(xs)*3)
  for _, x := range xs {
    if x.forestStable() {
      stable = append(stable, x)
    }
  }
  return stable
}

func main() {
  if len(os.Args) != 4 {
    fmt.Println("USAGE: forest <goats> <wolves> <lions>")
    os.Exit(1)
  }
  goats, _ := strconv.Atoi(os.Args[1])
  wolves, _ := strconv.Atoi(os.Args[2])
  lions, _ := strconv.Atoi(os.Args[3])

  initial := Forest{int32(goats), int32(wolves), int32(lions)}
  fmt.Printf("Initial: %v\n", initial)

  for _, f := range solve(initial) {
    fmt.Printf("Solution: %v\n", f)
  }
}
