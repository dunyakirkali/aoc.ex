defmodule Aoc.Day16 do
  use Memoize

  @doc """
      # iex> "priv/day16/example.txt" |> Aoc.Day16.input() |> Aoc.Day16.part1()
      # 7036

      iex> "priv/day16/example2.txt" |> Aoc.Day16.input() |> Aoc.Day16.part1()
      11048
  """
  def part1({start, desti, map}) do
    graph = to_graph(map)
    queue = PriorityQueue.new() |> PriorityQueue.push({start, :right, []}, 0)
    visited = MapSet.new([])

    walk(graph, queue, visited, desti, [])
    |> IO.inspect(limit: :infinity)
    |> Enum.map(fn path -> score(path) end)
    |> Enum.min()
  end

  @doc """
      # iex> "priv/day16/example.txt" |> Aoc.Day16.input() |> Aoc.Day16.part2()
      # 45

      # iex> "priv/day16/example2.txt" |> Aoc.Day16.input() |> Aoc.Day16.part2()
      # 64
  """
  def part2({start, desti, map}) do
    graph = to_graph(map)
    queue = PriorityQueue.new() |> PriorityQueue.push({start, :right, []}, 0)
    visited = MapSet.new([])

    paths = walk(graph, queue, visited, desti, [])

    minimum =
      paths
      |> Enum.map(fn path -> score(path) end)
      |> Enum.min()

    paths
    |> then(fn paths ->
      paths
      |> Enum.count()
      |> IO.inspect(label: "Total paths")

      paths
      |> Enum.map(fn path -> score(path) end)
      |> IO.inspect(label: "Path scores")

      paths
    end)
    |> Enum.filter(fn path -> score(path) == minimum end)
    |> Enum.flat_map(fn path ->
      Enum.map(path, fn {cord, _} -> cord end)
    end)
    |> MapSet.new()
    |> MapSet.size()
  end

  def walk(graph, queue, visited, desti, paths) do
    # IO.inspect(visited)

    case PriorityQueue.pop(queue) do
      {{:value, {pos, direction, path}}, queue} ->
        current_path = [{pos, direction} | path]
        path_key = {pos, direction}

        if pos == desti do
          walk(graph, queue, visited, desti, [Enum.reverse(current_path) | paths])
        else
          # if MapSet.member?(visited, path_key) do
          #   walk(graph, queue, visited, desti, paths)
          # else
          visited = MapSet.put(visited, path_key)

          queue =
            graph
            |> Graph.out_neighbors(pos)
            |> Enum.reject(fn npos ->
              MapSet.member?(visited, {npos, direction(pos, npos)})
            end)
            |> Enum.reduce(queue, fn npos, acc ->
              PriorityQueue.push(
                acc,
                {npos, direction(pos, npos), current_path},
                0
              )
            end)

          walk(graph, queue, visited, desti, paths)
          # end
        end

      {:empty, _} ->
        paths
    end
  end

  def direction({fx, fy}, {tx, ty}) do
    case {tx - fx, ty - fy} do
      {1, 0} -> :right
      {-1, 0} -> :left
      {0, 1} -> :down
      {0, -1} -> :up
    end
  end

  defmemo score(path) do
    path
    |> Stream.chunk_every(2, 1, :discard)
    |> Stream.map(fn [{_, fd}, {_, td}] ->
      if fd == td do
        1
      else
        1001
      end
    end)
    |> Enum.sum()
  end

  def to_graph(map) do
    map
    |> Enum.reduce(Graph.new(type: :undirected), fn {pos, char}, g ->
      if char == "." do
        pos
        |> neighbors()
        |> Enum.filter(fn np ->
          Map.get(map, np, "#") == "."
        end)
        |> Enum.reduce(Graph.add_vertex(g, pos), fn npos, gg ->
          gg
          |> Graph.add_edge(pos, npos)

          # |> Graph.add_edge(npos, pos)
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
