case class Forest(val goats: Int, val wolves: Int, val lions: Int)
object Forest {
  import math.Ordering
  implicit def ford: Ordering[Forest] = Ordering.by(f => (f.goats, f.wolves, f.lions))

  def isValid(f: Forest): Boolean = f.goats >= 0 && f.wolves >= 0 && f.lions >= 0
  def isStable(f: Forest): Boolean = {
    (f.goats == 0 && (f.wolves == 0 || f.lions == 0)) || (f.wolves == 0 && f.lions == 0)
  }
}

object Main {
  def mutate(forests: Vector[Forest]) : Vector[Forest] = {
    var next = Vector() //.empty
    //for (f <- forests) {
    //  next
    //}
    next.filter(Forest.isValid)
  }
  def solve(f: Forest): Vector[Forest] = {
    var forests = Vector(f)
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
