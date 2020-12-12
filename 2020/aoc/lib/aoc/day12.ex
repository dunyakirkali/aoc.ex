defmodule Aoc.Day12 do
  @doc """
      iex> inp = Aoc.Day12.input("priv/day12/example.txt")
      ...> Aoc.Day12.part1(inp)
      25
  """
  def part1(inp) do
    {{x, y}, _} =
      inp
      |> Enum.map(fn x ->
        [ac | am] =
          x
          |> String.graphemes()

        {ac, String.to_integer(Enum.join(am))}
      end)
      |> Enum.reduce({{0, 0}, "E"}, fn {ac, am}, {{x, y}, dir} ->
        case ac do
          "N" ->
            {{x, y - am}, dir}

          "S" ->
            {{x, y + am}, dir}

          "E" ->
            {{x + am, y}, dir}

          "W" ->
            {{x - am, y}, dir}

          "L" ->
            case am do
              90 ->
                case dir do
                  "N" ->
                    {{x, y}, "W"}

                  "S" ->
                    {{x, y}, "E"}

                  "E" ->
                    {{x, y}, "N"}

                  "W" ->
                    {{x, y}, "S"}
                end

              180 ->
                case dir do
                  "N" ->
                    {{x, y}, "S"}

                  "S" ->
                    {{x, y}, "N"}

                  "E" ->
                    {{x, y}, "W"}

                  "W" ->
                    {{x, y}, "E"}
                end

              270 ->
                case dir do
                  "N" ->
                    {{x, y}, "E"}

                  "S" ->
                    {{x, y}, "W"}

                  "E" ->
                    {{x, y}, "S"}

                  "W" ->
                    {{x, y}, "N"}
                end
            end

          "R" ->
            case am do
              90 ->
                case dir do
                  "N" ->
                    {{x, y}, "E"}

                  "S" ->
                    {{x, y}, "W"}

                  "E" ->
                    {{x, y}, "S"}

                  "W" ->
                    {{x, y}, "N"}
                end

              180 ->
                case dir do
                  "N" ->
                    {{x, y}, "S"}

                  "S" ->
                    {{x, y}, "N"}

                  "E" ->
                    {{x, y}, "W"}

                  "W" ->
                    {{x, y}, "E"}
                end

              270 ->
                case dir do
                  "N" ->
                    {{x, y}, "W"}

                  "S" ->
                    {{x, y}, "E"}

                  "E" ->
                    {{x, y}, "N"}

                  "W" ->
                    {{x, y}, "S"}
                end
            end

          "F" ->
            case dir do
              "N" ->
                {{x, y - am}, dir}

              "S" ->
                {{x, y + am}, dir}

              "E" ->
                {{x + am, y}, dir}

              "W" ->
                {{x - am, y}, dir}
            end
        end
      end)

    start = %Aoc.Point{x: 0, y: 0}
    dest = %Aoc.Point{x: x, y: y}

    Aoc.Point.manhattan(start, dest)
  end

  @doc """
      iex> inp = Aoc.Day12.input("priv/day12/example.txt")
      ...> Aoc.Day12.part2(inp)
      286
  """
  def part2(inp) do
    {{x, y}, _} =
      inp
      |> Enum.map(fn x ->
        [ac | am] =
          x
          |> String.graphemes()

        {ac, String.to_integer(Enum.join(am))}
      end)
      |> Enum.reduce({{0, 0}, {10, -1}}, fn {ac, am}, {{x, y}, {wx, wy}} ->
        case ac do
          "N" ->
            {{x, y}, {wx, wy - am}}

          "S" ->
            {{x, y}, {wx, wy + am}}

          "E" ->
            {{x, y}, {wx + am, wy}}

          "W" ->
            {{x, y}, {wx - am, wy}}

          "L" ->
            case am do
              90 ->
                # {10, -1} => {-1, -10}
                {{x, y}, {wy, wx * -1}}

              180 ->
                # {10, -1} => {-10, 1}
                {{x, y}, {wx * -1, wy * -1}}

              270 ->
                # {10, -1} => {1, 10}
                {{x, y}, {wy * -1, wx}}
            end

          "R" ->
            case am do
              90 ->
                # {10, -1} => {1, 10}
                {{x, y}, {wy * -1, wx}}

              180 ->
                # {10, -1} => {-10, 1}
                {{x, y}, {wx * -1, wy * -1}}

              270 ->
                # {10, -1} => {-1, -10}
                {{x, y}, {wy, wx * -1}}
            end

          "F" ->
            {{x + wx * am, y + wy * am}, {wx, wy}}
        end
      end)

    start = %Aoc.Point{x: 0, y: 0}
    dest = %Aoc.Point{x: x, y: y}

    Aoc.Point.manhattan(start, dest)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
