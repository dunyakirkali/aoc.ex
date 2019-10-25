defmodule Day19Test do
  use ExUnit.Case
  doctest Day19

  # test "Part 1" do
  #   assert Day19.part_1(3014603) == 1834903
  # end

  test "Part 1 shortcut" do
    assert Day19.part_1_shortcurt(3_014_603) == 1_834_903
  end

  # test "Part 2 analysis" do
  #   # IO.puts(rem(3014603, 3))
  #   # IO.puts(rem(3014601, 3))
  #   1..3014603
  #   |> Enum.each(fn elf_count ->
  #     res = Day19.part_2(elf_count)
  #
  #     tri = Integer.to_string(elf_count, 3)
  #     if elf_count == res or res == 1 do
  #       IO.puts("Count: #{elf_count} (#{tri})=> #{res}")
  #     end
  #   end)
  # end

  test "Part 2 shortcut" do
    assert Day19.part_2_shortcut(3_014_603) == 1_420_280
  end
end
