defmodule Aoc.Day16 do
  use Memoize

  @doc """
      iex> "priv/day16/example.txt" |> Aoc.Day16.input() |> Aoc.Day16.part1()
      7036

      iex> "priv/day16/example2.txt" |> Aoc.Day16.input() |> Aoc.Day16.part1()
      11048
  """
  def part1({start, desti, map}) do
    map
    |> to_graph()
    |> find_all_paths(start, desti, :infinity)
    |> Stream.map(fn path -> score(path, :infinity) end)
    |> Enum.min()
  end

  def find_all_paths(graph, start, target, best_score) do
    Stream.resource(
      fn -> {[[start]], best_score} end,
      fn
        {[], _} ->
          {:halt, []}

        {[current_path | rest], best_score} ->
          current_node = hd(current_path)
          path = Enum.reverse(current_path)
          current_score = score(path, best_score)

          if current_score <= best_score do
            cond do
              current_node == target ->
                if current_score <= best_score do
                  {[path], {rest, current_score}}
                else
                  {[], {rest, best_score}}
                end

              true ->
                neighbors =
                  graph
                  |> Graph.out_neighbors(current_node)
                  |> Enum.reject(&(&1 in current_path))

                new_paths =
                  neighbors
                  |> Enum.map(&[&1 | current_path])

                {[], {rest ++ new_paths, best_score}}
            end
          else
            {[], {rest, best_score}}
          end
      end,
      fn _ -> :ok end
    )
  end

  def score([_], best_score), do: best_score

  defmemo score(path, _) do
    path
    |> Stream.chunk_every(2, 1, :discard)
    |> Stream.transform({:right, 0}, fn
      [{fx, fy}, {tx, ty}], {prev_dir, score} ->
        new_dir =
          case {tx - fx, ty - fy} do
            {1, 0} -> :right
            {-1, 0} -> :left
            {0, 1} -> :down
            {0, -1} -> :up
          end

        new_score = if(prev_dir == new_dir, do: score + 1, else: score + 1001)
        {[new_score], {new_dir, new_score}}
    end)
    |> Enum.at(-1)
  end

  @doc """
      iex> "priv/day16/example.txt" |> Aoc.Day16.input() |> Aoc.Day16.part2()
      45

      iex> "priv/day16/example2.txt" |> Aoc.Day16.input() |> Aoc.Day16.part2()
      64
  """
  def part2({start, desti, map}) do
    best_score = part1({start, desti, map})

    map
    |> to_graph()
    |> find_all_paths(start, desti, best_score)
    |> Enum.map(fn path -> MapSet.new(path) end)
    |> Enum.reduce(MapSet.new(), fn path, acc ->
      MapSet.union(path, acc)
    end)
    |> MapSet.size()
  end

  def to_graph(map) do
    map
    |> Enum.reduce(Graph.new(type: :directed), fn {pos, char}, g ->
      if char == "." do
        pos
        |> neighbors()
        |> Enum.filter(fn np ->
          Map.get(map, np, "#") == "."
        end)
        |> Enum.reduce(Graph.add_vertex(g, pos), fn npos, gg ->
          gg
          |> Graph.add_edge(pos, npos)
          |> Graph.add_edge(npos, pos)
        end)
      else
        g
      end
    end)
  end

  def neighbors({x, y}) do
    [
      {x + 1, y},
      {x, y + 1},
      {x - 1, y},
      {x, y - 1}
    ]
  end

  def input(filename) do
    map =
      filename
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, y} ->
        line
        |> String.split("", trim: true)
        |> Enum.with_index()
        |> Enum.map(fn {char, x} ->
          {{x, y}, char}
        end)
      end)
      |> Enum.into(%{})

    {start, _} = Enum.find(map, fn {_, char} -> char == "S" end)
    {desti, _} = Enum.find(map, fn {_, char} -> char == "E" end)

    {start, desti, map |> Map.put(start, ".") |> Map.put(desti, ".")}
  end
end
