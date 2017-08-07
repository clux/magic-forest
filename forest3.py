#!/usr/bin/env python
# forest with named tuples
import sys
from collections import namedtuple
Forest = namedtuple('Forest', ('goats', 'wolves', 'lions'))


def is_stable(forest):
    return (forest.goats == 0 and (forest.wolves == 0 or forest.lions == 0)) or \
           (forest.wolves == 0 and forest.lions == 0)


def is_valid(forest):
    return forest.goats >= 0 and forest.wolves >= 0 and forest.lions >= 0


def mutate(forests):
    next = set()
    for forest in forests:
        new = (
            Forest(forest.goats - 1, forest.wolves - 1, forest.lions + 1),
            Forest(forest.goats - 1, forest.wolves + 1, forest.lions - 1),
            Forest(forest.goats + 1, forest.wolves - 1, forest.lions - 1),
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

    initial = Forest(goats=int(args[1]), wolves=int(args[2]), lions=int(args[3]))
    print('Initial: {}'.format(initial))
    return initial


if __name__ == '__main__':
    initial = init()
    import timeit

    n = 5
    solutions = timeit.timeit('print(list(solve(initial)))', 'from __main__ import solve, init; initial=init();', number=n)
    print('done %s in avg %s' % (n, solutions / n))
