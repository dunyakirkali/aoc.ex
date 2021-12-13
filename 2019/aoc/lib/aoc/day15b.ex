defmodule Aoc.Day15 do
  import Drawille.Canvas

  defmodule Droid do
    defstruct [pos: %{x: 500, y: 500}]
  end

  def part1() do
    map = %{{500, 500} => "."}
    droid = %Droid{}
    machine =
      AGC.new("priv/day15/input.txt")
      |> AGC.run

    # rs(droid, map, machine, 1)
    search(droid, map, machine)
  end

  def generate_dir(map, droid, thres) do
    new_dir = Enum.random(1..4)
    lo =
      case new_dir do
        1 -> {droid.pos.x, droid.pos.y - 1}
        2 -> {droid.pos.x, droid.pos.y + 1}
        3 -> {droid.pos.x - 1, droid.pos.y}
        4 -> {droid.pos.x + 1, droid.pos.y}
      end
    loc = Map.get(map, lo)

    if loc == nil or thres > 100
    do
      new_dir
    else
      generate_dir(map, droid, thres + 1)
    end
  end

  def rs(droid, map, machine, dir) do
    machine =
      machine
      |> Map.put(:inputs, [dir])
      |> AGC.run

    res =
      machine.output
      |> List.last()
      |> status()

    {map, droid} = set(droid, map, direction(dir), res)
    print(droid, map)
    %{x: x, y: y} = droid.pos
    if res == :goal do
      {true, map, droid}
    else
      # if Map.get(map, {x, y}) != nil do
      #   {false, map, droid}
      # else
        {rres, map, droid} = rs(droid, map, machine, 4)
        if rres == true do
          {true, map, droid}
        end

        {rres, map, droid} = rs(droid, map, machine, 3)
        if rres == true do
          {true, map, droid}
        end

        {rres, map, droid} = rs(droid, map, machine, 2)
        if rres == true do
          {true, map, droid}
        end

        {rres, map, droid} = rs(droid, map, machine, 1)
        if rres == true do
          {true, map, droid}
        end
      # end
    end

    {false, map, droid}
  end

  def search(droid, map, machine) do
    dir = generate_dir(map, droid, 0)
    machine =
      machine
      |> Map.put(:inputs, [dir])
      |> AGC.run

    res =
      machine.output
      |> List.last()
      |> status()

    {map, droid} = set(droid, map, direction(dir), res)

    print(droid, map)

    if res == 2 do
      map

      graph =
        map
        |> Enum.filter(fn {pos, tile} ->
          tile == "." or tile == "G"
        end)
        |> Enum.reduce(:digraph.new(), fn {pos, tile}, acc ->
          :digraph.add_vertex(acc, pos)

          if Enum.member?(map, {pos.x-1, pos.y}) do
            :digraph.add_edge(acc, {pos.x-1, pos.y}, pos)
            :digraph.add_edge(acc, pos, {pos.x-1, pos.y})
          end

          if Enum.member?(map, {pos.x+1, pos.y}) do
            :digraph.add_edge(acc, {pos.x+1, pos.y}, pos)
            :digraph.add_edge(acc, pos, {pos.x+1, pos.y})
          end

          if Enum.member?(map, {pos.x, pos.y-1}) do
            :digraph.add_edge(acc, {pos.x, pos.y-1}, pos)
            :digraph.add_edge(acc, pos, {pos.x, pos.y-1})
          end

          if Enum.member?(map, {pos.x, pos.y+1}) do
            :digraph.add_edge(acc, {pos.x, pos.y+1}, pos)
            :digraph.add_edge(acc, pos, {pos.x, pos.y+1})
          end

          acc
        end)

      {goal, _} = Enum.find(map, fn {{x, y}, tile} ->
        tile == "G"
      end)

      IO.inspect(Enum.count(:digraph.get_short_path(graph, {500, 500}, goal)) - 3)

    else
      search(droid, map, machine)
    end
  end

  defp print(droid, map) do
    %{x: x, y: y} = droid.pos
    map
    |> Enum.reduce(new(), fn {{x, y}, tile}, acc_canvas ->
      acc_canvas =
        case tile do
          "G" -> set(acc_canvas, x + 1, y + 1)
          "#" -> set(acc_canvas, x + 1, y + 1)
          "." -> unset(acc_canvas, x + 1, y + 1)
        end
      acc_canvas
    end)
    |> set(x + 1, y + 1)
    |> frame()
  end

  defp set(droid, map, dir, :goal) do
    %{x: x, y: y} = droid.pos
    map =
      case dir do
        :north -> Map.put(map, {x, y - 1}, "G")
        :south -> Map.put(map, {x, y + 1}, "G")
        :west -> Map.put(map, {x - 1, y}, "G")
        :east -> Map.put(map, {x + 1, y}, "G")
      end
    droid =
      case dir do
        :north -> %Droid{droid | pos: %{x: x, y: y - 1}}
        :south -> %Droid{droid | pos: %{x: x, y: y + 1}}
        :west -> %Droid{droid | pos: %{x: x - 1, y: y}}
        :east -> %Droid{droid | pos: %{x: x + 1, y: y}}
      end
    {map, droid}
  end
  defp set(droid, map, dir, :wall) do
    %{x: x, y: y} = droid.pos
    map =
      case dir do
        :north -> Map.put(map, {x, y - 1}, "#")
        :south -> Map.put(map, {x, y + 1}, "#")
        :west -> Map.put(map, {x - 1, y}, "#")
        :east -> Map.put(map, {x + 1, y}, "#")
      end
    {map, droid}
  end
  defp set(droid, map, dir, :ok) do
    %{x: x, y: y} = droid.pos
    map =
      case dir do
        :north -> Map.put(map, {x, y - 1}, ".")
        :south -> Map.put(map, {x, y + 1}, ".")
        :west -> Map.put(map, {x - 1, y}, ".")
        :east -> Map.put(map, {x + 1, y}, ".")
      end
    droid =
      case dir do
        :north -> %Droid{droid | pos: %{x: x, y: y - 1}}
        :south -> %Droid{droid | pos: %{x: x, y: y + 1}}
        :west -> %Droid{droid | pos: %{x: x - 1, y: y}}
        :east -> %Droid{droid | pos: %{x: x + 1, y: y}}
      end
    {map, droid}
  end

  def part2() do

  end

  defp direction(code) do
    case code do
      1 -> :north
      2 -> :south
      3 -> :west
      4 -> :east
    end
  end

  defp status(code) do
    case code do
      0 -> :wall
      1 -> :ok
      2 -> :goal
    end
  end
end
