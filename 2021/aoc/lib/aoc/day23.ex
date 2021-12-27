defmodule Aoc.Day23 do
  @as [{3, 2}, {3, 3}]
  @bs [{5, 2}, {5, 3}]
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
      iex> start_state = Aoc.Day23.input("priv/day23/example.txt")
      ...> end_state = Aoc.Day23.input("priv/day23/final1.txt")
      ...> Aoc.Day23.part1(start_state, end_state)
      12521
  """
  def part1(start_state, end_state) do
    zobrist = zobristify(start_state)
    shortest(start_state, end_state, zobrist)
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

  def statify(zobrist, map) do
    piece_positions =
      map
      |> Enum.filter(fn {_, char} ->
        Enum.member?(@pieces, char)
      end)
    Aoc.Zobrist.hash(zobrist, piece_positions)
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

  def neighbors({x, y}) do
    [
      {x, y - 1},
      {x - 1, y},
      {x + 1, y},
      {x, y + 1}
    ]
  end

  def shortest(initial_state, final_state, zobrist) do
    u_state = statify(zobrist, initial_state)
    distances = %{u_state => 0}
    queue = PriorityQueue.new() |> PriorityQueue.push(initial_state, 0)
    recur(distances, queue, final_state, zobrist)
  end

  defp recur(distances, queue, target, zobrist) do
    {{:value, u}, queue} = PriorityQueue.pop(queue)
    u_state = statify(zobrist, u)

    if u == target do
      distances[u_state]
    else
      {distances, queue} =
        u
        |> possible_moves()
        |> Enum.reduce({distances, queue}, fn {from ,to}, {distances, queue} ->
          cost = cost(u, from, to)
          v = move(u, from, to)
          v_state = statify(zobrist, v)
          distance_from_source = distances[u_state] + cost

          if distance_from_source < Map.get(distances, v_state, :infinity) do
            distances = Map.put(distances, v_state, distance_from_source)
            queue = PriorityQueue.push(queue, v, distance_from_source)
            {distances, queue}
          else
            {distances, queue}
          end
        end)
      recur(distances, queue, target, zobrist)
    end
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
