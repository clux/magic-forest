#!/usr/bin/env julia
struct Forest
  goats::Int32
  wolves::Int32
  lions::Int32
end

function is_stable(x::Forest)::Bool
  x.goats == 0 && (x.lions == 0 || x.wolves == 0) || (x.lions == 0 && x.wolves == 0)
end

function is_valid(x::Forest)::Bool
  x.goats >= 0 && x.lions >= 0 && x.wolves >= 0
end

function mutate(forests)
  next = []
  for f ∈ forests
    push!(next, Forest(f.goats - 1, f.wolves - 1, f.lions + 1))
    push!(next, Forest(f.goats - 1, f.wolves + 1, f.lions - 1))
    push!(next, Forest(f.goats + 1, f.wolves - 1, f.lions - 1))
  end
  unique(filter(is_valid, next))
end

function solve(x::Forest)
  forests = [x]
  while !isempty(forests) && !any(is_stable, forests)
     forests = mutate(forests)
  end
  filter(is_stable, forests)
end

initial = Forest(map(x->parse(Int32, x), ARGS)...)
println("Initial: $initial")
[println("Solution: $s") for s in solve(initial)]
