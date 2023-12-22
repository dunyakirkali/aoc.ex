defmodule Aoc.Day22 do
  @doc """
      iex> "priv/day22/example.txt" |> Aoc.Day22.input() |> Aoc.Day22.part1()
      5
  """
  def part1(map) do
    bricks =
      map
      |> Enum.sort(fn {[_, _, lfpz], [_, _, _]}, {[_, _, rfpz], [_, _, _]} ->
        lfpz < rfpz
      end)

    # |> IO.inspect(label: "sorted bricks")

    bricks =
      bricks
      |> Enum.with_index()
      |> Enum.reduce(bricks, fn {{[fpx, fpy, fpz], [tpx, tpy, tpz]} = brick, index}, acc ->
        max_z =
          acc
          |> Enum.slice(0, index)
          # |> IO.inspect(label: "slice")
          |> Enum.reduce(1, fn {_, [_, _, zz]} = check, accc ->
            if overlaps?(brick, check) do
              max(accc, zz + 1)
            else
              accc
            end
          end)

        # |> IO.inspect(label: "max_z")

        List.replace_at(acc, index, {[fpx, fpy, max_z], [tpx, tpy, tpz - (fpz - max_z)]})
      end)
      |> Enum.sort(fn {[_, _, lfpz], [_, _, _]}, {[_, _, rfpz], [_, _, _]} ->
        lfpz < rfpz
      end)

    # |> IO.inspect(label: "fallen bricks")

    k_supports_v = for i <- 1..Enum.count(bricks), into: %{}, do: {i - 1, MapSet.new()}
    v_supports_k = for i <- 1..Enum.count(bricks), into: %{}, do: {i - 1, MapSet.new()}

    {k_supports_v, v_supports_k} =
      bricks
      |> Enum.with_index()
      |> Enum.reduce({k_supports_v, v_supports_k}, fn {{[_, _, u2], _} = upper, j}, {kv, vk} ->
        bricks
        |> Enum.slice(0, j)
        |> Enum.with_index()
        |> Enum.reduce({kv, vk}, fn {{_, [_, _, l5]} = lower, i}, {kvv, vkk} ->
          if overlaps?(lower, upper) and u2 == l5 + 1 do
            {
              Map.put(kvv, i, MapSet.put(Map.get(kvv, i), j)),
              Map.put(vkk, j, MapSet.put(Map.get(vkk, j), i))
            }
          else
            {kvv, vkk}
          end
        end)
      end)

    # |> IO.inspect()

    0..(Enum.count(bricks) - 1)
    |> Enum.reduce(0, fn i, total ->
      if Enum.all?(Map.get(k_supports_v, i), fn j ->
           Enum.count(Map.get(v_supports_k, j)) >= 2
         end) do
        total + 1
      else
        total
      end
    end)
  end

  def overlaps?({[lfpx, lfpy, _], [ltpx, ltpy, _]}, {[rfpx, rfpy, _], [rtpx, rtpy, _]}) do
    max(lfpx, rfpx) <= min(ltpx, rtpx) and max(lfpy, rfpy) <= min(ltpy, rtpy)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [c1, c2] =
        line
        |> String.split("~", trim: true)

      {
        String.split(c1, ",", trim: true)
        |> Enum.map(&String.to_integer/1),
        String.split(c2, ",", trim: true)
        |> Enum.map(&String.to_integer/1)
      }
    end)
  end
end
