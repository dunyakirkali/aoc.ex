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
