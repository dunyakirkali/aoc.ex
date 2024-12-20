defmodule Aoc.Day20 do
  use Memoize

  @doc """
      iex> "priv/day20/example.txt" |> Aoc.Day20.input() |> Aoc.Day20.part1()
      0
  """
  def part1(input = {_start, _desti, map}) do
    # Pre-calculate graph once
    graph = to_graph(map)

    map
    |> Map.filter(fn {_, char} -> char == "#" end)
    |> Enum.map(fn {pos, _} ->
      cheat_neighbours(input, pos, graph)
    end)
    |> Enum.frequencies()
    |> Enum.filter(fn {k, _} -> k >= 100 end)
    |> Enum.map(fn {_, v} -> v end)
    |> Enum.sum()
  end

  @doc """
      iex> "priv/day20/example.txt" |> Aoc.Day20.input() |> Aoc.Day20.sanity({1, 3}, {5, 7})
      76

      iex> "priv/day20/example.txt" |> Aoc.Day20.input() |> Aoc.Day20.sanity({1, 3}, {5, 7})
      76
  """
  def sanity({_, _, map}, {x, y}, {dx, dy}) do
    graph = to_graph(map)

    roads =
      map
      |> Enum.filter(fn {_, char} -> char == "." end)
      |> Map.new()

    roads
    |> Enum.filter(fn {{nx, ny}, _} ->
      dist = manhattan_distance(x, y, nx, ny)
      dist < 20 and dist > 1
    end)
    |> Enum.map(fn {pos, _} ->
      path_length =
        graph
        |> Graph.dijkstra({x, y}, pos)
        |> Enum.count()

      diff = path_length - manhattan_distance(x, y, elem(pos, 0), elem(pos, 1)) - 1
      {{x, y}, {elem(pos, 0), elem(pos, 1)}, diff}
    end)
    |> Enum.find(fn {_, {tx, ty}, _} -> tx == dx and ty == dy end)
    |> elem(2)
  end

  defmemo path_to(graph, fpos, tpos) do
    graph
    |> Graph.dijkstra(fpos, tpos)
    |> Enum.count()
    |> Kernel.-(1)
  end

  @doc """
      iex> "priv/day20/example.txt" |> Aoc.Day20.input() |> Aoc.Day20.part2()
      0
  """
  def part2({_, _, map}) do
    graph = to_graph(map)

    roads =
      map
      |> Enum.filter(fn {_, char} -> char == "." end)
      |> Map.new()

    roads
    |> Map.keys()
    |> Task.async_stream(
      fn {x, y} ->
        roads
        |> Enum.filter(fn {{nx, ny}, _} ->
          dist = manhattan_distance(x, y, nx, ny)
          dist < 20 and dist > 1
        end)
        |> Enum.map(fn {pos, _} ->
          path_length = path_to(graph, {x, y}, pos)
          diff = path_length - manhattan_distance(x, y, elem(pos, 0), elem(pos, 1))
          {diff, 1}
        end)
      end,
      ordered: false,
      timeout: :timer.hours(2),
      max_concurrency: 8
    )
    |> Stream.flat_map(fn {:ok, results} -> results end)
    |> Enum.reduce(%{}, fn {k, v}, acc ->
      Map.update(acc, k, v, &(&1 + v))
    end)
    |> Stream.filter(fn {k, _} -> k >= 100 end)
    |> Stream.map(fn {_, v} -> v end)
    |> Enum.sum()
  end

  defmemo manhattan_distance(x1, y1, x2, y2) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  # @doc """
  #     iex> "priv/day20/example.txt" |> Aoc.Day20.input() |> Aoc.Day20.cheat_neighbours({8, 1})
  #     12

  #     iex> "priv/day20/example.txt" |> Aoc.Day20.input() |> Aoc.Day20.cheat_neighbours({10, 7})
  #     20
  # """
  def cheat_neighbours({_, _, map}, pos, graph) do
    case pos
         |> neighbors()
         |> Enum.filter(fn npos -> Map.get(map, npos, "#") == "." end)
         |> then(fn ns -> {List.first(ns), List.last(ns)} end) do
      {s, e} when not is_nil(s) and not is_nil(e) ->
        case Graph.dijkstra(graph, s, e) do
          nil -> 0
          path -> length(path) - 3
        end

      _ ->
        0
    end
  end

  def cheat(map, pos) do
    map
    |> Map.put(pos, ".")
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
