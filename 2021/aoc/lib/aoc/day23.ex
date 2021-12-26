defmodule Aoc.Day23 do
  use Agent

  def start do
    Agent.start_link(fn -> Graph.new end, name: __MODULE__)
    Agent.start_link(fn -> %{} end, name: :states)
  end

  @as [{3, 2}, {3, 3}]
  # @as [{3, 3}]
  @bs [{5, 2}, {5, 3}]
  # @bs [{5, 3}]
  @cs [{7, 2}, {7, 3}]
  @ds [{9, 2}, {9, 3}]
  @hall [{1,1},{2,1},{4,1},{6,1},{8,1},{10,1},{11,1}]
  @pieces ["A", "B", "C", "D"]
  @costs %{
    "A" => 1,
    "B" => 10,
    "C" => 100,
    "D" => 1000
  }
  @doc """
      # iex> start_state = Aoc.Day23.input("priv/day23/test.txt")
      # ...> end_state = Aoc.Day23.input("priv/day23/test_final.txt")
      # ...> Aoc.Day23.part1(start_state, end_state)
      # 68

      iex> start_state = Aoc.Day23.input("priv/day23/example.txt")
      ...> end_state = Aoc.Day23.input("priv/day23/final1.txt")
      ...> Aoc.Day23.part1(start_state, end_state)
      68
  """
  def part1(start_state, end_state) do
    start()
    zobrist = zobristify(start_state)

    initial_state = statify(zobrist, start_state)
    # |> IO.inspect(label: "initial_state")
    Agent.update(__MODULE__, &(Graph.add_vertex(&1, initial_state)))

    final_state = statify(zobrist, end_state)
    # |> IO.inspect(label: "final_state")

    IO.puts("Generating graph...")
    graphify(zobrist, start_state)
    IO.puts("Graph generated.")
    graph = Agent.get(__MODULE__, &(&1))
    states = Agent.get(:states, &(&1))

    # {:ok, file} = File.open("graph.dot", [:write])
    # {:ok, content} = Graph.to_dot(graph)
    # IO.write(file, content)
    # File.write!("./graph.dot", content)
    graph
    |> Graph.dijkstra(initial_state, final_state)
    |> Enum.map(fn node ->
      # IO.inspect(node, label: "node")
      Map.get(states, node) |> print

      node
    end)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [from, to] ->

      Graph.edge(graph, from, to).weight |> IO.inspect(label: "cost")
    end)
    |> Enum.sum()
  end

  @doc """
      iex> input = Aoc.Day23.input("priv/day23/example.txt")
      ...> Aoc.Day23.branch(input, {3, 2})
      [{1, 1}, {2, 1}, {4, 1}, {6, 1}, {8, 1}, {10, 1}, {11, 1}]

      iex> input = Aoc.Day23.input("priv/day23/example2.txt")
      ...> Aoc.Day23.branch(input, {1, 1})
      [{5, 2}]
  """
  def branch(map, {x, y} = pos) do
    all = do_branch(map, pos, [])

    if y == 1 do
      case Map.get(map, pos) do
        "A" ->
          Enum.filter(all, fn p ->
            Enum.member?(@as, p)
          end)
        "B" ->
          Enum.filter(all, fn p ->
            Enum.member?(@bs, p)
          end)
        "C" ->
          Enum.filter(all, fn p ->
            Enum.member?(@cs, p)
          end)
        "D" ->
          Enum.filter(all, fn p ->
            Enum.member?(@ds, p)
          end)
      end
    else
      Enum.filter(all, fn p ->
        Enum.member?(@hall, p)
      end)
    end
  end

  def do_branch(map, pos, acc) do
    if Enum.member?(acc, pos) do
      acc
    else
      pos
      |> neighbors()
      |> Enum.filter(fn np ->
        Map.get(map, np) == "."
      end)
      |> Enum.map(fn np ->
        do_branch(map, np, [pos | acc])
      end)
      |> List.flatten()
      |> Enum.uniq()
    end
  end

  def possible_moves(map) do
    map
    |> Enum.filter(fn {_, char} ->
      Enum.member?(@pieces, char)
    end)
    |> Enum.flat_map(fn {pos, _} ->
      map
      |> branch(pos)
      |> Enum.map(fn np ->
        {pos, np}
      end)
    end)
  end

  def graphify(zobrist, map) do
    graph = Agent.get(__MODULE__, &(&1))
    current_state = statify(zobrist, map)
    vertices = Graph.vertices(graph)

    Agent.update(:states, fn sm ->
      Map.put(sm, current_state, map)
    end)
    map
    |> possible_moves()
    |> Enum.map(fn {from ,to} ->
      cost = cost(map, from, to)
      nm = move(map, from, to)
      next_state = statify(zobrist, nm)

      if Enum.member?(vertices, next_state) do
        Agent.update(__MODULE__, fn graph ->
          graph
          |> Graph.add_edge(current_state, next_state, weight: cost)
        end)
      else

        Agent.update(__MODULE__, fn graph ->
          graph
          |> Graph.add_vertex(next_state)
          |> Graph.add_edge(current_state, next_state, weight: cost)
        end)

        graphify(zobrist, nm)
      end
    end)
  end

  def statify(zobrist, map) do
    piece_positions =
      map
      |> Enum.filter(fn {_, char} ->
        Enum.member?(@pieces, char)
      end)

  end

  def zobristify(map) do
    map
    |> Enum.filter(fn {_, char} ->
      char != "#" and char != " "
    end)
    |> Enum.map(&(elem(&1, 0)))
    |> Aoc.Zobrist.table(@pieces)
  end

  def move(map, from, to) do
    fc = Map.get(map, from)

    map
    |> Map.put(from, ".")
    |> Map.put(to, fc)
  end

  @doc """
      iex> input = Aoc.Day23.input("priv/day23/example.txt")
      ...> Aoc.Day23.cost(input, {3, 2}, {1, 1})
      30

      iex> input = Aoc.Day23.input("priv/day23/example.txt")
      ...> Aoc.Day23.cost(input, {5, 2}, {7, 1})
      300
  """
  def cost(map, {fx, fy} = from, {tx, ty}) do
    cost_per_step = Map.get(@costs, Map.get(map, from))
    cost_per_step * (abs(fx - tx) + abs(fy - ty))
  end

  def print(map) do
    IO.puts("")

    height = Map.keys(map) |> Enum.map(fn {x, _} -> x end) |> Enum.max()
    width = Map.keys(map) |> Enum.map(fn {_, y} -> y end) |> Enum.max()

    Enum.map(0..width, fn row ->
      Enum.map(0..height, fn col ->
        pos = {col, row}
        value = Map.get(map, pos, " ")
        to_string(value)
      end)
      |> Enum.intersperse("")
    end)
    |> Enum.join("\n")
    |> IO.puts()

    map
  end

  def neighbors({x, y}) do
    [
      {x, y - 1},
      {x - 1, y},
      {x + 1, y},
      {x, y + 1}
    ]
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, y}, acc ->
      row
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {char, x}, acc ->
        Map.put(acc, {x, y}, char)
      end)
    end)
  end
end
