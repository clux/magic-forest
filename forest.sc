case class Forest(val goats: Int, val wolves: Int, val lions: Int)
object Forest {
  def isValid(f: Forest): Boolean = f.goats >= 0 && f.wolves >= 0 && f.lions >= 0
  def isStable(f: Forest): Boolean = {
    (f.goats == 0 && (f.wolves == 0 || f.lions == 0)) || (f.wolves == 0 && f.lions == 0)
  }
}

object Main {
  import collection.mutable.ArrayBuffer

  def mutate(forests: Array[Forest]) : Array[Forest] = {
    var next = new ArrayBuffer[Forest](3*forests.length)
    for (f <- forests) {
      next += Forest(f.goats - 1, f.wolves - 1, f.lions + 1)
      next += Forest(f.goats - 1, f.wolves + 1, f.lions - 1)
      next += Forest(f.goats + 1, f.wolves - 1, f.lions - 1)
    }
    next.filter(Forest.isValid).distinct.toArray
  }
  def solve(f: Forest): Array[Forest] = {
    var forests = Array(f)
    while (!forests.isEmpty && !forests.exists(Forest.isStable)) {
      forests = mutate(forests)
    }
    forests.filter(Forest.isStable)
  }

  def main(args: Array[String]) {
    val initial = Forest(args(0).toInt, args(1).toInt, args(2).toInt)
    println("Initial: " + initial)
    solve(initial).foreach { s => println("Solution: " + s) }
  }
}
