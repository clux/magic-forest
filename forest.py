#!/usr/bin/env python
import sys

class Forest:
    def __init__(self, goats, wolves, lions):
        self.goats = goats
        self.wolves = wolves
        self.lions = lions

    def __repr__(self):
        return '{{ goats: {}, wolves: {}, lions: {} }}'.format(self.goats, self.wolves, self.lions)

    def __eq__(self, other):
        return self.goats == other.goats and self.wolves == other.wolves and self.lions == other.lions

    def __hash__(self):
        return hash((self.goats, self.wolves, self.lions))

    def is_stable(self):
        return (self.goats == 0 and (self.wolves == 0 or self.lions == 0)) or \
               (self.wolves == 0 and self.lions == 0)

    def is_valid(self):
        return (self.goats >= 0 and self.wolves >= 0 and self.lions >= 0)


def mutate(forests):
    next = []
    for f in forests:
        next.append(Forest(f.goats - 1, f.wolves - 1, f.lions + 1))
        next.append(Forest(f.goats - 1, f.wolves + 1, f.lions - 1))
        next.append(Forest(f.goats + 1, f.wolves - 1, f.lions - 1))
    # Remove invalids, and sort/dedup by converting to and back from a set
    # This need __hash__ and __eq__ implementations
    return list(set([x for x in next if x.is_valid()]))

def solve(forest):
    forests = [forest]
    while any(forests) and not any(f.is_stable() for f in forests):
        forests = mutate(forests)
    return [f for f in forests if f.is_stable()]

if __name__ == '__main__':
    args = sys.argv
    if len(args) != 4:
        print('USAGE: {} <goats> <wolves> <lions>'.format(args[0]))
        sys.exit(1)

    initial = Forest(int(args[1]), int(args[2]), int(args[3]))
    print('Initial: {}'.format(initial))

    for f in solve(initial):
        print('Solution: {}'.format(f))
