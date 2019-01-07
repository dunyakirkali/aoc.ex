defmodule Day4 do
  @moduledoc """
  Documentation for Day4.
  """
  
  def part_2(rooms) do
    rooms
    |> Enum.filter(fn room -> is_real?(room) end)
    |> Enum.map(fn room ->
      shift(room)
    end)
    |> Enum.find(fn {_, name} -> name == "northpole-object-storage" end)
    |> elem(0)
  end

  @doc """
      iex> Day4.part_1([
      ...>   "aaaaa-bbb-z-y-x-123[abxyz]",
      ...>   "a-b-c-d-e-f-g-h-987[abcde]",
      ...>   "not-a-real-room-404[oarel]",
      ...>   "totally-real-room-200[decoy]"
      ...> ])
      1514
  """
  def part_1(rooms) do
    rooms
    |> Enum.filter(fn room -> is_real?(room) end)
    |> Enum.map(fn room -> sector_id(room) end)
    |> Enum.sum()
  end
  
  @doc """
      iex> Day4.shift("qzmt-zixmtkozy-ivhz-343[abxyz]")
      {343, "very-encrypted-name"}
  """
  def shift(room) do
    shift_amount =
      room
      |> sector_id()
      |> Kernel.rem(26)
    
    real_name = 
      room
      |> name()
      |> String.to_charlist()
      |> Enum.map(fn codepoint ->
        if codepoint == 45 do
          codepoint
        else
          rem((codepoint - ?a) + shift_amount, 26) + ?a      
        end
      end)
      |> to_string()
    
    {sector_id(room), real_name}
  end

  def is_real?(room) do
    checksum =
      room
      |> stats()
      |> do_check("")

    checksum == checksum(room)
  end

  def do_check(stats, acc) do
    if String.length(acc) == 5 do
      acc
    else
      first_stat = List.first(stats)

      {item, rest} =
        first_stat
        |> elem(1)
        |> List.pop_at(0)

      stats =
        if length(rest) == 0 do
          List.delete_at(stats, 0)
        else
          List.replace_at(stats, 0, {elem(first_stat, 0), rest})
        end

      do_check(stats, acc <> item)
    end
  end

  def stats(room) do
    room
    |> name()
    |> String.replace("-", "")
    |> String.graphemes()
    |> Enum.reduce(%{}, fn char, acc ->
      Map.put(acc, char, (acc[char] || 0) + 1)
    end)
    |> Enum.group_by(
      fn {_, v} ->
        v
      end,
      fn {k, _} ->
        k
      end
    )
    |> Enum.reverse()
  end

  @doc """
      iex> Day4.name("aaaaa-bbb-z-y-x-123[abxyz]")
      "aaaaa-bbb-z-y-x"
      
      iex> Day4.name("totally-real-room-200[decoy]")
      "totally-real-room"
  """
  def name(room) do
    room
    |> parse()
    |> Map.get("name")
  end

  @doc """
      iex> Day4.sector_id("aaaaa-bbb-z-y-x-123[abxyz]")
      123
      
      iex> Day4.sector_id("totally-real-room-200[decoy]")
      200
  """
  def sector_id(room) do
    room
    |> parse()
    |> Map.get("sector_id")
    |> String.to_integer()
  end

  @doc """
      iex> Day4.checksum("aaaaa-bbb-z-y-x-123[abxyz]")
      "abxyz"
      
      iex> Day4.checksum("totally-real-room-200[decoy]")
      "decoy"
  """
  def checksum(room) do
    room
    |> parse()
    |> Map.get("cecksum")
  end

  @doc """
      iex> Day4.parse("aaaaa-bbb-z-y-x-123[abxyz]")
      %{"cecksum" => "abxyz", "name" => "aaaaa-bbb-z-y-x", "sector_id" => "123"}
  """
  def parse(room) do
    Regex.named_captures(~r/(?<name>.*)-(?<sector_id>\d+)\[(?<cecksum>.*)\]/, room)
  end
end
