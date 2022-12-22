defmodule Aoc.Day22 do
  def input(filename) do
    [map_data, move_data] =
      filename
      |> File.read!()
      |> String.split("\n\n", trim: true)

    moves =
      ~r/(\d+|\w)/
      |> Regex.scan(move_data)
      |> Enum.map(fn [el, _] -> el end)
      |> Enum.map(fn i ->
        case Integer.parse(i) do
          :error ->
            case i do
              "R" -> :r
              "L" -> :l
            end
          {n, _} -> n
        end
      end)

    {
      Aoc.Chart.new(map_data),
      moves
    }
  end

  @doc """
      iex> "priv/day22/example.txt" |> Aoc.Day22.input() |> Aoc.Day22.part1()
      6032
  """
  def part1({chart, moves}) do
    start = Aoc.Chart.start(chart)
    # Aoc.Chart.draw(chart)
    solve(chart, start, :e, moves)
    |> then(fn {{c, r}, direction} ->
      facing =
        case direction do
          :n -> 3
          :s -> 1
          :e -> 0
          :w -> 2
        end
      4 * (c + 1) + 1000 * (r + 1) + facing
    end)
  end

  def solve(_, position, direction, []), do: {position, direction}
  def solve(chart, position, direction, [hm|tm]) do
    {chart, position, direction} =
      cond do
        is_integer(hm) -> move(chart, position, direction, hm)
        is_atom(hm) -> {chart, position, turn(direction, hm)}
      end
    solve(chart, position, direction, tm)
  end

  def turn(:n, :l), do: :w
  def turn(:n, :r), do: :e
  def turn(:s, :l), do: :e
  def turn(:s, :r), do: :w
  def turn(:e, :l), do: :n
  def turn(:e, :r), do: :s
  def turn(:w, :l), do: :s
  def turn(:w, :r), do: :n

  def move(chart, position, direction, 0), do: {chart, position, direction}
  def move(chart, position, direction, n) do
    next = scout(chart, position, direction)
    move(chart, next, direction, n - 1)
  end

  def scout(chart, {c, r}, direction) do
    {nc, nr} =
      case direction do
        :n ->
          cols = Aoc.Chart.cols(chart, c)
          off = Enum.map(cols, fn {{_, r}, _} -> r end) |> Enum.min()

          nr = if r - off == 0, do: Enum.count(cols) + off - 1, else: r - 1
          {c, nr}
        :s ->
          cols = Aoc.Chart.cols(chart, c)
          off = Enum.map(cols, fn {{_, r}, _} -> r end) |> Enum.min()

          nr = rem(r - off + 1, Enum.count(cols)) + off
          {c, nr}
        :e ->
          rows = Aoc.Chart.rows(chart, r)
          off = Enum.map(rows, fn {{c, _}, _} -> c end) |> Enum.min()

          nc = rem(c - off + 1, Enum.count(rows)) + off
          {nc, r}
        :w ->
          rows = Aoc.Chart.rows(chart, r)
          off = Enum.map(rows, fn {{c, _}, _} -> c end) |> Enum.min()

          nc = if c - off == 0, do: Enum.count(rows) + off - 1, else: c - 1
          {nc, r}
      end

    if Map.get(chart, {nc, nr}, ".") == ".", do: {nc, nr}, else: {c, r}
  end

  # @doc """
  #     iex> "priv/day22/example.txt" |> Aoc.Day22.input() |> Aoc.Day22.part2()
  #     0
  # """
  # def part2(numbers) do
  # end
end
