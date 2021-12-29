defmodule Aoc.Day23 do
  @hall [{1,1},{2,1},{4,1},{6,1},{8,1},{10,1},{11,1}]
  @pieces [?A, ?B, ?C, ?D]
  @costs %{
    ?A => 1,
    ?B => 10,
    ?C => 100,
    ?D => 1000
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

  def part2(start_state, end_state) do
    zobrist = zobristify(start_state)
    shortest(start_state, end_state, zobrist)
  end

  def x(?A), do: 3
  def x(?B), do: 5
  def x(?C), do: 7
  def x(?D), do: 9

  def in_final_position?(_, {{_, 1}, _}, _), do: false
  def in_final_position?(map, {{x, y}, char}) do
    x(char) == x and Enum.all?(y..6, &(map[{x, &1}] == char))
  end

  def print(map) do
    IO.puts("")

    Enum.map(0..6, fn row ->
      Enum.map(0..12, fn col ->
        pos = {col, row}
        Map.get(map, pos, ?#)
      end)
      |> to_string
    end)
    |> Enum.join("\n")
    |> IO.puts()

    map
  end

  def possible_moves(map) do
    # map |> print
    {hallway_pods, room_pods} =
      map
      |> Enum.filter(fn {_, char} ->
        Enum.member?(@pieces, char)
      end)
      |> Enum.reject(&in_final_position?(map, &1))
      |> Enum.split_with(fn {pos, _} ->
        Enum.member?(@hall, pos)
      end)

    Enum.concat(
      Enum.map(hallway_pods, fn {from, char} ->
        dest_x = x(char)
        dest_y = Enum.find(6..2, fn yy ->
          Map.get(map, {dest_x, yy}) == ?.
        end)
        if dest_y == nil do
          nil
        else
          to = {dest_x, dest_y}
          {from, to}
        end
      end)
      |> Enum.filter(fn x ->
        x != nil
      end),
      Enum.flat_map(room_pods, fn {pos, _} ->
        Enum.map(@hall, fn to ->
          {pos, to}
        end)
      end)
    )
    # |> IO.inspect(label: "BEF")
    |> Enum.filter(&has_path?(map, &1))
    # |> IO.inspect(label: "AFT")
  end

  @doc """
      iex> start_state = Aoc.Day23.input("priv/day23/example.txt")
      ...> Aoc.Day23.has_path?(start_state, {{9, 2}, {1, 1}})
      true
  """
  def has_path?(map, {from, to}), do: path(map, from, to) |> Enum.all?(fn ch -> ch == ?. end)

  def path(map, {x_from, y_from}, {x_to, y_to}) do
    Enum.concat(
      for(x <- x_from..x_to, do: {x, 1}),
      for(y <- y_from..y_to, do: {if(y_from > y_to, do: x_from, else: x_to), y})
    )
    |> List.delete({x_from, y_from})
    |> Enum.map(&map[&1])
  end

  def statify(zobrist, map) do
    piece_positions = Enum.filter(map, fn {_, char} -> Enum.member?(@pieces, char) end)
    Aoc.Zobrist.hash(zobrist, piece_positions)
  end

  def zobristify(map) do
    for {pos, char} <- map,
        char != ?#,
        char != ?\s do
      pos
    end
    |> Aoc.Zobrist.table(@pieces)
  end

  def move(map, from, to) do
    fc = Map.get(map, from)

    map
    |> Map.put(from, ?.)
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

  def heuristic(map) do
    for {{x, _}, char} <- map,
        Enum.member?(@pieces, char) do
      case char do
        ?A -> abs(x - 3) * @costs[?A]
        ?B -> abs(x - 5) * @costs[?B]
        ?C -> abs(x - 7) * @costs[?C]
        ?D -> abs(x - 9) * @costs[?D]
      end
    end
    |> Enum.sum
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
          heuristic = heuristic(v)
          distance_from_source = distances[u_state] + cost

          if distance_from_source < Map.get(distances, v_state, :infinity) do
            distances = Map.put(distances, v_state, distance_from_source)
            queue = PriorityQueue.push(queue, v, distance_from_source + heuristic)

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
      |> String.to_charlist()
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {char, x}, acc ->
        if char != ?# and char != ?\s do
          Map.put(acc, {x, y}, char)
        else
          acc
        end
      end)
    end)
  end
end
