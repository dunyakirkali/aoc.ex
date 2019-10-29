defmodule Day17 do
  @doc """
      iex> Day17.part_1("ihgpwlah", {1, 1})
      "DDRRRD"

      iex> Day17.part_1("kglvqrro", {1, 1})
      "DDUDRLRRUDRD"

      iex> Day17.part_1("ulqzkmiv", {1, 1})
      "DRURDRUDDLLDLUURRDULRLDUUDDDRR"
  """
  def part_1(passcode, location) do
    # passcode |> IO.inspect
    do_part_1(passcode, [], location)
    |> List.flatten
    |> Enum.sort_by(fn x ->
      String.length(x)
    end)
    |> List.first
  end

  def do_part_1(passcode, directions, location) do
    direction_string = Enum.join(directions)
    if reaches?(directions) do
      direction_string
    else
      passcode <> direction_string
      |> possible_directions(location)
      |> Enum.map(fn direction ->
        location =
          case direction do
            "U" ->
              put_elem(location, 1, elem(location, 1) - 1)
            "D" ->
              put_elem(location, 1, elem(location, 1) + 1)
            "R" ->
              put_elem(location, 0, elem(location, 0) + 1)
            "L" ->
              put_elem(location, 0, elem(location, 0) - 1)
          end

        do_part_1(passcode, directions ++ [direction], location)
      end)
    end
  end

  @doc """
      iex> Day17.possible_directions("ihgpwlah", {1, 1})
      ["D", "R"]
  """
  def possible_directions(passcode, location) do
    md5_4(passcode)
    |> String.graphemes
    |> Enum.map(&(open?(&1)))
    |> Enum.with_index
    |> Enum.map(fn {v, i} ->
      letter =
        case i do
          0 -> "U"
          1 -> "D"
          2 -> "L"
          3 -> "R"
        end

      if v do
        if reachable?(location, letter), do: letter, else: nil
      end
    end)
    |> Enum.filter(fn x -> x != nil end)
  end

  @doc """
      iex> Day17.reachable?({1, 1}, "U")
      false

      iex> Day17.reachable?({1, 1}, "L")
      false

      iex> Day17.reachable?({1, 1}, "R")
      true

      iex> Day17.reachable?({1, 1}, "D")
      true

      iex> Day17.reachable?({4, 4}, "D")
      false
  """
  def reachable?(location, direction) do
    case direction do
      "U" ->
        elem(location, 1) != 1
      "D" ->
        elem(location, 1) != 4
      "R" ->
        elem(location, 0) != 4
      "L" ->
        elem(location, 0) != 1
    end
  end

  @doc """
      iex> Day17.md5_4("hijkl")
      "ced9"
  """
  def md5_4(str) do
    :crypto.hash(:md5, str) |> Base.encode16(case: :lower) |> String.slice(0..3)
  end

  @doc """
      iex> Day17.open?("a")
      false

      iex> Day17.open?("c")
      true
  """
  def open?(char) do
    Enum.member?(["b", "c", "d", "e", "f"], char)
  end

  @doc """
      iex> Day17.reaches?(["D", "D", "R"])
      false

      iex> Day17.reaches?(["D", "D", "D", "R", "R", "R"])
      true

      iex> Day17.reaches?(["D", "D", "U", "D", "D", "R", "R", "R"])
      true
  """
  def reaches?(directions) do
    directions
    |> Enum.reduce({1, 1}, fn x, acc ->
      case x do
        "U" ->
          put_elem(acc, 1, elem(acc, 1) - 1)
        "D" ->
          put_elem(acc, 1, elem(acc, 1) + 1)
        "R" ->
          put_elem(acc, 0, elem(acc, 0) + 1)
        "L" ->
          put_elem(acc, 0, elem(acc, 0) - 1)
      end
    end) == {4, 4}
  end
end
