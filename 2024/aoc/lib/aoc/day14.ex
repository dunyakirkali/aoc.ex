defmodule Aoc.Day14 do
  @doc """
      iex> "priv/day14/example.txt" |> Aoc.Day14.input() |> Aoc.Day14.part1("example.txt")
      12
  """
  def part1(map, filename) do
    map =
      map
      |> step(0, filename)

    tlq =
      Enum.filter(map, fn {{x, y}, _} ->
        x < div(elem(size(filename), 0), 2) && y < div(elem(size(filename), 1), 2)
      end)

    trq =
      Enum.filter(map, fn {{x, y}, _} ->
        x > div(elem(size(filename), 0), 2) && y < div(elem(size(filename), 1), 2)
      end)

    blq =
      Enum.filter(map, fn {{x, y}, _} ->
        x < div(elem(size(filename), 0), 2) && y > div(elem(size(filename), 1), 2)
      end)

    brq =
      Enum.filter(map, fn {{x, y}, _} ->
        x > div(elem(size(filename), 0), 2) && y > div(elem(size(filename), 1), 2)
      end)

    [tlq, trq, blq, brq]
    |> Enum.map(fn bots -> Enum.count(bots) end)
    |> safety_factor()
  end

  def step(list, 100, _), do: list

  def step(list, count, filename) do
    list
    |> Enum.map(fn {{x, y}, {vx, vy}} ->
      {rr({x + vx, y + vy}, filename), {vx, vy}}
    end)
    |> step(count + 1, filename)
  end

  def rr({x, y}, filename) do
    {sx, sy} = size(filename)
    {rem(x + sx, sx), rem(y + sy, sy)}
  end

  @doc """
      iex> Aoc.Day14.size("input.txt")
      {101, 103}

      iex> Aoc.Day14.size("example.txt")
      {11, 7}
  """
  def size(filename) do
    case filename do
      "example.txt" -> {11, 7}
      "input.txt" -> {101, 103}
    end
  end

  def draw(list, filename) do
    {sx, sy} = size(filename)
    IO.puts("\n")

    pps = Enum.map(list, fn {{x, y}, _} -> {x, y} end)

    Enum.each(0..sy, fn y ->
      Enum.map(0..sx, fn x ->
        if Enum.member?(pps, {x, y}) do
          "#"
        else
          " "
        end
      end)
      |> Enum.join("")
      |> IO.puts()
    end)

    IO.puts("\n")
    list
  end

  @doc """
      iex> [1, 3, 4, 1] |> Aoc.Day14.safety_factor()
      12
  """
  def safety_factor(list) do
    list
    |> Enum.reduce(1, fn num, acc ->
      acc * num
    end)
  end

  def part2(map) do
    step2(map, 0, 0)
  end

  def step2(list, count, found) do
    ps = Enum.map(list, fn {{x, y}, _} -> {x, y} end)
    all_unique = MapSet.size(MapSet.new(ps)) == length(ps)

    if all_unique and found == 1 do
      draw(list, "input.txt")
      count
    else
      list
      |> Enum.map(fn {{x, y}, {vx, vy}} ->
        {rr({x + vx, y + vy}, "input.txt"), {vx, vy}}
      end)
      |> step2(count + 1, if(all_unique, do: found + 1, else: found))
    end
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      %{"px" => px, "py" => py, "vx" => vx, "vy" => vy} =
        Regex.named_captures(~r/p=(?<px>\d+),(?<py>\d+) v=(?<vx>-?\d+),(?<vy>-?\d+)/, line)

      {{String.to_integer(px), String.to_integer(py)},
       {String.to_integer(vx), String.to_integer(vy)}}
    end)
  end
end
