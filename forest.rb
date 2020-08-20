#!/usr/bin/env ruby
class Forest
  include Comparable

  attr_accessor :goats
  attr_accessor :wolves
  attr_accessor :lions

  def initialize(goats, wolves, lions)
    @goats = goats
    @wolves = wolves
    @lions = lions
  end

  def <=>(rhs)
    to_h <=> rhs.to_h
  end

  def to_h
    @forest ||= {
      goats: @goats,
      lions: @lions,
      wolves: @wolves
    }
  end

  def to_s
    "#{goats} #{wolves} #{lions}"
  end

  def is_stable
    (@goats == 0 && (@wolves == 0 || @lions == 0)) || (@wolves == 0 && @lions == 0)
  end

  def is_valid
    @goats >= 0 && @wolves >= 0 && @lions >= 0
  end
end

def mutate(forests)
  xs = []
  for f in forests do
    xs.push(Forest.new(f.goats - 1, f.wolves - 1, f.lions + 1))
    xs.push(Forest.new(f.goats - 1, f.wolves + 1, f.lions - 1))
    xs.push(Forest.new(f.goats + 1, f.wolves - 1, f.lions - 1))
  end
  ys = xs.keep_if {|f| f.is_valid }
  ys.uniq {|f| f.to_h }
end

def solve(forest)
  forests = [forest]
  while forests.any? && forests.none? {|f| f.is_stable } do
    forests = mutate(forests)
  end
  forests.keep_if {|f| f.is_stable }
end

if __FILE__ == $0
  if ARGV.length != 3
    puts "Usage: #{$0} <goats> <wolves> <lions>"
    exit 1
  end

  initial = Forest.new(ARGV[0].to_i, ARGV[1].to_i, ARGV[2].to_i)
  puts "Initial: #{initial}"

  for s in solve(initial) do
    puts "Solution: #{s}"
  end
end
