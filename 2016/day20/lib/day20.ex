defmodule Day20 do
  def part_1_shortcut(file) do
    ranges =
      file
      |> File.read!
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [from, to] =
          line
          |> String.split("-")
          |> Enum.sort
          |> Enum.map(&String.to_integer/1)

        from..to
      end)

    possibilities =
      file
      |> File.read!
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [from, to] =
          line
          |> String.split("-")
          |> Enum.sort
          |> Enum.map(&String.to_integer/1)

        to + 1
      end)
      |> Enum.sort

    possibilities
    |> Enum.map(fn possibility ->
      if Enum.all?(ranges, fn range -> !Enum.member?(range, possibility) end) do
        possibility
      else
        nil
      end
    end)
    |> Enum.filter(&(&1 != nil))
    |> List.first
  end

  def part_1(file) do
    file
    |> File.read!
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [from, to] =
        line
        |> String.split("-")
        |> Enum.sort
        |> Enum.map(&String.to_integer/1)

      from..to
    end)
    |> unite
    |> lowest_valued_ip
  end

  @doc """
      iex> Day20.lowest_valued_ip([0, 1, 2, 4, 5, 6, 7, 8])
      3
  """
  def lowest_valued_ip(list) do
    0..4294967295
    |> Stream.drop_while(fn ip ->
      Enum.member?(list, ip)
    end)
    |> Enum.at(0)
  end

  @doc """
      iex> Day20.unite([5..8, 0..2, 4..7])
      [0, 1, 2, 4, 5, 6, 7, 8]
  """
  def unite(ranges) do
    ranges
    |> Enum.reduce(MapSet.new, fn range, acc ->
      MapSet.union(acc, MapSet.new(range))
    end)
    |> Enum.to_list
  end
end
