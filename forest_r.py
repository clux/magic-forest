class Forest(object):
    def __init__(self, goats, wolves, lions):
        self.goats = goats
        self.wolves = wolves
        self.lions = lions

    def __eq__(self, other):
        return (
            self.goats == other.goats and
            self.wolves == other.wolves and
            self.lions == other.lions
        )

    def __hash__(self):
        return hash((self.goats, self.wolves, self.lions))

    def __str__(self):
        return "%d %d %d" % (self.goats, self.wolves, self.lions)

    def __repr__(self):
        return str(self)


def is_stable(f):
    return (f.goats == 0 and (f.wolves == 0 or f.lions == 0)) or (f.wolves == 0 and f.lions == 0)


def is_valid(f):
    return f.goats >= 0 and f.wolves >= 0 and f.lions >= 0


def mutate(forests):
    next_forests = []
    for f in forests:
        next_forests.append(Forest(f.goats - 1, f.wolves - 1, f.lions + 1))
        next_forests.append(Forest(f.goats - 1, f.wolves + 1, f.lions - 1))
        next_forests.append(Forest(f.goats + 1, f.wolves - 1, f.lions - 1))

    # rpython has no `set()`
    forest_map = {}
    for f in next_forests:
        forest_map[f] = None
    return [f for f in forest_map.keys() if is_valid(f)]


def any(iterable):
    for i in iterable:
        if i:
            return True
    return False


def has_stable_forest(forests):
    for f in forests:
        if is_stable(f):
            return True
    return False


def solve(forest):
    # rpython can't use complex generators
    # e.g. avoid running multiple generators at the same time
    forests = [forest]
    while any(forests) and not has_stable_forest(forests):
        forests = mutate(forests)
    print('forests: %d' % len(forests))
    return [f for f in forests if is_stable(f)]


def entry_point(args):
    if len(args) != 4:
        print('USAGE: ' + args[0] + ' <goats> <wolves> <lions>')
        return 1

    forest = Forest(int(args[1]), int(args[2]), int(args[3]))
    print('Initial:', forest)

    for f in solve(forest):
        print('Solution:', f)
    return 0


def target(*args):
    return entry_point, None


# Compatability with python interpreters
if __name__ == '__main__':
    import sys
    sys.exit(entry_point(sys.argv))
