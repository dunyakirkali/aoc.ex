defmodule Day5Test do
  use ExUnit.Case
  doctest Aoc.Day5

  test "Part 1" do
    assert Aoc.Day5.part1().output == 13933662
  end

  test "Jump in position mode for input 0" do
    machine =
      %AGC{instructions: [3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9]}
      |> Map.put(:input, 0)
      |> AGC.run()
    assert machine.output == 0
  end

  test "Jump in immediate mode for input 0" do
    machine =
      %AGC{instructions: [3,3,1105,-1,9,1101,0,0,12,4,12,99,1]}
      |> Map.put(:input, 0)
      |> AGC.run()
    assert machine.output == 0
  end

  test "Jump in position mode for input 1" do
    machine =
      %AGC{instructions: [3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9]}
      |> Map.put(:input, 1)
      |> AGC.run()
    assert machine.output == 1
  end

  test "Jump in immediate mode for input 1" do
    machine =
      %AGC{instructions: [3,3,1105,-1,9,1101,0,0,12,4,12,99,1]}
      |> Map.put(:input, 1)
      |> AGC.run()
    assert machine.output == 1
  end

  test "Equal using position mode when input is 8" do
    machine =
      %AGC{instructions: [3,9,8,9,10,9,4,9,99,-1,8]}
      |> Map.put(:input, 8)
      |> AGC.run()
    assert machine.output == 1
  end

  test "Equal using position mode when input is not 8" do
    machine =
      %AGC{instructions: [3,9,8,9,10,9,4,9,99,-1,8]}
      |> Map.put(:input, 2)
      |> AGC.run()
    assert machine.output == 0
  end

  test "Equal using immediate mode when input is equal to 8" do
    machine =
      %AGC{instructions: [3,3,1108,-1,8,3,4,3,99]}
      |> Map.put(:input, 8)
      |> AGC.run()
    assert machine.output == 1
  end

  test "Equal using immediate mode when input is not equal to 8" do
    machine =
      %AGC{instructions: [3,3,1108,-1,8,3,4,3,99]}
      |> Map.put(:input, 12)
      |> AGC.run()
    assert machine.output == 0
  end

  test "Less than using position mode when input is less than 8" do
    machine =
      %AGC{instructions: [3,9,7,9,10,9,4,9,99,-1,8]}
      |> Map.put(:input, 7)
      |> AGC.run()
    assert machine.output == 1
  end

  test "Less than using position mode when input is above 8" do
    machine =
      %AGC{instructions: [3,9,7,9,10,9,4,9,99,-1,8]}
      |> Map.put(:input, 12)
      |> AGC.run()
    assert machine.output == 0
  end

  test "Less than using immediate mode when input is less than 8" do
    machine =
      %AGC{instructions: [3,3,1107,-1,8,3,4,3,99]}
      |> Map.put(:input, 7)
      |> AGC.run()
    assert machine.output == 1
  end

  test "Less than using immediate mode when input is above 8" do
    machine =
      %AGC{instructions: [3,3,1107,-1,8,3,4,3,99]}
      |> Map.put(:input, 12)
      |> AGC.run()
    assert machine.output == 0
  end

  test "Larger example when input < 8" do
    machine =
      %AGC{instructions: [3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99]}
      |> Map.put(:input, 6)
      |> AGC.run()
    assert machine.output == 999
  end

  test "Larger example when input == 8" do
    machine =
      %AGC{instructions: [3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99]}
      |> Map.put(:input, 8)
      |> AGC.run()
    assert machine.output == 1000
  end

  test "Larger example when input > 8" do
    machine =
      %AGC{instructions: [3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99]}
      |> Map.put(:input, 9)
      |> AGC.run()
    assert machine.output == 1001
  end

  test "Part 2" do
    assert Aoc.Day5.part2().output == 2369720
  end
end
