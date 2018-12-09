defmodule Day8 do
  @moduledoc """
  Documentation for Day8.
  """

  @doc """
      iex> Day8.part_1("input.txt")
      42798
  """
  def part_1(filename) do
    {root, _} =
      filename
      |> File.read!()
      |> String.split([" ", "\n"], trim: true)
      |> Enum.map(&String.to_integer/1)
      |> build_tree(0)

    root
    |> count_meta()
    |> IO.inspect
  end

  @doc """
      iex> Day8.part_2("input.txt")
      23798
  """
  def part_2(filename) do
    {root, _} = filename
    |> File.read!()
    |> String.split([" ", "\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
    |> build_tree(0)

    root
    |> count_meta_p2()
  end

  def count_meta_p2({_, [], meta}) do
      Enum.sum(meta)
  end

  def count_meta_p2({_, children, meta}) do
      Enum.map(meta, &calc_node_value(&1, children))
      |> Enum.sum()
  end

  def calc_node_value(index, children) do
      case Enum.at(children, index - 1) do
      nil -> 0
      x -> count_meta_p2(x)
      end
  end

  def count_meta({_, children, meta}) do
    Enum.sum(Enum.map(children, &count_meta/1)) + Enum.sum(meta)
  end

  def build_tree([num_children, 0 | tail], index) do
    # build children
    # collect children
    {new_list, new_nodes, _} =
      Enum.reduce(0..(num_children - 1), {tail, [], index}, fn _, {list, siblings, i} ->
        {new_node, l} = build_tree(list, i + 1)
        {l, [new_node | siblings], i + 1}
      end)

    {{index, Enum.reverse(new_nodes), []}, new_list}
  end

  def build_tree([0, num_meta | tail], index) do
    # collect meta

    {new_list, meta_entries} = collect_meta(tail, num_meta)

    {{index, [], meta_entries}, new_list}
  end

  def build_tree([num_children, num_meta | tail], index) do
    # build children
    # collect children
    # collect meta
    {new_list, new_nodes, _} =
      Enum.reduce(0..(num_children - 1), {tail, [], index}, fn _, {list, siblings, i} ->
        {new_node, l} = build_tree(list, i + 1)
        {l, [new_node | siblings], i + 1}
      end)

    {final_list, meta_entries} = collect_meta(new_list, num_meta)

    {{index, Enum.reverse(new_nodes), meta_entries}, final_list}
  end

  def collect_meta(list, num_meta, meta_so_far \\ [])

  def collect_meta(list, 0, meta_so_far) do
      {list, Enum.reverse(meta_so_far)}
  end

  def collect_meta([head | tail], num_meta, meta_so_far) do
      collect_meta(tail, num_meta - 1, [head | meta_so_far])
  end
end
