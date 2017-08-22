def is_stable(f):
    return (f[0] == 0 and (f[1] == 0 or f[2] == 0)) or (f[1] == 0 and f[2] == 0)


def is_valid(f):
    return f[0] >= 0 and f[1] >= 0 and f[2] >= 0


def mutate(forests):
    next_forests = []
    for f in forests:
        next_forests.append((f[0] - 1, f[1] - 1, f[2] + 1))
        next_forests.append((f[0] - 1, f[1] + 1, f[2] - 1))
        next_forests.append((f[0] + 1, f[1] - 1, f[2] - 1))

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


def solve(forest):
    # rpython can't use complex generators
    # e.g. avoid running multiple generators at the same time
    forests = [forest]
    stable_forests = [f for f in forests if is_stable(f)]
    while any(forests) and not any(stable_forests):
        forests = mutate(forests)
        stable_forests = [f for f in forests if is_stable(f)]
    return stable_forests


def entry_point(args):
    if len(args) != 4:
        print('USAGE: ' + args[0] + ' <goats> <wolves> <lions>')
        return 1

    initial = (int(args[1]), int(args[2]), int(args[3]))
    print('Initial: %d %d %d' % initial)

    for f in solve(initial):
        print('Solution: %d %d %d' % initial)
    return 0


def target(*args):
    return entry_point, None


# Compatability with python interpreters
if __name__ == '__main__':
    import sys
    sys.exit(entry_point(sys.argv))
