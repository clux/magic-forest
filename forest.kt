data class Forest(val goats: Int, val wolves: Int, val lions: Int) {
  fun isValid(): Boolean {
    return goats >= 0 && wolves >= 0 && lions >= 0
  }
  fun isStable(): Boolean {
    return (goats == 0 && (wolves == 0 || lions == 0)) || (wolves == 0 && lions == 0)
  }
}

fun mutate(forests: List<Forest>) : List<Forest> {
  var next = ArrayList<Forest>(3*forests.size)
  for (f: Forest in forests) {
    next.add(Forest(f.goats - 1, f.wolves - 1, f.lions + 1))
    next.add(Forest(f.goats - 1, f.wolves + 1, f.lions - 1))
    next.add(Forest(f.goats + 1, f.wolves - 1, f.lions - 1))
  }
  return next.filter(Forest::isValid).distinct()
}

fun solve(f: Forest) : List<Forest> {
  var forests = List<Forest>(1, {f})
  while (forests.any() && !forests.any(Forest::isStable)) {
    forests = mutate(forests)
  }
  return forests.filter(Forest::isStable)
}

fun main(args : Array<String>) {
  val initial = Forest(args[0].toInt(), args[1].toInt(), args[2].toInt())
  println("Initial: ${initial}")
  for (f: Forest in solve(initial)) {
    println("Solution: ${f}")
  }
}
