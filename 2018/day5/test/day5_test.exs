defmodule Day5Test do
  use ExUnit.Case
  doctest Day5

  test "example 1" do
    assert Day5.react("aA") == ""
  end

  test "example 2" do
    assert Day5.react("abBA") == ""
  end

  test "example 3" do
    assert Day5.react("abAB") == "abAB"
  end

  test "example 4" do
    assert Day5.react("aabAAB") == "aabAAB"
  end

  test "example 5" do
    assert Day5.react("dabAcCaCBAcCcaDA") == "dabCBAcaDA"
  end

  test "String.length" do
    input = 'input.txt' |> File.read!

    assert input |> String.trim |> String.length == 50000
  end

  test "String.split" do
    input = 'input.txt' |> File.read!

    assert input |> String.trim |> String.split("", trim: true) |> length == 50000
  end

  test "Part 1" do
    input = 'input.txt' |> File.read!

    assert input |> Day5.react |> String.length == 9390
  end

  test "clean 1" do
    assert Day5.clean("dabAcCaCBAcCcaDA", "a") == "dbcCCBcCcD"
  end

  test "clean 2" do
    assert Day5.clean("dabAcCaCBAcCcaDA", "b") == "daAcCaCAcCcaDA"
  end

  test "clean 3" do
    assert Day5.clean("dabAcCaCBAcCcaDA", "c") == "dabAaBAaDA"
  end

  test "clean 4" do
    assert Day5.clean("dabAcCaCBAcCcaDA", "d") == "abAcCaCBAcCcaA"
  end

  test "example 6" do
    assert Day5.part2("dabAcCaCBAcCcaDA") == 4
  end

  @tag timeout: 60_000_000
  test "Part 2" do
    input = 'input.txt' |> File.read!

    assert input |> Day5.part2 == 5898
  end
end
