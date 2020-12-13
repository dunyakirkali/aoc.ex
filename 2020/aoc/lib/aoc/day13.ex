defmodule Aoc.Day13 do
  @doc """
      iex> inp = Aoc.Day13.input("priv/day13/example.txt")
      ...> Aoc.Day13.part1(inp)
      295
  """
  def part1([ear, minutes]) do
    {id, earliest} =
      minutes
      |> String.split(",", trim: true)
      |> Enum.reject(fn x ->
        x == "x"
      end)
      |> Enum.map(fn x ->
        {x, gop(String.to_integer(x), String.to_integer(x), String.to_integer(ear))}
      end)
      |> Enum.min_by(fn {_id, time} ->
        time
      end)

    String.to_integer(id) * (earliest - String.to_integer(ear))
  end

  def gop(tim, step, goal) do
    if tim >= goal do
      tim
    else
      gop(tim + step, step, goal)
    end
  end

  @doc """
      iex> inp = Aoc.Day13.input("priv/day13/example.txt")
      ...> Aoc.Day13.part2(inp)
      1068781

      iex> Aoc.Day13.part2([0, "17,x,13,19"])
      3417

      iex> Aoc.Day13.part2([0, "67,7,59,61"])
      754018

      iex> Aoc.Day13.part2([0, "67,x,7,59,61"])
      779210

      iex> Aoc.Day13.part2([0, "67,7,x,59,61"])
      1261476

      iex> Aoc.Day13.part2([0, "1789,37,47,1889"])
      1_202_161_486
  """
  def part2([_ear, minutes]) do
    maps =
      minutes
      |> String.split(",", trim: true)
      |> Stream.map(fn x ->
        if x == "x" do
          x
        else
          String.to_integer(x)
        end
      end)
      |> Stream.with_index()
      |> Stream.filter(fn {id, _md} ->
        id != "x"
      end)
      |> Enum.to_list

    mods = Enum.map(maps, fn {id, _rem} ->
      id
    end)

    rems = Enum.map(maps, fn {id, rem} ->
      id - rem
    end)

    Aoc.Chinese.remainder(mods, rems)
    |> Enum.at(0)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
