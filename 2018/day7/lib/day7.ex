defmodule Day7 do
  import NimbleParsec

  def duration(input, worker_count) do
    tree =
      input
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&parse/1)
      |> treeify
      |> IO.inspect(label: "tree")
  end

  def assign_to(tree, workers, options, visited) do
    filtered_options =
      options
      |> Enum.filter(fn option ->
        get_preq(tree, option)
        |> Enum.all?(fn preq ->
          Enum.member?(visited, preq)
        end)
      end)
      |> Enum.sort()
      |> IO.inspect
    visit = List.first(filtered_options)

    [workers, visit, List.delete(options, visit)]
  end

  @doc """
      iex> Day7.seconds("A")
      1

      iex> Day7.seconds("Z")
      26
  """
  def seconds(letter) do
    Kernel.to_charlist(letter)
    |> List.first
    |> Kernel.-(64)
  end

  def path(input) do
    tree =
      input
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&parse/1)
      |> treeify

    roots = find_roots(tree)

    1..999_999
    |> Enum.to_list()
    |> Enum.reduce_while([[], roots], fn _, [acc, options] ->
      filtered_options =
        options
        |> Enum.filter(fn option ->
          get_preq(tree, option)
          |> Enum.all?(fn preq ->
            Enum.member?(acc, preq)
          end)
        end)
        |> Enum.sort()

      next =
        filtered_options
        |> List.first()

      if next == nil do
        if length(filtered_options) == 0 do
          {:halt, [acc, options]}
        else
          {:cont, [acc, options]}
        end
      else
        if tree[next] == nil do
          {:halt, [[next | acc], List.delete(options, next)]}
        else
          ret = [[next | acc], Enum.uniq(List.delete(options, next) ++ tree[next])]
          {:cont, ret}
        end
      end
    end)
    |> List.first()
    |> Enum.reverse()
    |> List.to_string()
  end

  @doc """
      iex> Day7.get_preq(%{"C" => ["A", "F"], "A" => ["B", "D"], "B" => ["E"], "D" => ["E"], "F" => ["E"]}, "E")
      ["B", "D", "F"]
  """
  def get_preq(tree, item) do
    tree
    |> Enum.filter(fn {_, to} ->
      Enum.member?(to, item)
    end)
    |> Enum.map(fn hsh ->
      elem(hsh, 0)
    end)
  end

  @doc """
      iex> Day7.all(%{"C" => ["A", "F"], "A" => ["B", "D"], "B" => ["E"], "D" => ["E"], "F" => ["E"]})
      ["A", "B", "C", "D", "E", "F"]
  """
  def all(tree) do
    keys =
      tree
      |> Map.keys()

    values =
      tree
      |> Map.values()
      |> List.flatten()

    (keys ++ values)
    |> Enum.uniq()
    |> Enum.sort()
  end

  @doc """
      iex> Day7.find_roots(%{"C" => ["A", "F"], "A" => ["B", "D"], "B" => ["E"], "D" => ["E"], "F" => ["E"]})
      ["C"]
  """
  def find_roots(tree) do
    leaves =
      tree
      |> Map.values()
      |> List.flatten()
      |> Enum.uniq()
      |> Enum.sort()

    (all(tree) -- leaves)
    |> Enum.sort()
  end

  @doc """
      iex> Day7.treeify([["C", "A"], ["C", "F"], ["A", "B"], ["A", "D"], ["B", "E"], ["D", "E"], ["F", "E"]])
      %{"C" => ["A", "F"], "A" => ["B", "D"], "B" => ["E"], "D" => ["E"], "F" => ["E"]}
  """
  def treeify(lines) do
    lines
    |> Enum.reduce(%{}, fn [from, to], acc ->
      Map.update(acc, from, [to], &([to | &1] |> Enum.reverse()))
    end)
  end

  @doc """
      iex> Day7.parse("Step A must be finished before step B can begin.")
      ["A", "B"]
  """
  def parse(line) do
    {:ok, step, _, _, _, _} = definition(line)
    step
  end

  defparsec(
    :definition,
    ignore(string("Step "))
    |> ascii_string([?A..?Z], min: 1)
    |> ignore(string(" must be finished before step "))
    |> ascii_string([?A..?Z], min: 1)
    |> ignore(string(" can begin."))
  )
end
