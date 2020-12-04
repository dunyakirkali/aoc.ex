defmodule Aoc.Day4 do
  @ignore ["cid"]

  @doc """
      iex> inp = Aoc.Day4.input("priv/day4/example.txt")
      ...> Aoc.Day4.part1(inp)
      2
  """
  def part1(inp) do
    inp
    |> Enum.map(fn pass ->
      String.replace(pass, "\n", " ")
    end)
    |> Enum.map(fn pass ->
      String.split(pass, " ", trim: true)
    end)
    |> Enum.map(fn pass ->
      valid(pass)
    end)
    |> Enum.count(fn valid ->
      valid == true
    end)
  end

  @doc """
      iex> inp = Aoc.Day4.input("priv/day4/valids.txt")
      ...> Aoc.Day4.part2(inp)
      4

      iex> inp = Aoc.Day4.input("priv/day4/invalids.txt")
      ...> Aoc.Day4.part2(inp)
      0
  """
  def part2(inp) do
    inp
    |> Enum.map(fn pass ->
      String.replace(pass, "\n", " ")
    end)
    |> Enum.map(fn pass ->
      String.split(pass, " ", trim: true)
    end)
    |> Enum.map(fn pass ->
      valid2(pass)
    end)
    |> Enum.count(fn valid ->
      valid == true
    end)
  end

  @doc """
      iex> Aoc.Day4.valid(["ecl:gry", "pid:860033327", "eyr:2020", "hcl:#fffffd", "byr:1937", "iyr:2017", "cid:147", "hgt:183cm"])
      true

      iex> Aoc.Day4.valid(["ecl:gry"])
      false
  """
  def valid(pass) do
    fields =
      pass
      |> Enum.map(fn field ->
        String.split(field, ":")
      end)

    valid_fields(fields)
  end

  def valid2(pass) do
    fields =
      pass
      |> Enum.map(fn field ->
        String.split(field, ":")
      end)
      # |> IO.inspect

    if valid_fields(fields) do
      byr = Enum.at(Enum.find(fields, fn field -> Enum.at(field, 0) == "byr" end), 1)
      iyr = Enum.at(Enum.find(fields, fn field -> Enum.at(field, 0) == "iyr" end), 1)
      eyr = Enum.at(Enum.find(fields, fn field -> Enum.at(field, 0) == "eyr" end), 1)
      hgt = Enum.at(Enum.find(fields, fn field -> Enum.at(field, 0) == "hgt" end), 1)
      hcl = Enum.at(Enum.find(fields, fn field -> Enum.at(field, 0) == "hcl" end), 1)
      ecl = Enum.at(Enum.find(fields, fn field -> Enum.at(field, 0) == "ecl" end), 1)
      pid = Enum.at(Enum.find(fields, fn field -> Enum.at(field, 0) == "pid" end), 1)

      valid_byr(byr) &&
      valid_iyr(iyr) &&
      valid_eyr(eyr) &&
      valid_hgt(hgt) &&
      valid_hcl(hcl) &&
      valid_ecl(ecl) &&
      valid_pid(pid)
    end
  end

  def valid_fields(fields) do
    fields
    |> Enum.map(fn field ->
      Enum.at(field, 0)
    end)
    |> Kernel.--(@ignore)
    |> Enum.count()
    |> Kernel.==(8 - Enum.count(@ignore))
  end

  @doc """
      iex> Aoc.Day4.valid_byr("2003")
      false

      iex> Aoc.Day4.valid_byr("1919")
      false

      iex> Aoc.Day4.valid_byr("19201")
      false

      iex> Aoc.Day4.valid_byr("1954")
      true
  """
  def valid_byr(byr) do
    valid_digits =
      byr
      |> String.graphemes
      |> Enum.count
      |> Kernel.==(4)

    value = String.to_integer(byr)

    value >= 1920 && value <=2002 && valid_digits
  end

  def valid_iyr(iyr) do
    valid_digits =
      iyr
      |> String.graphemes
      |> Enum.count
      |> Kernel.==(4)

    value = String.to_integer(iyr)

    value >= 2010 && value <= 2020 && valid_digits
  end

  def valid_eyr(eyr) do
    valid_digits =
      eyr
      |> String.graphemes
      |> Enum.count
      |> Kernel.==(4)

    value = String.to_integer(eyr)

    value >= 2020 && value <= 2030 && valid_digits
  end

  @doc """
      iex> Aoc.Day4.valid_hgt("149cm")
      false

      iex> Aoc.Day4.valid_hgt("194cm")
      false

      iex> Aoc.Day4.valid_hgt("190cm")
      true
  """
  def valid_hgt(hgt) do
    if String.match?(hgt, ~r/(?<value>\d+)cm/) || String.match?(hgt, ~r/(?<value>\d+)in/) do
      if String.contains?(hgt, "cm") do
        value =
          Regex.named_captures(~r/(?<value>\d+)cm/, hgt)
          |> Map.get("value")
          |> String.to_integer

        value >= 150 && value <= 193
      else
        value =
          Regex.named_captures(~r/(?<value>\d+)in/, hgt)
          |> Map.get("value")
          |> String.to_integer

        value >= 59 && value <= 76
      end
    else
      false
    end
  end

  @doc """
      iex> Aoc.Day4.valid_hcl("149cm")
      false

      iex> Aoc.Day4.valid_hcl("#aaaaaa")
      true
  """
  def valid_hcl(hcl) do
    String.match?(hcl, ~r/^#[a-fA-F0-9]{6}$/)
  end

  def valid_ecl(ecl) do
    Enum.member?(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"], ecl)
  end

  def valid_pid(pid) do
    String.match?(pid, ~r/^[0-9]{9}$/)
  end

  # @doc """
  #     iex> chart = Aoc.Chart.new("priv/day3/example.txt")
  #     ...> Aoc.Day3.part2(chart)
  #     336
  # """
  # def part2(inp) do
  #   [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
  #   |> Enum.map(fn slope ->
  #     Aoc.Day3.part1(inp, slope)
  #   end)
  #   |> Enum.reduce(1, fn value, acc ->
  #     acc * value
  #   end)
  # end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n\n", trim: true)
  end
end
