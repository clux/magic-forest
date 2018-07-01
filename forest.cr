#!/usr/bin/env crystal

class Forest
  getter goats : Int32
  getter wolves : Int32
  getter lions : Int32
  def_equals_and_hash @goats, @wolves, @lions

  def initialize(goats : Int32, wolves : Int32, lions : Int32)
    @goats = goats
    @wolves = wolves
    @lions = lions
  end

  def is_stable : Bool
    @goats == 0 && (@lions == 0 || @wolves == 0) || (@lions == 0 && @wolves == 0)
  end

  def is_valid : Bool
    @goats >= 0 && @lions >= 0 && @wolves >= 0
  end
end

def mutate(forests : Array(Forest)) : Array(Forest)
  forests.flat_map { |f|
    [
      Forest.new(f.goats - 1, f.wolves - 1, f.lions + 1),
      Forest.new(f.goats - 1, f.wolves + 1, f.lions - 1),
      Forest.new(f.goats + 1, f.wolves - 1, f.lions - 1),
    ]
  }.select(&.is_valid).uniq
end

def solve(f : Forest) : Array(Forest)
  forests = [f]
  until forests.empty? || forests.any? &.is_stable
    forests = mutate(forests)
  end
  forests.select(&.is_stable)
end

initial = Forest.new(ARGV[0].to_i, ARGV[1].to_i, ARGV[2].to_i)
puts "Initial: #{initial.inspect}"
solve(initial).each { |s| puts "Solution: #{s.inspect}" }
