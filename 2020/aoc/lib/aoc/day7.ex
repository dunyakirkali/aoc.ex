defmodule Aoc.Day7 do
  @doc """
      iex> inp = Aoc.Day7.input("priv/day7/example.txt")
      ...> Aoc.Day7.part1(inp)
      4
  """
  def part1(inp) do
    inp
    |> Enum.map(fn row ->
      match = Regex.named_captures(~r/(?<parent>.*) contain (?<details>.*)/, row)

      parent =
        String.split(match["parent"], " ")
        |> Enum.reverse()
        |> tl()
        |> Enum.reverse()
        |> Enum.join(" ")

      {parent, match["details"]}
    end)
    |> parse_tree
    |> count("shiny gold", [])
    |> Enum.uniq()
    |> Enum.count()
  end

  def count(info, bag_name, acc) do
    found =
      info
      |> Enum.filter(fn {_key, value} ->
        value
        |> Enum.filter(fn tuple ->
          if tuple == {} do
            false
          else
            {_count, bag} = tuple
            bag == bag_name
          end
        end)
        |> Enum.count()
        |> Kernel.>(0)
      end)

    acc =
      found
      |> Enum.reduce(acc, fn {par, children}, accc ->
        children
        |> Enum.reduce(accc, fn {_count, name}, acccc ->
          if name == bag_name do
            [par | acccc]
          else
            acccc
          end
        end)
      end)

    found
    |> Enum.reduce(acc, fn {par, _}, accc ->
      count(info, par, accc)
    end)
  end

  def parse_tree(info) do
    info
    |> Enum.reduce(Map.new(), fn {parent, children}, acc ->
      childs =
        children
        |> String.replace(".", "")
        |> String.split(", ")

      all =
        childs
        |> Enum.map(fn child ->
          match = Regex.named_captures(~r/(?<count>\d+) (?<bag>.*) bags?/, child)

          if match["count"] == nil do
            {}
          else
            {String.to_integer(match["count"]), match["bag"]}
          end
        end)

      Map.put(acc, parent, all)
    end)
  end

  @doc """
      iex> inp = Aoc.Day7.input("priv/day7/example.txt")
      ...> Aoc.Day7.part2(inp)
      32

      iex> inp = Aoc.Day7.input("priv/day7/example2.txt")
      ...> Aoc.Day7.part2(inp)
      126
  """
  def part2(inp) do
    inp
    |> Enum.map(fn row ->
      match = Regex.named_captures(~r/(?<parent>.*) contain (?<details>.*)/, row)

      parent =
        String.split(match["parent"], " ")
        |> Enum.reverse()
        |> tl()
        |> Enum.reverse()
        |> Enum.join(" ")

      {parent, match["details"]}
    end)
    |> parse_tree
    |> count_sub("shiny gold", 0)
  end

  def count_sub(tree, bag_name, acc) do
    children = Map.get(tree, bag_name)

    if children == [{}] do
      acc
    else
      children
      |> Enum.map(fn {count, name} ->
        count + count * count_sub(tree, name, acc)
      end)
      |> Enum.sum()
    end
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
