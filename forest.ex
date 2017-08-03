#!/usr/bin/env elixir
defmodule Forest do
  defstruct goats: 0, wolves: 0, lions: 0

  def is_stable(%{goats: 0, wolves: 0}), do: true
  def is_stable(%{goats: 0, lions: 0}), do: true
  def is_stable(%{lions: 0, wolves: 0}), do: true
  def is_stable(_), do: false

  def is_valid(f), do: f.goats >= 0 && f.wolves >= 0 && f.lions >= 0

  def mutations(f) do
    [
        %Forest{goats: f.goats-1, wolves: f.wolves-1, lions: f.lions+1 },
        %Forest{goats: f.goats-1, wolves: f.wolves+1, lions: f.lions-1 },
        %Forest{goats: f.goats+1, wolves: f.wolves-1, lions: f.lions-1 }
    ]
  end

  def mutate(xs) do
    Enum.flat_map(xs, &mutations/1) |> Enum.filter(&is_valid/1) |> Enum.uniq()
  end

  def solve(forest) do
    Enum.reduce_while(Stream.cycle([0]), [forest], fn (_, acc) ->
      if !Enum.empty?(acc) && !Enum.any?(acc, &is_stable/1) do
        {:cont, mutate(acc)}
      else
        {:halt, acc}
      end
    end) |> Enum.filter(&is_stable/1)
  end
end

defmodule Script do
  def main(args) do
    initial = case Enum.map(args, &String.to_integer/1) do
      [g, w, l] ->
        %Forest{goats: g , wolves: w, lions: l}
      _ ->
        IO.puts "USAGE: forest <goats> <wolves> <lions>"
        System.halt(1)
    end
    IO.puts "Initial: " <> (inspect initial)

    Enum.each(Forest.solve(initial), fn (s) ->
      IO.puts "Solution: " <> (inspect s)
    end)
  end
end

Script.main(System.argv)
