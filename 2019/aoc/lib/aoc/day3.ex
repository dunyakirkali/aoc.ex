defmodule Aoc.Day3 do
  @doc """
      iex> Aoc.Day3.part1("priv/day3/sample1.txt")
      159

      iex> Aoc.Day3.part1("priv/day3/sample2.txt")
      135

      # iex> Aoc.Day3.part1("priv/day3/sample3.txt")
      # 6
  """
  def part1(filename) do
    routes =
      filename
      |> input()
      |> Enum.map(fn path ->
        follow(path)
      end)
      |> Enum.map(fn routes ->
        routes
        |> Enum.reduce(MapSet.new(), fn loc, acc ->
          acc |> MapSet.put(loc)
        end)
      end)

    MapSet.intersection(Enum.at(routes, 0), Enum.at(routes, 1))
    |> Enum.map(fn loc ->
      man_distance(%{x: 1000, y: 1000}, loc)
    end)
    |> Enum.filter(fn dist ->
      dist != 0
    end)
    |> Enum.sort
    |> List.first
  end

  @doc """
      iex> Aoc.Day3.part2("priv/day3/sample1.txt")
      610

      iex> Aoc.Day3.part2("priv/day3/sample2.txt")
      410

      iex> Aoc.Day3.part2("priv/day3/sample3.txt")
      30
  """
  def part2(filename) do
    routes =
      filename
      |> input()
      |> Enum.map(fn path ->
        follow(path)
      end)

    route1 = Enum.at(routes, 0)
    route2 = Enum.at(routes, 1)

    route1
    |> Enum.filter(fn pos ->
      Enum.member?(route2, pos)
    end)
    |> pmap(fn loc ->
      steps1 =
        route1
        |> Enum.find_index(fn x -> x == loc end)

      steps2 =
        route2
        |> Enum.find_index(fn x -> x == loc end)

      {steps1, steps2}
    end)
    |> Enum.filter(fn {a, b} ->
      a != 0 and b != 0
    end)
    |> IO.inspect
    |> Enum.map(fn {a, b} ->
      a + b
    end)
    |> Enum.sort
    |> List.first
  end

  def pmap(collection, func) do
    collection
    |> Enum.map(&(Task.async(fn -> func.(&1) end)))
    |> Enum.map(&Task.await/1)
  end

  def follow(path) do
    path
    |> Enum.reduce([%{x: 1000, y: 1000}], fn movement, locations ->
      %{x: x, y: y} = List.last(locations)
      {_, amount} = String.split_at(movement, 1)
      amount = String.to_integer(amount)

      route =
        cond do
          String.starts_with?(movement, "U") ->
            for n <- (y - 1)..(y - amount), do: %{x: x, y: n}
          String.starts_with?(movement, "D") ->
            for n <- (y + 1)..(y + amount), do: %{x: x, y: n}
          String.starts_with?(movement, "R") ->
            for n <- (x + 1)..(x + amount), do: %{x: n, y: y}
          String.starts_with?(movement, "L") ->
            for n <- (x - 1)..(x - amount), do: %{x: n, y: y}
        end
      locations ++ route
    end)
  end

  def man_distance(p1, p2) do
    abs(p1.x - p2.x) + abs(p1.y - p2.y)
  end

  defp input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn x ->
      x
      |> String.trim()
      |> String.split(",", trim: true)
    end)
  end
end
