defmodule Aoc.Day18 do
  use Memoize

  def part2(filename) do
    input = File.read!(filename)
    points =
      for {line, y} <- String.trim(input) |> String.split("\n") |> Enum.with_index(),
          {c, x} <- String.codepoints(line) |> Enum.with_index(),
          do: {{x, y}, c}

    start_points =
      Enum.filter(points, fn {_, c} -> c == "@" end) |> Enum.map(fn {point, _} -> point end)

    keys = Enum.count(points, fn {_, c} -> c =~ ~r([a-z]) end)
    Map.new(points) |> find_path_part2(start_points, keys)
  end

  defp find_path_part2(map, start_points, key_count) do
    start_points = Enum.map(start_points, &{&1, Enum.sort(start_points -- [&1])})

    queue =
      Enum.map(start_points, fn {pos, other_robots} -> {pos, MapSet.new(), other_robots, 0} end)
      |> :queue.from_list()

    find_path_part2(map, key_count, MapSet.new(start_points), queue)
  end

  defp find_path_part2(map, key_count, visited, queue) do
    {{:value, {current_point, keys, other_robots, depth}}, queue} = :queue.out(queue)

    if MapSet.size(keys) == key_count do
      depth
    else
      {visited, queue} =
        find_neighbours(current_point)
        |> Enum.reduce({visited, queue}, fn new_point, unmodified = {visited, queue} ->
          modify = &modify(visited, queue, new_point, depth + 1, &1, other_robots)

          case map[new_point] do
            "#" ->
              unmodified

            "." ->
              modify.(keys)

            "@" ->
              modify.(keys)

            x ->
              cond do
                x =~ ~r([a-z]) ->
                  inserted_key = MapSet.put(keys, String.upcase(x))
                  all_robots = [new_point | other_robots]

                  Enum.reduce(all_robots, {visited, queue}, fn robot_pos, {visited, queue} ->
                    modify(
                      visited,
                      queue,
                      robot_pos,
                      depth + 1,
                      inserted_key,
                      Enum.sort(all_robots -- [robot_pos])
                    )
                  end)

                x =~ ~r([A-Z]) ->
                  if MapSet.member?(keys, x), do: modify.(keys), else: unmodified
              end
          end
        end)

      find_path_part2(map, key_count, visited, queue)
    end
  end

  defp modify(visited, queue, new_point, new_depth, keys, other_robots) do
    if MapSet.member?(visited, {new_point, keys, other_robots}) do
      {visited, queue}
    else
      visited = MapSet.put(visited, {new_point, keys, other_robots})
      queue = :queue.in({new_point, keys, other_robots, new_depth}, queue)
      {visited, queue}
    end
  end

  def part1(filename) do
    data =
      filename
      |> input()
      |> mapify()

    pos = Map.get(data, :me)
    map = Map.get(data, :map)
    keys = Map.get(data, :keys)

    search(pos, map, Enum.count(keys))
  end

  def search(pos, map, key_count) do
    keys = MapSet.new()
    do_search(map, key_count, MapSet.new([{pos, MapSet.new()}]), :queue.from_list([{pos, keys, 0}]))
  end

  def do_search(map, key_count, visited, queue) do
    # IO.inspect(visited, label: "Visited")

    {{:value, {head, keys, depth}}, queue} = :queue.out(queue)

    if MapSet.size(keys) == key_count do
      depth
    else
      {visited, queue} =
        find_neighbours(head)
        |> Enum.reduce({visited, queue}, fn new_point, unmodified = {visited, queue} ->
          modify = &modify(visited, queue, new_point, depth + 1, &1)

          case map[new_point] do
            :wall ->
              unmodified

            :path ->
              modify.(keys)

            {:key, key_id} ->

              MapSet.put(keys, key_id) |> modify.()

            {:door, door_id} ->
              if MapSet.member?(keys, door_id), do: modify.(keys), else: unmodified

          end
        end)

      do_search(map, key_count, visited, queue)
    end
  end

  defp modify(visited, queue, new_point, new_depth, keys) do
    if MapSet.member?(visited, {new_point, keys}) do
      {visited, queue}
    else
      visited = MapSet.put(visited, {new_point, keys})
      queue = :queue.in({new_point, keys, new_depth}, queue)
      {visited, queue}
    end
  end

  def find_neighbours({x, y}) do
    [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]
  end

  def mapify(str) do
    mapify(str, {0, 0}, %{})
  end
  def mapify([], _, acc), do: acc
  def mapify([?\n|t], {_, y}, acc), do: mapify(t, {0, y + 1}, acc)
  def mapify([?#|t], {x, y}, acc)  do
    acc =
      acc
      |> Map.update(:walls, MapSet.new([{x, y}]), &(MapSet.put(&1, {x, y})))
      |> Map.update(:map, Map.new([{{x, y}, :wall}]), &(Map.put(&1, {x, y}, :wall)))
    mapify(t, {x + 1, y}, acc)
  end
  def mapify([?@|t], {x, y}, acc)  do
    acc =
      acc
      |> Map.put(:me, {x, y})
      |> Map.update(:map, Map.new(), &(Map.put(&1, {x, y}, :path)))
    mapify(t, {x + 1, y}, acc)
  end
  def mapify([h|t], {x, y}, acc) when h in ?a..?z do
    acc =
      acc
      |> Map.update(:keys, Map.new([{{x, y}, type(h)}]), &(Map.put(&1, {x, y}, type(h))))
      |> Map.update(:map, Map.new([{{x, y}, type(h)}]), &(Map.put(&1, {x, y}, type(h))))
    mapify(t, {x + 1, y}, acc)
  end
  def mapify([h|t], {x, y}, acc) when h in ?A..?Z do
    acc =
      acc
      |> Map.update(:doors, Map.new([{{x, y}, type(h)}]), &(Map.put(&1, {x, y}, type(h))))
      |> Map.update(:map, Map.new([{{x, y}, type(h)}]), &(Map.put(&1, {x, y}, type(h))))
    mapify(t, {x + 1, y}, acc)
  end
  def mapify([?.|t], {x, y}, acc) do
    acc =
      acc
      |> Map.update(:map, Map.new([{{x, y}, :path}]), &(Map.put(&1, {x, y}, :path)))
    mapify(t, {x + 1, y}, acc)
  end

  defp type(char) when char in ?a..?z, do: {:key, char + ?A - ?a}
  defp type(char) when char in ?A..?Z, do: {:door, char}

  defp input(filename) do
    filename
    |> File.read!()
    |> to_charlist()
  end
end
