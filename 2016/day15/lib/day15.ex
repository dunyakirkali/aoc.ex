defmodule Day15 do
  def part_2(file) do
    disks = read(file) ++ [{11, 0}]

    drop(disks, 0)
  end
  
  @doc """
      iex> Day15.part_1("priv/example.txt")
      5
  """
  def part_1(file) do
    disks = read(file)

    drop(disks, 0)
  end

  @doc """
      iex> Day15.read("priv/example.txt")
      [{5, 4}, {2, 1}]
  """
  def read(file) do
    file
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [_, positions, position] =
        Enum.drop(
          Regex.run(~r/Disc #(\d) has (\d+) positions; at time=0, it is at position (\d+)/, line),
          1
        )

      {String.to_integer(positions), String.to_integer(position)}
    end)
  end

  def drop(disks, time) do
    falls =
      disks
      |> Enum.with_index()
      |> Enum.map(fn {disk, index} ->
        rem(elem(disk, 1) + 1 + time + index, elem(disk, 0))
      end)
      |> Enum.all?(fn x -> x == 0 end)

    if falls do
      time
    else
      drop(disks, time + 1)
    end
  end
end
