defmodule Aoc.Day14 do

  @ore 1_000_000_000_000

  @doc """
      iex> Aoc.Day14.part1("priv/day14/example_1.txt")
      31

      iex> Aoc.Day14.part1("priv/day14/example_2.txt")
      165

      iex> Aoc.Day14.part1("priv/day14/example_3.txt")
      13312

      iex> Aoc.Day14.part1("priv/day14/example_4.txt")
      180697

      iex> Aoc.Day14.part1("priv/day14/example_5.txt")
      2210736
  """
  def part1(filename, required \\ 1) do
    filename
    |> input()
    |> mapify()
    |> solve([{"FUEL", required}], %{}, 0)
  end

  def part2(input), do: part2(input, {0, @ore})

  def part2(input, {min, max}) when min + 1 == max do
    test = part1(input, max)

    if test > @ore do
      min
    else
      max
    end
  end

  def part2(input, {min, max}) do
    middle = ceil((max - min) / 2) + min
    answer = part1(input, middle)

    next_range =
      cond do
        answer < @ore -> {middle, max}
        answer > @ore -> {min, middle}
      end

    part2(input, next_range)
  end

  def solve(_, [], _, total_ore), do: total_ore
  def solve(materials, [{"ORE", ore_count} | rest], have, total_ore) do
    solve(materials, rest, have, total_ore + ore_count)
  end
  def solve(materials, [{next_type, need_qty} | unmet], have, total_ore) do
    material = Map.get(materials, next_type)
    create_qty = Map.get(material, :amount)
    have_qty = Map.get(have, next_type, 0)

    produce_times = ceil((need_qty - have_qty) / create_qty)
    next_have_qty = produce_times * create_qty + have_qty

    next_unmet =
      if produce_times == 0 do
        unmet
      else
        require_list =
          material
          |> Map.get(:ingredients)
          |> Map.to_list()
          |> Enum.map(fn {name, count} -> {name, count * produce_times} end)

        unmet ++ require_list
      end

    next_have = Map.put(have, next_type, next_have_qty - need_qty)
    solve(materials, next_unmet, next_have, total_ore)
  end

  defp mapify(lines) do
    lines
    |> Enum.map(fn line ->
      [dest_line, ing_line] =
        line
        |> String.split(" => ")
        |> Enum.reverse()

      destination =
        dest_line
        |> String.split(", ")

      ingredients =
        ing_line
        |> String.split(", ")

      {Enum.at(destination, 0), ingredients}
    end)
    |> Enum.reduce(Map.new(), fn {dest, ings}, acc ->
      [dest_amount, dest_molec] = String.split(dest, " ")

      ing_map = Enum.reduce(ings, Map.new(), fn ing, bcc ->
        [ing_amount, ing_molec] = String.split(ing, " ")

        Map.put(bcc, ing_molec, String.to_integer(ing_amount))
      end)

      Map.put(acc, dest_molec, %{amount: String.to_integer(dest_amount), ingredients: ing_map})
    end)
  end

  defp input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
