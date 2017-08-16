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

func (f Forest) IsStable() bool {
	if f.goats == 0 {
		return f.wolves == 0 || f.lions == 0
	}
	return f.wolves == 0 && f.lions == 0
}

func (f Forest) IsValid() bool {
	return f.goats >= 0 && f.wolves >= 0 && f.lions >= 0
}

type ForestSet map[Forest]struct{}

func (fs ForestSet) AnyStable() bool {
	for forest := range fs {
		if forest.IsStable() {
			return true
		}
	}
	return false
}

func mutate(forestSet ForestSet) ForestSet {
	potentials := make([]Forest, 0, len(forestSet)*3)
	for forest := range forestSet {
		potentials = append(potentials,
			Forest{forest.goats - 1, forest.wolves - 1, forest.lions + 1},
			Forest{forest.goats - 1, forest.wolves + 1, forest.lions - 1},
			Forest{forest.goats + 1, forest.wolves - 1, forest.lions - 1},
		)
	}

	newForestSet := make(ForestSet, len(potentials))
	for _, forest := range potentials {
		if forest.IsValid() {
			newForestSet[forest] = struct{}{}
		}
	}
	return newForestSet
}

func solve(initialForest Forest) []Forest {
	forestSet := ForestSet{initialForest: struct{}{}}
	for len(forestSet) > 0 && !forestSet.AnyStable() {
		forestSet = mutate(forestSet)
	}
	// return the stable remains
	stable := make([]Forest, 0, len(forestSet))
	for forest := range forestSet {
		if forest.IsStable() {
			stable = append(stable, forest)
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
