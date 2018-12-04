defmodule Day4 do
  @moduledoc """
  Documentation for Day4.
  """

  @doc """
  Converts date to minute
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
      {"#{that_day.month}-#{that_day.day}", String.to_integer(captures["minute"])}
    end
  end

  @doc """
  Get guard with most sleep
  """
  def guard_with_most_sleep(hsh) do
    hsh
    |> Enum.map(fn {_, v} ->
      {elem(v, 0), length(elem(v, 1))}
    end)
    |> Enum.max_by(fn {_, v} ->
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

  @doc """
  Transcode
  """
  def transcode(input) do
    sorted_data = input
    |> String.trim
    |> String.split("\n")
    |> Enum.sort_by(fn x ->
      captures = Regex.named_captures(~r/\[(?<date>.*)\].*/, x)
      captures["date"]
    end)

    sorted_data
    |> Enum.reduce(%{}, fn x, acc ->
      date = parse_date(x)
      cond do
        Regex.match?(~r/begins shift/, x) ->

          captures = Regex.named_captures(~r/.*Guard #(?<no>\d+) begins shift/, x)

          Map.put(acc, elem(date, 0), {String.to_integer(captures["no"]), []})

        Regex.match?(~r/falls asleep/, x) ->

          minute = elem(date, 1)
          old_data = Map.get(acc, elem(date, 0))
          new_list = elem(old_data, 1) ++ [minute]
          updated_date = {elem(old_data, 0), new_list}

          Map.put(acc, elem(date, 0), updated_date)

        true ->

          minute = elem(date, 1)
          old_data = Map.get(acc, elem(date, 0))
          last_minute = List.last(elem(old_data, 1))
          Enum.reduce((last_minute + 1)..(minute - 1), acc, fn x, acc ->
            old_data = Map.get(acc, elem(date, 0))
            new_list = elem(old_data, 1) ++ [x]
            updated_date = {elem(old_data, 0), new_list}

            Map.put(acc, elem(date, 0), updated_date)
          end)
      end
    end)
  end

  @doc """
  Strategy 1
  """
  def strategy_1(hsh) do
    guard = guard_with_most_sleep(hsh) |> IO.inspect(label: "guard")
    fav = favorite_time(hsh, guard) |> IO.inspect(label: "fav")
    guard * fav
  end

  @doc """
  Strategy 2
  """
  def strategy_2(hsh) do
    {guard, fav} = most_frequent(hsh)
    guard * fav
  end

  def most_frequent(hsh) do
    guards_per_minute = hsh
    |> Enum.reduce(%{}, fn {k, v}, acc ->
      guard = elem(v, 0)
      Enum.reduce(0..59, acc, fn i, acc ->
        list = elem(v, 1)
        if Enum.member?(list, i) do
          if Map.get(acc, i) == nil do
            Map.put(acc, i, [guard])
          else
            added = Map.get(acc, i) ++ [guard]
            Map.put(acc, i, added)
          end
        else
          acc
        end
      end)
    end)
    |> Enum.max_by(fn {k, v} ->
      length(v)
    end)

    guard = elem(guards_per_minute, 1)
    |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
    |> Enum.max_by(fn {k, v} ->
      k
    end)
    |> elem(0)
    |> IO.inspect(label: "Guard")

    guards_per_minute |> IO.inspect(label: "Minute")
    {guard, elem(guards_per_minute, 0)}
  end

  @doc """
  Part 1
  """
  def part_1(input) do
    transcode(input)
    |> strategy_1
  end

  @doc """
  Part 2
  """
  def part_2(input) do
    transcode(input)
    |> strategy_2
  end
end
