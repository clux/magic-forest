#!/usr/bin/env python
import sys
from collections import namedtuple

Forest = namedtuple('Forest', ('goats', 'wolves', 'lions'))

def is_stable(f):
    return (f.goats == 0 and (f.wolves == 0 or f.lions == 0)) or (f.wolves == 0 and f.lions == 0)

def is_valid(f):
    return f.goats >= 0 and f.wolves >= 0 and f.lions >= 0

def mutate(forests):
    next = []
    for f in forests:
        next.append(Forest(f.goats - 1, f.wolves - 1, f.lions + 1))
        next.append(Forest(f.goats - 1, f.wolves + 1, f.lions - 1))
        next.append(Forest(f.goats + 1, f.wolves - 1, f.lions - 1))
    return set(f for f in next if is_valid(f))

def solve(forest):
    forests = [forest]
    while any(forests) and not any(is_stable(f) for f in forests):
        forests = mutate(forests)
    return (f for f in forests if is_stable(f))

if __name__ == '__main__':
    args = sys.argv
    if len(args) != 4:
        print('USAGE: {} <goats> <wolves> <lions>'.format(args[0]))
        sys.exit(1)

    initial = Forest(int(args[1]), int(args[2]), int(args[3]))
    print('Initial: {}'.format(initial))

    for f in solve(initial):
        print('Solution: {}'.format(f))
