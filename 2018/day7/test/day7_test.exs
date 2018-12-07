defmodule Day7Test do
  use ExUnit.Case
  doctest Day7

  test "example 1" do
    input = """
    Step C must be finished before step A can begin.
    Step C must be finished before step F can begin.
    Step A must be finished before step B can begin.
    Step A must be finished before step D can begin.
    Step B must be finished before step E can begin.
    Step D must be finished before step E can begin.
    Step F must be finished before step E can begin.
    """

    assert Day7.path(input) == "CABDFE"
  end

  test "part 1" do
    input =
      'input.txt'
      |> File.read!()

    assert Day7.path(input) == "JKNSTHCBGRVDXWAYFOQLMPZIUE"
  end
end
