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

    if valid_fields(fields) do
      map = Map.new(fields, fn [k, v] -> {k, v} end)

      valid_byr(Map.get(map, "byr")) &&
      valid_iyr(Map.get(map, "iyr")) &&
      valid_eyr(Map.get(map, "eyr")) &&
      valid_hgt(Map.get(map, "hgt")) &&
      valid_hcl(Map.get(map, "hcl")) &&
      valid_ecl(Map.get(map, "ecl")) &&
      valid_pid(Map.get(map, "pid"))
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

  @doc """
      iex> Aoc.Day4.valid_iyr("2021")
      false

      iex> Aoc.Day4.valid_iyr("1919")
      false

      iex> Aoc.Day4.valid_iyr("19201")
      false

      iex> Aoc.Day4.valid_iyr("2011")
      true
  """
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

  @doc """
      iex> Aoc.Day4.valid_ecl("asd")
      false

      iex> Aoc.Day4.valid_ecl("gry")
      true
  """
  def valid_ecl(ecl) do
    Enum.member?(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"], ecl)
  end

  @doc """
      iex> Aoc.Day4.valid_pid("149cm")
      false

      iex> Aoc.Day4.valid_pid("#aaaaaa")
      false

      iex> Aoc.Day4.valid_pid("123")
      false

      iex> Aoc.Day4.valid_pid("1234567890")
      false

      iex> Aoc.Day4.valid_pid("123456789")
      true
  """
  def valid_pid(pid) do
    String.match?(pid, ~r/^[0-9]{9}$/)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n\n", trim: true)
  end
end
