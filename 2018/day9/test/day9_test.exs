defmodule Day9Test do
  use ExUnit.Case
  doctest Day9

  test "highest score" do
    assert Day9.highest_score(427, 70723) == 0
  end
end
