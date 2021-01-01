defmodule Aoc.Day4 do
  def part1() do
    206938..679128
    |> Stream.filter(fn x ->
      increasing?(x) and
      correct_length?(x) and
      within_range?(x) and
      has_double?(x)
    end)
    |> Enum.count
  end

  def part2() do
    206938..679128
    |> Stream.filter(fn x ->
      increasing?(x) and
      correct_length?(x) and
      within_range?(x) and
      has_proper_double?(x)
    end)
    |> Enum.count
  end

  @doc """
      iex> Aoc.Day4.increasing?(111123)
      true

      iex> Aoc.Day4.increasing?(135679)
      true

      iex> Aoc.Day4.increasing?(913567)
      false
  """
  def increasing?(password) do
    digits = Integer.digits(password)
    Enum.sort(digits) == digits
  end

  @doc """
      iex> Aoc.Day4.correct_length?(12345)
      false

      iex> Aoc.Day4.correct_length?(123456)
      true
  """
  def correct_length?(password) do
    password
    |> Integer.digits
    |> Enum.count
    |> Kernel.==(6)
  end

  @doc """
      iex> Aoc.Day4.within_range?(206939)
      true

      iex> Aoc.Day4.within_range?(206937)
      false
  """
  def within_range?(password) do
    206938..679128
    |> Enum.member?(password)
  end

  @doc """
      iex> Aoc.Day4.has_double?(122345)
      true

      iex> Aoc.Day4.has_double?(206937)
      false
  """
  def has_double?(password) do
    (for n <- 1..9, do: n * 10 + n)
    |> Enum.map(fn option ->
      "#{password}" =~ "#{option}"
    end)
    |> Enum.any?
  end

  @doc """
      iex> Aoc.Day4.has_proper_double?(112233)
      true

      iex> Aoc.Day4.has_proper_double?(123444)
      false

      iex> Aoc.Day4.has_proper_double?(111122)
      true
  """
  def has_proper_double?(password) do
    (for n <- 1..9, do: {n * 10 + n, n * 100 + n * 10 + n})
    |> Enum.map(fn {s, l} ->
      "#{password}" =~ "#{s}" and !("#{password}" =~ "#{l}")
    end)
    |> Enum.any?
  end
end
