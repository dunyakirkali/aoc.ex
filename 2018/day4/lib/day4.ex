defmodule Day4 do
  @moduledoc """
  Documentation for Day4.
  """

  def parse_date(string) do
    captures = Regex.named_captures(~r/\[(?<year>\d+)-(?<month>\d+)-(?<day>\d+) (?<hour>\d+):(?<minute>\d+)\].*/, string)
    that_day = elem(NaiveDateTime.new(
      String.to_integer(captures["year"]),
      String.to_integer(captures["month"]),
      String.to_integer(captures["day"]),
      String.to_integer(captures["hour"]),
      String.to_integer(captures["minute"]),
      0), 1)
    if that_day.hour == 23 do
      new_day = NaiveDateTime.add(that_day, 86_400, :second)
      {"#{new_day.month}-#{new_day.day}", 0}
    else
      {"#{that_day.month}-#{that_day.day}", that_day.minute}
    end
  end

  def guard_with_most_sleep(hsh) do
    hsh
    |> Enum.sort_by(fn {_, v} ->
      length(elem(v, 1))
    end)
    |> Enum.reduce(%{}, fn {day, data}, acc ->
      guard_no = elem(data, 0)
      sleeps = length(elem(data, 1))
      Map.update(acc, guard_no, 0, &(&1 + sleeps))
    end)
    |> Enum.max_by(fn {k, v} ->
      v
    end)
    |> elem(0)
  end

  def favorite_time(hsh, guard) do
    hsh
    |> Enum.filter(fn {_, v} ->
      elem(v, 0) == guard
    end)
    |> Enum.map(fn {_, v} ->
      MapSet.new(elem(v, 1))
    end)
    |> Enum.reduce(%{}, fn list, acc ->
      Enum.reduce(list, acc, fn x, acc ->
        Map.update(acc, x, 0, &(&1 + 1))
      end)
    end)
    |> Enum.max_by(fn {k, v} ->
      v
    end)
    |> elem(0)
  end

  def transcode(input) do
    input
    |> String.trim
    |> String.split("\n")
    |> Enum.sort
    |> Enum.reduce(%{}, fn x, acc ->
      date = elem(parse_date(x), 0)
      minute = elem(parse_date(x), 1)

      cond do
        Regex.match?(~r/begins shift/, x) ->

          captures = Regex.named_captures(~r/.*Guard #(?<no>\d+) begins shift/, x)
          guard_no = String.to_integer(captures["no"])

          Map.put(acc, date, {guard_no, []})

        Regex.match?(~r/falls asleep/, x) ->

          Map.update!(acc, date, fn {guard_no, minutes} ->
            {guard_no, [minute | minutes] |> Enum.sort}
          end)

        true ->

          old_data = Map.get(acc, date)
          last_minute = List.last(elem(old_data, 1))
          range = (last_minute + 1)..(minute - 1)
          Enum.reduce(range, acc, fn x, acc ->
            Map.update!(acc, date, fn {guard_no, minutes} ->
              {guard_no, [x | minutes] |> Enum.sort}
            end)
          end)
      end
    end)
  end

  def strategy_1(hsh) do
    guard = guard_with_most_sleep(hsh)
    fav = favorite_time(hsh, guard)
    guard * fav
  end

  def strategy_2(hsh) do
    {guard, fav} = most_frequent(hsh)
    guard * fav
  end

  def most_frequent(hsh) do
    {guard_no, {minute, count}} = hsh
    |> Enum.reduce(%{}, fn {day, {guard_no, list}}, acc ->
      Map.update(acc, guard_no, [], &(&1 ++ list))
    end)
    |> Enum.map(fn {guard_no, list} ->
      freqs = Enum.reduce(list, %{}, fn x, c -> Map.update(c, x, 1, &(&1 + 1)) end)
      if map_size(freqs) > 0 do
        {guard_no, Enum.max_by(freqs, fn {k, v} -> v end)}
      else
        {guard_no, {0, 0}}
      end
    end)
    |> Enum.max_by(fn {guard_no, {minute, count}} ->
      count
    end)

    {guard_no, minute}
  end

  def part_1(input) do
    transcode(input)
    |> strategy_1
  end

  def part_2(input) do
    transcode(input)
    |> strategy_2
  end
end
