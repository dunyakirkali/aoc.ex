defmodule Day11Test do
  use ExUnit.Case
  doctest Day11

  test "Example 1" do
    grid = for x <- Enum.to_list(2..299), y <- Enum.to_list(2..299), do: %{x: x, y: y}
    result =
      grid
      |> Enum.map(fn cell ->
        total_power =
          cell
          |> Day11.neighbours()
          |> Enum.map(fn neighbour ->
            Day11.adjusted_power_level(neighbour, 18)
          end)
          |> Enum.sum

        %{coords: {cell[:x] - 1, cell[:y] - 1}, power: total_power}
      end)
      |> Enum.sort_by(fn %{coords: _, power: power} ->
        power
      end)
      |> List.last

    assert result[:coords] == {33, 45}
  end

  test "Coordinate of the top-left fuel cell of the 3x3 square with the largest total power" do
    grid = for x <- Enum.to_list(2..299), y <- Enum.to_list(2..299), do: %{x: x, y: y}
    result =
      grid
      |> Enum.map(fn cell ->
        total_power =
          cell
          |> Day11.neighbours()
          |> Enum.map(fn neighbour ->
            Day11.adjusted_power_level(neighbour, 4151)
          end)
          |> Enum.sum

        %{coords: {cell[:x] - 1, cell[:y] - 1}, power: total_power}
      end)
      |> Enum.sort_by(fn %{coords: _, power: power} ->
        power
      end)
      |> List.last

    assert result[:coords] == {20, 46}
  end
end
