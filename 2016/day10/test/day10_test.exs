defmodule Day10Test do
  use ExUnit.Case
  # doctest Day10

  test "part 1" do
    input = 'priv/input.txt' |> File.read! |> String.split("\n", trim: true)

    assert Day10.part_1(input, {17, 61}) == 86
  end

  test "part 2" do
    input = 'priv/input.txt' |> File.read! |> String.split("\n", trim: true)
    mul =
      Day10.part_2(input, {17, 61})
      |> Enum.filter(fn {k, v} ->
        k == -100 or k == -99 or k == -98
      end)
      |> Enum.map(fn {k, v} ->
        List.first(v.values)
      end)
      |> Enum.reduce(1, fn x, acc -> x * acc end)

    assert mul == 22847
  end
end
