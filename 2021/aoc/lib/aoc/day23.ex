defmodule Aoc.Day23 do
  @pieces [:a, :b, :c, :d]
  @hallway for x <- 0..10, do: {x, 0}
  @room_xs 2..8//2
  @hallway_spots Enum.reject(@hallway, fn {x, _} -> x in @room_xs end)

  @doc """
      iex> start_state = Aoc.Day23.input("priv/day23/example.txt")
      ...> end_state = Aoc.Day23.input("priv/day23/final1.txt")
      ...> Aoc.Day23.part1(start_state, end_state)
      12521
  """
  def part1(start_state, end_state) do
    solve(start_state, end_state)
  end

  def part2(start_state, end_state) do
    solve(start_state, end_state)
  end

  def solve(start_state, end_state) do
    zobrist = zobristify(start_state)
    u_state = statify(zobrist, start_state)
    distances = %{u_state => 0}
    queue = PriorityQueue.new() |> PriorityQueue.push(start_state, 0)
    a_star({queue, distances, zobrist, end_state})
  end

  def a_star({queue, distances, zobrist, end_state}) do
    {{:value, u}, queue} = PriorityQueue.pop(queue)
    u_state = statify(zobrist, u)
    current_cost = distances[u_state]

    if u == end_state do
      current_cost
    else
      u
      |> valid_moves()
      |> Enum.map(&{move(u, &1), current_cost + cost(&1)})
      |> Enum.reduce({queue, distances, zobrist, end_state}, &a_star_grade_state/2)
      |> a_star()
    end
  end

  def a_star_grade_state({new_state, cost}, {queue, distances, zobrist, end_state}) do
    v_state = statify(zobrist, new_state)
    if not Map.has_key?(distances, v_state) or cost < distances[v_state] do
      h_score = cost + heuristic(new_state)
      queue = PriorityQueue.push(queue, new_state, h_score)
      {queue, Map.put(distances, v_state, cost), zobrist, end_state}
    else
      {queue, distances, zobrist, end_state}
    end
  end

  def move({state, max_y}, {{x_from, y_from}, {x_to, y_to}, p}) do
    state
    |> Map.put({x_from, y_from}, nil)
    |> Map.put({x_to, y_to}, p)
    |> then(&{&1, max_y})
  end

  def valid_moves(state = {map, _}) do
    {hallway_pods, room_pods} =
      map
      |> Enum.reject(fn {_, v} -> is_nil(v) end)
      |> Enum.reject(&in_final_position?(state, &1))
      |> Enum.split_with(&in_hallway?/1)

    Enum.concat(
      Enum.map(hallway_pods, fn {c, p} -> {c, final_pos(state, p), p} end),
      Enum.flat_map(room_pods, fn {c, p} -> Enum.map(@hallway_spots, &{c, &1, p}) end)
    )
    |> Enum.filter(&has_path?(state, &1))
  end

  def cost({from, to, :a}), do: moves(from, to)
  def cost({from, to, :b}), do: moves(from, to) * 10
  def cost({from, to, :c}), do: moves(from, to) * 100
  def cost({from, to, :d}), do: moves(from, to) * 1000

  def has_path?(state, {start, stop, _}), do: path(state, start, stop) |> Enum.all?(&is_nil/1)

  def final_pos({state, max_y}, p), do: {x(p), Enum.find(max_y..1, &(state[{x(p), &1}] != p))}

  def in_final_position?(_, {{_, 0}, _}), do: false
  def in_final_position?({state, max_y}, {{x, y}, pod}) do
    x(pod) == x and Enum.all?(y..max_y, &(state[{x, &1}] == pod))
  end

  def in_hallway?({{_, y}, _}), do: y == 0

  def path({state, _}, {x_from, y_from}, {x_to, y_to}) do
    Enum.concat(
      for(x <- x_from..x_to, do: {x, 0}),
      for(y <- y_from..y_to, do: {if(y_from > y_to, do: x_from, else: x_to), y})
    )
    |> List.delete({x_from, y_from})
    |> Enum.map(&state[&1])
  end

  def x(:a), do: 2
  def x(:b), do: 4
  def x(:c), do: 6
  def x(:d), do: 8

  def moves({x_from, y_from}, {x_to, y_to}), do: abs(x_from - x_to) + abs(y_from - y_to)

  def statify(zobrist, {map, _}) do
    piece_positions = Enum.filter(map, fn {_, char} -> Enum.member?(@pieces, char) end)
    Aoc.Zobrist.hash(zobrist, piece_positions)
  end

  def zobristify({map, _}) do
    for {pos, char} <- map do
      pos
    end
    |> Aoc.Zobrist.table(@pieces)
  end

  def heuristic({map, _}) do
    for {{x, _}, char} <- map,
        Enum.member?(@pieces, char) do
      case char do
        :a -> abs(x - 3) * 1
        :b -> abs(x - 5) * 10
        :c -> abs(x - 7) * 100
        :d -> abs(x - 9) * 1000
      end
    end
    |> Enum.sum
  end

  def input(filename) do
    filename
    |> File.read!()
    |> parse
  end

  def parse(str) do
    ~r/..#([[:upper:]])#([[:upper:]])#([[:upper:]])#([[:upper:]])#/
    |> Regex.scan(str, capture: :all_but_first)
    |> Enum.with_index(1)
    |> Enum.flat_map(fn {line, y} ->
      line
      |> Enum.map(&String.downcase/1)
      |> Enum.map(&String.to_atom/1)
      |> Enum.zip(@room_xs)
      |> Enum.map(fn {p, x} -> {{x, y}, p} end)
    end)
    |> Enum.concat(Enum.map(@hallway, &{&1, nil}))
    |> Map.new()
    |> then(fn s -> {s, s |> Map.keys() |> Enum.map(&elem(&1, 1)) |> Enum.max()} end)
  end
end
