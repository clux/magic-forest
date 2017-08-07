#!/usr/bin/env python
# forest with tuples
import sys

GOATS = 0
WOLVES = 1
LIONS = 2


def is_stable(forest):
    return (forest[GOATS] == 0 and (forest[WOLVES] == 0 or forest[LIONS] == 0)) or \
           (forest[WOLVES] == 0 and forest[LIONS] == 0)


def is_valid(forest):
    return forest[GOATS] >= 0 and forest[WOLVES] >= 0 and forest[LIONS] >= 0


def mutate(forests):
    next = set()
    for forest in forests:
        new = (
            (forest[GOATS] - 1, forest[WOLVES] - 1, forest[LIONS] + 1),
            (forest[GOATS] - 1, forest[WOLVES] + 1, forest[LIONS] - 1),
            (forest[GOATS] + 1, forest[WOLVES] - 1, forest[LIONS] - 1)
        )
        [next.add(f) for f in new if is_valid(f)]
    return next


def solve(forest):
    forests = {forest}
    while forests and not any(is_stable(f) for f in forests):
        forests = mutate(forests)
    return (f for f in forests if is_stable(f))


def init():
    args = sys.argv
    if len(args) != 4:
        print('USAGE: {} <goats> <wolves> <lions>'.format(args[0]))
        sys.exit(1)

    initial = (int(args[1]), int(args[2]), int(args[3]))
    print('Initial: {}'.format(initial))
    return initial


if __name__ == '__main__':
    initial = init()
    import timeit

    n = 5
    solutions = timeit.timeit('print(list(solve(initial)))', 'from __main__ import solve, init; initial=init();',
                              number=n)
    print('done %s in avg %s' % (n, solutions / n))
