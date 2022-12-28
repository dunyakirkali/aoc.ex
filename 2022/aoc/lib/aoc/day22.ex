defmodule Aoc.Day22 do
  defmodule Cube do
    defstruct [:sides, :dimension]

    def ranges(4) do
      [
        {8..11, 0..3},
        {0..3, 4..7},
        {4..7, 4..7},
        {8..11, 4..7},
        {8..11, 8..11},
        {12..15, 8..11}
      ]
    end

    def ranges(50) do
      [
        {50..99, 0..49},
        {100..149, 0..49},
        {50..99, 50..99},
        {0..49, 100..149},
        {50..99, 100..149},
        {0..49, 150..199}
      ]
    end

    def size(side), do: Nx.shape(side) |> elem(0)

    def side(cube, side, rotation) do
      cube
      |> Map.get(side)
      |> point_to(rotation)
    end

    def draw(side, {c, r}) do
      size = Aoc.Day22.Cube.size(side)

      side
      |> Nx.to_flat_list()
      |> Enum.chunk_every(size)
      |> Enum.with_index()
      |> Enum.map(fn {line, index} ->
        (if index == r, do: List.replace_at(line, c, ?*), else: line)
        |> List.to_string()
        |> IO.puts
      end)
    end

    defp point_to(side, :n), do: side

    defp point_to(side, :s),
      do:
        side
        |> Nx.transpose()
        |> Nx.reverse(axes: [:y])
        |> Nx.transpose()
        |> Nx.reverse(axes: [:x])

    defp point_to(side, :e), do: side |> Nx.transpose() |> Nx.reverse(axes: [:x])
    defp point_to(side, :w), do: side |> Nx.transpose() |> Nx.reverse(axes: [:y])

    def rotate_to({1, :n}, :n), do: {6, :w}
    def rotate_to({1, :n}, :s), do: {3, :n}
    def rotate_to({1, :n}, :e), do: {2, :n}
    def rotate_to({1, :n}, :w), do: {4, :s}
    def rotate_to({1, :s}, :n), do: {3, :s}
    def rotate_to({1, :s}, :s), do: {6, :e}
    def rotate_to({1, :s}, :e), do: {4, :n}
    def rotate_to({1, :s}, :w), do: {2, :s}
    def rotate_to({1, :e}, :n), do: {4, :w}
    def rotate_to({1, :e}, :s), do: {2, :e}
    def rotate_to({1, :e}, :e), do: {6, :n}
    def rotate_to({1, :e}, :w), do: {3, :e}
    def rotate_to({1, :w}, :n), do: {2, :w}
    def rotate_to({1, :w}, :s), do: {4, :e}
    def rotate_to({1, :w}, :e), do: {3, :w}
    def rotate_to({1, :w}, :w), do: {6, :s}

    def rotate_to({2, :n}, :n), do: {6, :n}
    def rotate_to({2, :n}, :s), do: {3, :w}
    def rotate_to({2, :n}, :e), do: {5, :s}
    def rotate_to({2, :n}, :w), do: {1, :n}
    def rotate_to({2, :s}, :n), do: {3, :e}
    def rotate_to({2, :s}, :s), do: {6, :s}
    def rotate_to({2, :s}, :e), do: {1, :s}
    def rotate_to({2, :s}, :w), do: {5, :n}
    def rotate_to({2, :e}, :n), do: {1, :e}
    def rotate_to({2, :e}, :s), do: {5, :w}
    def rotate_to({2, :e}, :e), do: {6, :e}
    def rotate_to({2, :e}, :w), do: {3, :n}
    def rotate_to({2, :w}, :n), do: {5, :e}
    def rotate_to({2, :w}, :s), do: {1, :w}
    def rotate_to({2, :w}, :e), do: {3, :s}
    def rotate_to({2, :w}, :w), do: {6, :w}

    def rotate_to({3, :n}, :n), do: {1, :n}
    def rotate_to({3, :n}, :s), do: {5, :n}
    def rotate_to({3, :n}, :e), do: {2, :e}
    def rotate_to({3, :n}, :w), do: {4, :e}
    def rotate_to({3, :s}, :n), do: {5, :s}
    def rotate_to({3, :s}, :s), do: {1, :s}
    def rotate_to({3, :s}, :e), do: {4, :w}
    def rotate_to({3, :s}, :w), do: {2, :w}
    def rotate_to({3, :e}, :n), do: {4, :s}
    def rotate_to({3, :e}, :s), do: {2, :s}
    def rotate_to({3, :e}, :e), do: {1, :e}
    def rotate_to({3, :e}, :w), do: {5, :e}
    def rotate_to({3, :w}, :n), do: {2, :n}
    def rotate_to({3, :w}, :s), do: {4, :n}
    def rotate_to({3, :w}, :e), do: {5, :w}
    def rotate_to({3, :w}, :w), do: {1, :w}

    def rotate_to({4, :n}, :n), do: {3, :w}
    def rotate_to({4, :n}, :s), do: {6, :n}
    def rotate_to({4, :n}, :e), do: {5, :n}
    def rotate_to({4, :n}, :w), do: {1, :s}
    def rotate_to({4, :s}, :n), do: {6, :s}
    def rotate_to({4, :s}, :s), do: {3, :e}
    def rotate_to({4, :s}, :e), do: {1, :n}
    def rotate_to({4, :s}, :w), do: {5, :s}
    def rotate_to({4, :e}, :n), do: {1, :w}
    def rotate_to({4, :e}, :s), do: {5, :e}
    def rotate_to({4, :e}, :e), do: {3, :n}
    def rotate_to({4, :e}, :w), do: {6, :e}
    def rotate_to({4, :w}, :n), do: {5, :w}
    def rotate_to({4, :w}, :s), do: {1, :e}
    def rotate_to({4, :w}, :e), do: {6, :w}
    def rotate_to({4, :w}, :w), do: {3, :s}

    def rotate_to({5, :n}, :n), do: {3, :n}
    def rotate_to({5, :n}, :s), do: {6, :w}
    def rotate_to({5, :n}, :e), do: {2, :s}
    def rotate_to({5, :n}, :w), do: {4, :n}
    def rotate_to({5, :s}, :n), do: {6, :e}
    def rotate_to({5, :s}, :s), do: {3, :s}
    def rotate_to({5, :s}, :e), do: {4, :s}
    def rotate_to({5, :s}, :w), do: {2, :n}
    def rotate_to({5, :e}, :n), do: {4, :e}
    def rotate_to({5, :e}, :s), do: {2, :w}
    def rotate_to({5, :e}, :e), do: {3, :e}
    def rotate_to({5, :e}, :w), do: {6, :n}
    def rotate_to({5, :w}, :n), do: {2, :e}
    def rotate_to({5, :w}, :s), do: {4, :w}
    def rotate_to({5, :w}, :e), do: {6, :s}
    def rotate_to({5, :w}, :w), do: {3, :w}

    def rotate_to({6, :n}, :n), do: {4, :n}
    def rotate_to({6, :n}, :s), do: {2, :n}
    def rotate_to({6, :n}, :e), do: {5, :e}
    def rotate_to({6, :n}, :w), do: {1, :e}
    def rotate_to({6, :s}, :n), do: {2, :s}
    def rotate_to({6, :s}, :s), do: {4, :s}
    def rotate_to({6, :s}, :e), do: {1, :w}
    def rotate_to({6, :s}, :w), do: {5, :w}
    def rotate_to({6, :e}, :n), do: {1, :s}
    def rotate_to({6, :e}, :s), do: {5, :s}
    def rotate_to({6, :e}, :e), do: {4, :e}
    def rotate_to({6, :e}, :w), do: {2, :e}
    def rotate_to({6, :w}, :n), do: {5, :n}
    def rotate_to({6, :w}, :s), do: {1, :n}
    def rotate_to({6, :w}, :e), do: {2, :w}
    def rotate_to({6, :w}, :w), do: {4, :w}

    def new(filename) do
      chart =
        filename
        |> File.read!()
        |> String.split("\n\n", trim: true)
        |> List.first()
        |> Aoc.Chart.new()

      non_empty = Enum.filter(chart, fn {_, val} -> val != " " end) |> Enum.count() |> IO.inspect()
      side_length = trunc(:math.sqrt(non_empty / 6))

      sides =
        side_length
        |> ranges()
        |> Enum.with_index()
        |> Enum.map(fn {{c_ran, r_ran}, index} ->
          tensor =
            for(r <- r_ran, c <- c_ran, do: {c, r})
            |> Enum.map(fn {c, r} ->
              Map.get(chart, {c, r})
              |> String.to_charlist()
              |> Enum.at(0)
            end)
            |> Enum.chunk_every(side_length)
            |> Nx.tensor(names: [:x, :y])

          {index + 1, tensor}
        end)
        |> Enum.into(%{})

      %Aoc.Day22.Cube{sides: sides, dimension: side_length}
    end
  end

  @doc """
      iex> "priv/day22/example.txt" |> Aoc.Day22.part2()
      5031
  """
  def part2(filename) do
    cube = Aoc.Day22.Cube.new(filename)
    moves = moves(filename)

    {side, rotation, position, direction} = step(cube.sides, {1, :n}, moves, {{0, 0}, :e})
    # |> IO.inspect()
    score(cube, side, rotation, position, direction)
  end

  def score(cube, side, _, {c, r}, direction) do
    ranges = Aoc.Day22.Cube.ranges(cube.dimension)
    {cols, rows} = Enum.at(ranges, side - 1)
    coffset = cols |> Enum.at(0)
    roffset = rows |> Enum.at(0)

    ((50 - r) + roffset) * 1000 + ((50 - c) + coffset) * 4 + dir_score(direction)
  end

  def dir_score(:e), do: 2

  defp turn(:n, :l), do: :w
  defp turn(:n, :r), do: :e
  defp turn(:s, :l), do: :e
  defp turn(:s, :r), do: :w
  defp turn(:e, :l), do: :n
  defp turn(:e, :r), do: :s
  defp turn(:w, :l), do: :s
  defp turn(:w, :r), do: :n

  defp step(_, {side, rotation}, [], {position, direction}), do: {side, rotation, position, direction}

  defp step(cube, {side, rotation}, [h | t], {position, direction}) when is_integer(h) do
    {{side, rotation}, position} = move(cube, {side, rotation}, {position, direction}, h)
    step(cube, {side, rotation}, t, {position, direction})
  end

  defp step(cube, {side, rotation}, [h | t], {position, direction}) when is_atom(h) do
    direction = turn(direction, h)# |> IO.inspect(label: "rotation")
    step(cube, {side, rotation}, t, {position, direction})
  end

  defp move(_, {side, rotation}, {position, _}, 0), do: {{side, rotation}, position}

  defp move(cube, {side, rotation}, {{c, r}, direction}, n) do
    size = Aoc.Day22.Cube.size(Map.get(cube, 1))

    {nsid, nrot, {nc, nr}} =
      case direction do
        :n ->
          if r == 0 do
            Tuple.append(Aoc.Day22.Cube.rotate_to({side, rotation}, direction), {c, size - 1})
          else
            {side, rotation, {c, r - 1}}
          end
        :s ->
          if r == size - 1 do
            Tuple.append(Aoc.Day22.Cube.rotate_to({side, rotation}, direction), {c, 0})
          else
            {side, rotation, {c, r + 1}}
          end
        :e ->
          if c == size - 1 do
            Tuple.append(Aoc.Day22.Cube.rotate_to({side, rotation}, direction), {0, r})
          else
            {side, rotation, {c + 1, r}}
          end
        :w ->
          if c == 0 do
            Tuple.append(Aoc.Day22.Cube.rotate_to({side, rotation}, direction), {size - 1, r})
          else
            {side, rotation, {c - 1, r}}
          end
      end
      # |> IO.inspect(label: "movement")

    # {side, rotation} |> IO.inspect()
    visible_side = Aoc.Day22.Cube.side(cube, nsid, nrot)

    if Nx.to_number(visible_side[nr][nc]) == 46 do
      # Aoc.Day22.Cube.draw(visible_side, {nc, nr})
      move(cube, {nsid, nrot}, {{nc, nr}, direction}, n - 1)
    else
      # visible_side = Aoc.Day22.Cube.side(cube, side, rotation)
      # Aoc.Day22.Cube.draw(visible_side, {c, r})
      move(cube, {side, rotation}, {{c, r}, direction}, n - 1)
    end
  end

  defp moves(filename) do
    move_data =
      filename
      |> File.read!()
      |> String.split("\n\n", trim: true)
      |> List.last()

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
  end
end
