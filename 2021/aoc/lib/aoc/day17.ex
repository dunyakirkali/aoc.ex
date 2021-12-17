defmodule Aoc.Day17 do
  @doc """
      iex> input = Aoc.Day17.input("priv/day17/example.txt")
      ...> Aoc.Day17.part1(input)
      45
  """
  def part1(input) do
    input
    |> compute_all_hits()
    |> Enum.map(&elem(&1, 1))
    |> Enum.max()
  end

  defp compute_all_hits(target = {_, tx2, ty1, _}) do
    for ex <- 1..tx2,
        ey <- ty1..(abs(ty1) - 1),
        velocity = {ex, ey},
        {state, max_y} = step({0, 0}, velocity, 0, target),
        state == :hit,
        do: {velocity, max_y}
  end

  defp step({x, y}, _, max_y, {tx1, tx2, ty1, ty2}) when x in tx1..tx2 and y in ty1..ty2,
    do: {:hit, max_y}

  defp step({x, y}, _, _, {_, tx2, ty1, _}) when x > tx2 or y < ty1, do: {:miss, -1}

  defp step({x, y}, {vx, vy}, max_y, target) do
    x = x + vx
    y = y + vy
    v = {vx + drag(vx), vy - 1}
    step({x, y}, v, max(max_y, y), target)
  end

  defp drag(vx) when vx > 0, do: -1
  defp drag(vx) when vx < 0, do: 1
  defp drag(_), do: 0

  @doc """
      # iex> input = Aoc.Day17.input("priv/day17/example.txt")
      # ...> Aoc.Day17.part1(input)
      # 112
  """
  def part2(input) do
    input
    |> compute_all_hits()
    |> Enum.map(&elem(&1, 1))
    |> Enum.count()
  end

  def input(filename) do
    <<"target area: ", rest::binary>> =
      filename
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.at(0)

    rest
    |> String.split(", ")
    |> Enum.map(fn line ->
      [_, range_s] =
        line
        |> String.split("=")

      String.split(range_s, "..")
    end)
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end
end
