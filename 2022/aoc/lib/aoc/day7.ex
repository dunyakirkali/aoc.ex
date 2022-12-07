defmodule Aoc.Day7 do
  @doc """
      iex> "priv/day7/example.txt" |> Aoc.Day7.input() |> Aoc.Day7.part1()
      95437
  """
  def part1(graph) do
    graph
    |> Graph.vertices()
    |> Enum.filter(fn v ->
      Graph.vertex_labels(graph, v)[:size] == nil
    end)
    |> Enum.map(fn node ->
      sizes(graph, node)
    end)
    |> Enum.filter(fn size ->
      size < 100_000
    end)
    |> Enum.sum()
  end

  @doc """
      iex> "priv/day7/example.txt" |> Aoc.Day7.input() |> Aoc.Day7.part2()
      24933642
  """
  def part2(graph) do
    sizes =
      graph
      |> Graph.vertices()
      |> Enum.filter(fn v ->
        Graph.vertex_labels(graph, v)[:size] == nil
      end)
      |> Enum.map(fn node ->
        sizes(graph, node)
      end)

    available = 70_000_000
    used = sizes(graph, "/")

    sizes
    |> Enum.filter(fn size -> used - size < 40_000_000 end)
    |> Enum.min()
  end

  def sizes(graph, v) do
    out_neighbors = Graph.out_neighbors(graph, v)

    if Enum.count(out_neighbors) == 0 do
      Graph.vertex_labels(graph, v)[:size]
    else
      out_neighbors
      |> Enum.map(fn edge ->
        sizes(graph, edge)
      end)
      |> Enum.sum()
    end
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.reduce({Graph.new(), []}, fn line, {acc, cwd} ->
      cond do
        String.starts_with?(line, "$") ->
          cond do
            String.starts_with?(line, "$ cd") ->
              ["$", "cd", folder] = String.split(line, " ")

              if folder == ".." do
                {acc, Enum.drop(cwd, 1)}
              else
                {acc, [folder | cwd]}
              end

            true ->
              {acc, cwd}
          end

        String.starts_with?(line, "dir") ->
          ["dir", folder] = String.split(line, " ")
          path = Enum.join(cwd, "/")
          to_path = Enum.join([folder | cwd], "/")

          {
            acc
            |> Graph.add_vertex(to_path)
            |> Graph.add_edge(path, to_path),
            cwd
          }

        true ->
          [size, file] = String.split(line, " ")
          path = Enum.join(cwd, "/")
          to_path = Enum.join([file | cwd], "/")

          {
            acc
            |> Graph.add_vertex(to_path, size: String.to_integer(size))
            |> Graph.add_edge(path, to_path),
            cwd
          }
      end
    end)
    |> elem(0)
  end
end
