defmodule Aoc.Day24 do
  @doc """
      # iex> input = Aoc.Day24.input("priv/day24/example3.txt")
      # ...> Aoc.Day24.part1(input)
      # 39
  """
  def part1(input) do
    [93_499_629_698_999]
    |> Enum.reduce_while([], fn uis, acc ->
      ui =
        uis
        |> Integer.to_string()
        |> String.pad_leading(14, "0")
        |> String.graphemes()
        |> Enum.map(&String.to_integer/1)

      result =
        input
        |> Enum.reduce(%{w: 0, x: 0, y: 0, z: 0, ui: ui}, fn command, machine ->
          # IO.inspect(command)
          case command do
            {:inp, reg} ->
              # Map.get(machine, :ui) |> IO.inspect()
              # |> IO.inspect()
              {val, ui} = List.pop_at(Map.get(machine, :ui), 0)
              machine |> Map.put(:ui, ui) |> Map.put(reg, val)

            {:add, reg, reg_or_val} ->
              add(machine, reg, reg_or_val)

            {:mul, reg, reg_or_val} ->
              mul(machine, reg, reg_or_val)

            {:div, reg, reg_or_val} ->
              div(machine, reg, reg_or_val)

            {:mod, reg, reg_or_val} ->
              mod(machine, reg, reg_or_val)

            {:eql, reg, reg_or_val} ->
              eql(machine, reg, reg_or_val)
          end
        end)
        |> Map.get(:z)

      if result == 0 do
        {:halt, ui}
      else
        {:cont, :error}
      end
    end)
    |> Integer.undigits()
  end

  @doc """
      # iex> input = Aoc.Day24.input("priv/day24/example3.txt")
      # ...> Aoc.Day24.part2(input)
      # 2758514936282435
  """
  def part2(input) do
    [11_164_118_121_471]
    |> Enum.reduce_while([], fn uis, acc ->
      ui =
        uis
        |> Integer.to_string()
        |> String.pad_leading(14, "0")
        |> String.graphemes()
        |> Enum.map(&String.to_integer/1)

      result =
        input
        |> Enum.reduce(%{w: 0, x: 0, y: 0, z: 0, ui: ui}, fn command, machine ->
          # IO.inspect(command)
          case command do
            {:inp, reg} ->
              # Map.get(machine, :ui) |> IO.inspect()
              # |> IO.inspect()
              {val, ui} = List.pop_at(Map.get(machine, :ui), 0)
              machine |> Map.put(:ui, ui) |> Map.put(reg, val)

            {:add, reg, reg_or_val} ->
              add(machine, reg, reg_or_val)

            {:mul, reg, reg_or_val} ->
              mul(machine, reg, reg_or_val)

            {:div, reg, reg_or_val} ->
              div(machine, reg, reg_or_val)

            {:mod, reg, reg_or_val} ->
              mod(machine, reg, reg_or_val)

            {:eql, reg, reg_or_val} ->
              eql(machine, reg, reg_or_val)
          end
        end)
        |> Map.get(:z)

      if result == 0 do
        {:halt, ui}
      else
        {:cont, :error}
      end
    end)
    |> Integer.undigits()
  end

  def value(machine, :w), do: Map.get(machine, :w)
  def value(machine, :x), do: Map.get(machine, :x)
  def value(machine, :y), do: Map.get(machine, :y)
  def value(machine, :z), do: Map.get(machine, :z)
  def value(_, a) when is_integer(a), do: a

  def add(machine, l, r) do
    a = Map.get(machine, l)
    b = value(machine, r)
    Map.put(machine, l, a + b)
  end

  def mul(machine, l, r) do
    a = Map.get(machine, l)
    b = value(machine, r)
    Map.put(machine, l, a * b)
  end

  def div(machine, l, r) do
    a = Map.get(machine, l)
    b = value(machine, r)
    Map.put(machine, l, div(a, b))
  end

  def mod(machine, l, r) do
    a = Map.get(machine, l)
    b = value(machine, r)
    Map.put(machine, l, rem(a, b))
  end

  def eql(machine, l, r) do
    a = Map.get(machine, l)
    b = value(machine, r)

    if a == b do
      Map.put(machine, l, 1)
    else
      Map.put(machine, l, 0)
    end
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      case line do
        <<"inp", " ", register::binary-size(1)>> ->
          {:inp, String.to_atom(register)}

        <<"add", " ", register::binary-size(1), " ", rest::binary>> ->
          rest =
            case Integer.parse(rest) do
              :error -> String.to_atom(rest)
              {reg_or_val, _} -> reg_or_val
            end

          {:add, String.to_atom(register), rest}

        <<"mul", " ", register::binary-size(1), " ", rest::binary>> ->
          rest =
            case Integer.parse(rest) do
              :error -> String.to_atom(rest)
              {reg_or_val, _} -> reg_or_val
            end

          {:mul, String.to_atom(register), rest}

        <<"div", " ", register::binary-size(1), " ", rest::binary>> ->
          rest =
            case Integer.parse(rest) do
              :error -> String.to_atom(rest)
              {reg_or_val, _} -> reg_or_val
            end

          {:div, String.to_atom(register), rest}

        <<"mod", " ", register::binary-size(1), " ", rest::binary>> ->
          rest =
            case Integer.parse(rest) do
              :error -> String.to_atom(rest)
              {reg_or_val, _} -> reg_or_val
            end

          {:mod, String.to_atom(register), rest}

        <<"eql", " ", register::binary-size(1), " ", rest::binary>> ->
          rest =
            case Integer.parse(rest) do
              :error -> String.to_atom(rest)
              {reg_or_val, _} -> reg_or_val
            end

          {:eql, String.to_atom(register), rest}
      end
    end)
  end
end
