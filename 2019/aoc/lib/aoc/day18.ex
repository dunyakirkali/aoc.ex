defmodule Aoc.Day18 do
  use Memoize

  @large 1_000_000
  @doc """
      iex> Aoc.Day18.part1("priv/day18/example_1.txt")
      8
      #
      # iex> Aoc.Day18.part1("priv/day18/example_2.txt")
      # 86
      #
      # iex> Aoc.Day18.part1("priv/day18/example_3.txt")
      # 132
      #
      # iex> Aoc.Day18.part1("priv/day18/example_4.txt")
      # 136
      #
      # iex> Aoc.Day18.part1("priv/day18/example_5.txt")
      # 81
  """
  def part1(filename) do
    {:ok, pid} = Agent.start_link(fn -> %{} end)
    Agent.update(pid, &Map.put(&1, :lowest_so_far, @large))
    map =
      filename
      |> input()
      |> Enum.filter(fn {pos, val} ->
        val != "#"
      end)
      |> Enum.into(Map.new)

    key_count = Enum.count(keys(map))

    path_to_a_reachable_key(map, [], 0, key_count, pid)
    |> List.flatten
    |> Enum.min
  end

  defmemo path_to_a_reachable_key(map, collected, steps, key_count, pid) do
    lowest_so_far = Agent.get(pid, &Map.get(&1, :lowest_so_far))
    visible = reachable(map)
    keys = keys(visible)
    # lowest_so_far |> IO.inspect(label: "low")
    if lowest_so_far <= steps do
      @large
    else
      if key_count == Enum.count(collected) do
        if steps < lowest_so_far do
          Agent.update(pid, &Map.put(&1, :lowest_so_far, steps))
        end
        steps |> IO.inspect(label: "Sol")
      else
        graph =
          visible
          # |> IO.inspect
          |> Enum.reduce(:digraph.new(), fn {{x, y}, value}, acc ->
            :digraph.add_vertex(acc, {x, y}, value)
            acc
          end)

        graph =
          visible
          |> Enum.reduce(graph, fn {{x, y}, _}, acc ->
            locs = Enum.map(visible, fn x -> elem(x, 0) end)
            if Enum.member?(locs, {x-1, y}) do
              :digraph.add_edge(acc, {x-1, y}, {x, y})
              :digraph.add_edge(acc, {x, y}, {x-1, y})
            end

            if Enum.member?(locs, {x+1, y}) do
              :digraph.add_edge(acc, {x+1, y}, {x, y})
              :digraph.add_edge(acc, {x, y}, {x+1, y})
            end

            if Enum.member?(locs, {x, y-1}) do
              :digraph.add_edge(acc, {x, y-1}, {x, y})
              :digraph.add_edge(acc, {x, y}, {x, y-1})
            end

            if Enum.member?(locs, {x, y+1}) do
              :digraph.add_edge(acc, {x, y+1}, {x, y})
              :digraph.add_edge(acc, {x, y}, {x, y+1})
            end

            acc
          end)

        it_takes =
          keys
          # |> IO.inspect
          |> Stream.map(fn {_, key} ->
            start = elem(Enum.find(visible, fn {_, value} -> value == "@" end), 0)# |> IO.inspect(label: "From")
            desti = elem(Enum.find(visible, fn {_, value} -> value == key end), 0)# |> IO.inspect(label: "To")
            path = :digraph.get_short_path(graph, start, desti)# |> IO.inspect(label: "Path")

            if path == false do
              {key, @large}
            else
              {key, Enum.count(path) - 1}
            end
          end)
          |> Enum.sort(fn l, r ->
            elem(l, 1) > elem(r, 1)
          end)

        it_takes
        |> Stream.map(fn {key, stp} ->
          map = update_map(map, key)
          path_to_a_reachable_key(map, [key | collected], steps + stp, key_count, pid)
        end)
        |> Enum.to_list
      end
    end
  end

  def update_map(map, key) do
    door = String.upcase(key)

    kk = Enum.find(map, fn {_, val} ->
      val == key
    end)

    dk = Enum.find(map, fn {_, val} ->
      val == door
    end)

    ak = Enum.find(map, fn {_, val} ->
      val == "@"
    end)

    map =
      map
      |> Map.replace!(elem(ak, 0), ".")
      |> Map.replace!(elem(kk, 0), "@")

    if dk == nil do
      map
    else
      Map.replace!(map, elem(dk, 0), ".")
    end
  end

  defmemo reachable(map) do
    map
    |> Stream.filter(fn {_, value} ->
      String.match?(value, ~r/[a-z@.]/)
    end)
  end

  defmemo keys(map) do
    map
    |> Stream.filter(fn {_, value} ->
      String.match?(value, ~r/[a-z]/)
    end)
  end

  defp input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, "",  trim: true)
    end)
    |> Enum.with_index
    |> Enum.reduce(Map.new, fn {line, y}, acc ->
      line
      |> Enum.with_index
      |> Enum.reduce(acc, fn {item, x}, acc ->
        Map.put(acc, {x, y}, item)
      end)
    end)
  end
end
