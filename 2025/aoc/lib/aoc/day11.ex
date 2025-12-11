defmodule Aoc.Day11 do
  import Bitwise

  @doc """
      iex> "priv/day11/example.txt" |> Aoc.Day11.input() |> Aoc.Day11.part1()
      5
  """
  def part1(g) do
    count_paths_dp(g, "you", "out")
  end

  @doc """
      iex> "priv/day11/example2.txt" |> Aoc.Day11.input() |> Aoc.Day11.part2()
      2
  """
  def part2(g) do
    waypoints = ["fft", "dac"]
    waypoint_indices = Map.new(waypoints, fn w -> {w, Enum.find_index(waypoints, &(&1 == w))} end)
    all_waypoints_mask = (1 <<< length(waypoints)) - 1

    count_paths_with_waypoints_dp(g, "svr", "out", waypoint_indices, all_waypoints_mask)
  end

  defp count_paths_dp(graph, source, target) do
    vertices = :digraph_utils.topsort(graph)
    dp = build_path_count_table(graph, vertices, target)
    Map.get(dp, source, 0)
  end

  defp build_path_count_table(graph, vertices, target) do
    Enum.reverse(vertices)
    |> Enum.reduce(%{}, fn vertex, dp ->
      count =
        if vertex == target do
          1
        else
          :digraph.out_neighbours(graph, vertex)
          |> Enum.map(fn neighbor -> Map.get(dp, neighbor, 0) end)
          |> Enum.sum()
        end

      Map.put(dp, vertex, count)
    end)
  end

  defp count_paths_with_waypoints_dp(graph, source, target, waypoint_indices, target_mask) do
    vertices = :digraph_utils.topsort(graph)

    dp = build_waypoint_dp_table(graph, vertices, target, waypoint_indices, target_mask)

    source_mask = if Map.has_key?(waypoint_indices, source) do
      1 <<< waypoint_indices[source]
    else
      0
    end

    Map.get(dp, {source, source_mask}, 0)
  end

  defp build_waypoint_dp_table(graph, vertices, target, waypoint_indices, target_mask) do
    Enum.reverse(vertices)
    |> Enum.reduce(%{}, fn vertex, dp ->
      possible_masks = 0..target_mask

      Enum.reduce(possible_masks, dp, fn mask, acc ->
        count = compute_waypoint_count(graph, vertex, target, mask, waypoint_indices, target_mask, acc)
        if count > 0 do
          Map.put(acc, {vertex, mask}, count)
        else
          acc
        end
      end)
    end)
  end

  defp compute_waypoint_count(graph, vertex, target, mask, waypoint_indices, target_mask, dp) do
    cond do
      vertex == target and mask == target_mask ->
        1

      vertex == target ->
        0

      true ->
        :digraph.out_neighbours(graph, vertex)
        |> Enum.map(fn neighbor ->
          new_mask = if Map.has_key?(waypoint_indices, neighbor) do
            mask ||| (1 <<< waypoint_indices[neighbor])
          else
            mask
          end

          Map.get(dp, {neighbor, new_mask}, 0)
        end)
        |> Enum.sum()
    end
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [f | ts] =
        line
        |> String.split(": ", trim: true)

      {f, String.split(List.first(ts), " ", trim: true)}
    end)
    |> Enum.reduce(:digraph.new(), fn {from, tos}, graph ->
      Enum.reduce(tos, graph, fn to, g ->
        :digraph.add_vertex(g, from)
        :digraph.add_vertex(g, to)
        :digraph.add_edge(g, from, to)
        g
      end)
    end)
  end
end
