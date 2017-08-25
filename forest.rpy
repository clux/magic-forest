try:
    # Maintain interpreter compatibility when running under CPython
    from rpython.rlib.jit import JitDriver, purefunction
except ImportError:
    class JitDriver(object):
        def __init__(self, **kwargs):
            pass

        def jit_merge_point(self, **kwargs):
            pass

        def can_enter_jit(self, **kwargs):
            pass

    def purefunction(f):
        return f

jitdriver = JitDriver(greens=['forests'], reds=[])


@purefunction
def is_stable(f):
    return (f[0] == 0 and (f[1] == 0 or f[2] == 0)) or (f[1] == 0 and f[2] == 0)


@purefunction
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


@purefunction
def any(iterable):
    for i in iterable:
        if i:
            return True
    return False


@purefunction
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
        jitdriver.jit_merge_point(forests=forests)
        forests = mutate(forests)
    return [f for f in forests if is_stable(f)]


def entry_point(args):
    if len(args) != 4:
        print 'USAGE: ' + args[0] + ' <goats> <wolves> <lions>'
        return 1

    forest = (int(args[1]), int(args[2]), int(args[3]))
    print 'Initial:', forest

    for f in solve(forest):
        print 'Solution:', f
    return 0


def target(*args):
    return entry_point, None


def jitpolicy(driver):
    from rpython.jit.codewriter.policy import JitPolicy
    return JitPolicy()

# Compatability with python interpreters
if __name__ == '__main__':
    import sys
    sys.exit(entry_point(sys.argv))
