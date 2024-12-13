defmodule Aoc.Day13 do
  @doc """
      iex> "priv/day13/example.txt" |> Aoc.Day13.input() |> Aoc.Day13.part1()
      480
  """
  def part1(machines) do
    machines
    |> Enum.map(fn machine ->
      solve(machine)
    end)
    |> Enum.sum()
  end

  # https://en.wikipedia.org/wiki/Cramer%27s_rule
  def solve(%{a: {ax, ay}, b: {bx, by}, p: {px, py}}) do
    d = ax * by - ay * bx

    if d == 0 do
      0
    else
      m = div(px * by - py * bx, d)

      if m * d != px * by - py * bx do
        0
      else
        n = div(py - ay * m, by)

        if n * by != py - ay * m do
          0
        else
          3 * m + n
        end
      end
    end
  end

  def part2(machines) do
    machines
    |> Enum.map(fn machine ->
      machine
      |> Map.get_and_update!(:p, fn {x, y} -> {{x, y}, {x + 10000000000000, y + 10000000000000}} end)
      |> then(fn {_, nm} ->
        solve(nm)
      end)
    end)
    |> Enum.sum()
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn group ->
      [a, b, p] =
        group
        |> String.split("\n", trim: true)

      %{"x" => ax, "y" => ay} = Regex.named_captures(~r/.*X\+(?<x>\d+), Y\+(?<y>\d+)/, a)
      %{"x" => bx, "y" => by} = Regex.named_captures(~r/.*X\+(?<x>\d+), Y\+(?<y>\d+)/, b)
      %{"x" => px, "y" => py} = Regex.named_captures(~r/.*X=(?<x>\d+), Y=(?<y>\d+)/, p)

      %{
        :a => {String.to_integer(ax), String.to_integer(ay)},
        :b => {String.to_integer(bx), String.to_integer(by)},
        :p => {String.to_integer(px), String.to_integer(py)}
      }
    end)
  end
end
