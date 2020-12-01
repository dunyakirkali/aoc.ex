defmodule Aoc do
  defmodule Point do
    defstruct x: 0, y: 0, z: 0

    @doc """
        iex> from = %Aoc.Point{x: -3, y: 5, z: -4}
        ...> to = %Aoc.Point{x: 2, y: -2, z: 3}
        ...> Aoc.Point.manhattan(from, to)
        19

        iex> from = %Aoc.Point{x: -3, y: 5}
        ...> to = %Aoc.Point{x: 2, y: -2}
        ...> Aoc.Point.manhattan(from, to)
        12
    """
    def manhattan(from, to) do
      abs(from.x - to.x) + abs(from.y - to.y) + abs(from.z - to.z)
    end
  end
end
