defmodule Aoc.Day22 do
  defmodule Cube do
    def new(filename) do
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

            {n, _} ->
              n
          end
        end)

      chart = Aoc.Chart.new(map_data)

      one =
        for(c <- 50..99, r <- 0..49, do: {c, r})
        |> Enum.map(fn {c, r} ->
          Map.get(chart, {c, r})
          |> String.to_charlist()
          |> Enum.at(0)
        end)
        |> Enum.chunk_every(50)
        |> Nx.tensor(names: [:x, :y])

      two =
        for(c <- 100..149, r <- 0..49, do: {c, r})
        |> Enum.map(fn {c, r} ->
          Map.get(chart, {c, r})
          |> String.to_charlist()
          |> Enum.at(0)
        end)
        |> Enum.chunk_every(50)
        |> Nx.tensor(names: [:x, :y])

      three =
        for(c <- 50..99, r <- 50..99, do: {c, r})
        |> Enum.map(fn {c, r} ->
          Map.get(chart, {c, r})
          |> String.to_charlist()
          |> Enum.at(0)
        end)
        |> Enum.chunk_every(50)
        |> Nx.tensor(names: [:x, :y])

      four =
        for(c <- 0..49, r <- 100..149, do: {c, r})
        |> Enum.map(fn {c, r} ->
          Map.get(chart, {c, r})
          |> String.to_charlist()
          |> Enum.at(0)
        end)
        |> Enum.chunk_every(50)
        |> Nx.tensor(names: [:x, :y])

      five =
        for(c <- 50..99, r <- 100..149, do: {c, r})
        |> Enum.map(fn {c, r} ->
          Map.get(chart, {c, r})
          |> String.to_charlist()
          |> Enum.at(0)
        end)
        |> Enum.chunk_every(50)
        |> Nx.tensor(names: [:x, :y])

      six =
        for(c <- 0..49, r <- 150..199, do: {c, r})
        |> Enum.map(fn {c, r} ->
          Map.get(chart, {c, r})
          |> String.to_charlist()
          |> Enum.at(0)
        end)
        |> Enum.chunk_every(50)
        |> Nx.tensor(names: [:x, :y])

      {
        %{
          1 => one,
          2 => two,
          3 => three,
          4 => four,
          5 => five,
          6 => six
        },
        {1, :n},
        moves
      }
    end

    def point_to(side, :n), do: side

    def point_to(side, :s),
      do:
        side
        |> Nx.transpose()
        |> Nx.reverse(axes: [:y])
        |> Nx.transpose()
        |> Nx.reverse(axes: [:x])

    def point_to(side, :e), do: side |> Nx.transpose() |> Nx.reverse(axes: [:x])
    def point_to(side, :w), do: side |> Nx.transpose() |> Nx.reverse(axes: [:y])

    def rotate_to(sides, side, direction) do
      case side do
        1 ->
          case direction do
            :n -> {sides, {6, :w}}
            :s -> {sides, {3, :s}}
            :e -> {sides, {4, :w}}
            :w -> {sides, {2, :w}}
          end

        2 ->
          case direction do
            :n -> {sides, {6, :n}}
            :s -> {sides, {3, :e}}
            :e -> {sides, {1, :e}}
            :w -> {sides, {5, :e}}
          end

        3 ->
          case direction do
            :n -> {sides, {1, :n}}
            :s -> {sides, {5, :s}}
            :e -> {sides, {4, :s}}
            :w -> {sides, {2, :n}}
          end

        4 ->
          case direction do
            :n -> {sides, {3, :w}}
            :s -> {sides, {6, :s}}
            :e -> {sides, {1, :w}}
            :w -> {sides, {5, :w}}
          end

        5 ->
          case direction do
            :n -> {sides, {3, :n}}
            :s -> {sides, {6, :e}}
            :e -> {sides, {4, :e}}
            :w -> {sides, {2, :e}}
          end

        6 ->
          case direction do
            :n -> {sides, {4, :n}}
            :s -> {sides, {2, :s}}
            :e -> {sides, {1, :s}}
            :w -> {sides, {5, :n}}
          end
      end
    end
  end

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

          {n, _} ->
            n
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

  def solve(chart, position, direction, [hm | tm]) do
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

  def part2(filename) do
    filename
    |> Cube.new()
    |> solve2({0, 0}, :e)
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

  def solve2({sides, {side, _}, []}, position, direction), do: {position, direction}

  def solve2({sides, {side, rotation}, [hm | tm]}, position, direction) do
    {{sides, {side, rotation}, tm}, position, direction} =
      cond do
        is_integer(hm) ->
          IO.puts("move #{hm}")
          move2({{sides, {side, rotation}, tm}, position, direction}, hm)

        is_atom(hm) ->
          IO.puts("turn #{direction}")
          {{sides, {side, rotation}, tm}, position, turn(direction, hm)}
      end

    solve2({sides, {side, rotation}, tm}, position, direction)
  end

  def move2({{sides, {side, rotation}, tm}, position, direction}, 0) do
    {{sides, {side, rotation}, tm}, position, direction}
  end

  def move2({{sides, {side, rotation}, tm}, position, direction}, step) do
    next = scout2({{sides, {side, rotation}, tm}, position, direction})
    move2(next, step - 1)
  end

  def scout2({{sides, {side, rotation}, tm}, {c, r}, direction}) do
    {{sides, {side, rotation}, tm}, {nc, nr}, direction} =
      case direction do
        :n ->
          if r == 0 do
            {_, {si, ri}} = Cube.rotate_to(sides, side, :n)

            {{sides, {si, ri}, tm}, {c, 49}, direction}
          else
            {{sides, {side, rotation}, tm}, {c, r - 1}, direction}
          end

        :s ->
          if r == 49 do
            {_, {si, ri}} = Cube.rotate_to(sides, side, :s)

            {{sides, {si, ri}, tm}, {c, 0}, direction}
          else
            {{sides, {side, rotation}, tm}, {c, r + 1}, direction}
          end

        :e ->
          if c == 49 do
            {_, {si, ri}} = Cube.rotate_to(sides, side, :e)

            {{sides, {si, ri}, tm}, {0, r}, direction}
          else
            {{sides, {side, rotation}, tm}, {c + 1, r}, direction}
          end

        :w ->
          if c == 0 do
            {_, {si, ri}} = Cube.rotate_to(sides, side, :w)

            {{sides, {si, ri}, tm}, {49, r}, direction}
          else
            {{sides, {side, rotation}, tm}, {c - 1, r}, direction}
          end
      end

    value =
      Cube.point_to(Map.get(sides, side), rotation)[nc][nr]
      |> Nx.to_number()

    if value == 46 do
      {{sides, {side, rotation}, tm}, {nc, nr}, direction}
    else
      {{sides, {side, rotation}, tm}, {c, r}, direction}
    end
  end
end
