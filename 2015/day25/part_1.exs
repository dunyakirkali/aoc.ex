defmodule Pass do
  def solve(n) when n == 1, do: 20151125
  def solve(n) when n > 1 do
    rem(solve(n - 1) * 252533, 33554393)
  end

  def find_position({x, y}), do: find_col_index(x + y) + x

  def find_col_index(c) when c == 0, do: 1
  def find_col_index(c) when c > 0 do
    c + find_col_index(c - 1)
  end
end

Pass.find_position({3019 - 1, 3010 - 1})
|> Pass.solve
|> IO.puts
