defmodule Day19 do
  defmodule Elf do
    defstruct [:id, :left]
  end

  @doc """
      iex> Day19.part_1(5)
      3
  """
  def part_1(elf_count) do
    elves =
      0..(elf_count - 1)
      |> Enum.map(fn elf_id ->
        %Elf{id: elf_id + 1, left: rem(elf_id + 1, elf_count) }
      end)
      |> turn(0)
  end

  @doc """
      iex> Day19.part_2(1)
      1
      iex> Day19.part_2(2)
      1
      iex> Day19.part_2(3)
      3
      iex> Day19.part_2(4)
      1
      iex> Day19.part_2(5)
      2
      iex> Day19.part_2(6)
      3
  """
  def part_2(elf_count) do
    0..(elf_count - 1)
    |> Enum.to_list()
    |> do_part_2(0)
  end

  def part_2_shortcut(elf_count) do
    last = find_greatest_multiplier(elf_count, 3) |> IO.inspect
    elf_count - last
  end

  defp find_greatest_multiplier(elf_count, last_known) when last_known * 3 > elf_count, do: last_known
  defp find_greatest_multiplier(elf_count, last_known) do
    find_greatest_multiplier(elf_count, last_known * 3)
  end

  defp do_part_2(elves, index) do
    if Enum.count(elves) < 2 do
      List.first(elves) + 1
    else
      curr = Enum.at(elves, index)
      # index |> IO.inspect(label: "Index")
      jump =
        elves
        # |> IO.inspect(label: "Elves")
        |> Enum.count()
        |> div(2)
        |> round()
      across = rem(jump + index, Enum.count(elves))
      # |> IO.inspect(label: "Across")
      elves = List.delete_at(elves, across)
      # |> IO.inspect
      corrected_index = Enum.find_index(elves, fn x -> x == curr end)

      do_part_2(elves, rem(corrected_index + 1, Enum.count(elves)))
    end
  end

  @doc """
      iex> Day19.part_1_shortcurt(5)
      3
  """
  def part_1_shortcurt(elf_count) do
    binary_array =
      elf_count
      |> Integer.to_string(2)
      |> String.codepoints

    {first, rest} = Enum.split(binary_array, 1)

    rest ++ first
    |> Enum.join
    |> Integer.parse(2)
    |> elem(0)
  end

  def turn(elves, index) do
    # IO.puts("--")
    elf = Enum.at(elves, index)# |> IO.inspect(label: "elf")
    next_elf = Enum.at(elves, elf.left)# |> IO.inspect(label: "next")

    if elf.id == next_elf.id do
      elf.id
    else
      elf = %{elf | left: next_elf.left}
      elves = List.replace_at(elves, index, elf)# |> IO.inspect(label: "elves")

      turn(elves, elf.left)
    end
  end
end
