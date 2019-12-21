defmodule Aoc.Day18 do
  use Memoize

  @large 1_000_000
  @doc """
      iex> Aoc.Day18.part1("priv/day18/example_1.txt")
      8
  """
  def part1(filename) do
    {:ok, pid} = Agent.start_link(fn -> @large end)
    map = input(filename)
    key_count = Enum.count(keys(map))

    path_to_a_reachable_key(map, 0, 0, key_count, pid)
    |> List.flatten
    |> Enum.min
  end

  defmemo path_to_a_reachable_key(map, collected_count, steps, key_count, pid) do
    lowest_so_far = Agent.get(pid, &(&1))
    visible = reachable(map)
    keys = keys(visible)
    # lowest_so_far |> IO.inspect(label: "low")
    if lowest_so_far <= steps do
      @large
    else
      if key_count == collected_count do
        if steps < lowest_so_far do
          Agent.update(pid, fn (state) -> lowest_so_far end)
        end
        steps |> IO.inspect(label: "Sol")
      else
        graph =
          visible
          # |> IO.inspect
          |> Enum.reduce(:digraph.new(), fn {_, {x, y}}, acc ->
            :digraph.add_vertex(acc, {x, y})
            acc
          end)

        graph =
          visible
          |> Enum.reduce(graph, fn {_, {x, y}}, acc ->
            locs = Stream.map(visible, fn x -> elem(x, 1) end)
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

        start = elem(Enum.find(visible, fn {value, _} -> value == :me end), 1)# |> IO.inspect(label: "From")
        keys
        # |> IO.inspect
        |> Stream.map(fn {key, _} ->
          desti = elem(Enum.find(visible, fn {value, _} -> value == key end), 1)# |> IO.inspect(label: "To")
          path = :digraph.get_short_path(graph, start, desti)# |> IO.inspect(label: "Path")

          if path == false do
            nil
          else
            {key, Enum.count(path) - 1}
          end
        end)
        |> Stream.reject(&is_nil/1)
        |> Stream.map(fn {key, stp} ->
          # key |> IO.inspect(label: "kkkk")
          map = update_map(map, key)# |> IO.inspect(label: "MAP")
          path_to_a_reachable_key(map, collected_count + 1, steps + stp, key_count, pid)
        end)
        |> Enum.to_list
        # |> IO.inspect(label: "Wfwfw")
      end
    end
  end

  defmemo update_map(map, key) do
    {:key, key_code} = key
    door = {:door, key_code}

    # map |> IO.inspect(label: "mmm")

    map
    |> Stream.map(fn {val, coords} ->
      case val do
        :me -> {:path, coords}
        _ -> {val, coords}
      end
    end)
    |> Stream.map(fn {val, coords} ->
      if val == key do
        {:me, coords}
      else
        {val, coords}
      end
    end)
    |> Stream.map(fn {val, coords} ->
      if val == door do
        {:path, coords}
      else
        {val, coords}
      end
    end)
  end

  defmemo reachable(map) do
    map
    |> Stream.filter(fn {k, _} ->
      case k do
        {:key, _} -> true
        :me -> true
        :path -> true
        _ -> false
      end
    end)
  end

  defmemo keys(map) do
    map
    |> Stream.filter(fn {k, _} ->
      case k do
        {:key, _} -> true
        _ -> false
      end
    end)
  end

  defp type(char) when char in ?a..?z, do: {:key, char + ?A - ?a}
  defp type(char) when char in ?A..?Z, do: {:door, char}
  defp type(?#), do: :wall
  defp type(?.), do: :path
  defp type(?@), do: :me

  defp input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Stream.with_index()
    |> Enum.to_list
    |> Enum.flat_map(fn {line, y} ->
      line
      |> to_charlist()
      |> Stream.with_index()
      |> Stream.map(fn {char, x} -> {type(char), {x, y}} end)
    end)
  end
end
