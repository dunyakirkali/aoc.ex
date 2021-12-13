defmodule Aoc.Day12 do
  defmodule Vector do
    defstruct [x: 0, y: 0, z: 0]
  end

  defmodule Moon do
    defstruct [:pos, vel: %Vector{}]
  end

  def gcd(a, 0), do: a
  def gcd(0, b), do: b
  def gcd(a, b), do: gcd(b, rem(a, b))

  def lcm(0, 0), do: 0
  def lcm(a, b), do: div(a * b, gcd(a, b))

  defimpl Inspect, for: Moon do
    def inspect(moon, _) do
      "pos=<x=#{moon.pos.x}, y=#{moon.pos.y}, z=#{moon.pos.z}>, vel=<x=#{moon.vel.x}, y=#{moon.vel.y}, z=#{moon.vel.z}>"
    end
  end

  def pmap(collection, func) do
    collection
    |> Enum.map(&(Task.async(fn -> func.(&1) end)))
    |> Enum.map(&Task.await/1)
  end

  @doc """
      iex> Aoc.Day12.part1("priv/day12/example_1.txt", 10)
      179

      iex> Aoc.Day12.part1("priv/day12/example_2.txt", 100)
      1940
  """
  def part1(filename, steps) do
    moons = input(filename)

    1..steps
    |> Enum.reduce(moons, fn _, moons ->
      0..(Enum.count(moons) - 1)
      |> Combination.combine(2)
      |> Enum.reduce(moons, fn [m1i, m2i], moons ->
        m1 = Enum.at(moons, m1i)
        m2 = Enum.at(moons, m2i)

        {m1, m2} = grvity(m1, m2)

        moons
        |> List.replace_at(m1i, m1)
        |> List.replace_at(m2i, m2)
      end)
      |> Enum.map(fn moon ->
        apply_velocity(moon)
      end)
    end)
    |> total_energy
  end

  @doc """
      iex> Aoc.Day12.potential_energy(%Aoc.Day12.Moon{pos: %Aoc.Day12.Vector{x: 1, y: -8, z: 0}, vel: %Aoc.Day12.Vector{x: 1, y: -1, z: 0}})
      9
  """
  def potential_energy(moon) do
    abs(moon.pos.x) + abs(moon.pos.y) + abs(moon.pos.z)
  end

  @doc """
      iex> Aoc.Day12.kinetic_energy(%Aoc.Day12.Moon{pos: %Aoc.Day12.Vector{x: 1, y: -8, z: 0}, vel: %Aoc.Day12.Vector{x: -1, y: 1, z: 3}})
      5
  """
  def kinetic_energy(moon) do
    abs(moon.vel.x) + abs(moon.vel.y) + abs(moon.vel.z)
  end

  def total_energy(moons) do
    moons
    |> Enum.map(fn moon ->
      potential_energy(moon) * kinetic_energy(moon)
    end)
    |> Enum.sum
  end

  def grvity(m1, m2) do
    [:x, :y, :z]
    |> Enum.reduce({m1, m2}, fn dim, {m1, m2} ->
      cond do
        Map.get(m1.pos, dim) == Map.get(m2.pos, dim) ->
          {%Moon{m1 | vel: m1.vel}, %Moon{m2 | vel: m2.vel}}
        Map.get(m1.pos, dim) < Map.get(m2.pos, dim) ->
          {%Moon{m1 | vel: Map.update!(m1.vel, dim, &(&1 + 1))}, %Moon{m2 | vel: Map.update!(m2.vel, dim, &(&1 - 1))}}
        Map.get(m1.pos, dim) > Map.get(m2.pos, dim) ->
          {%Moon{m1 | vel: Map.update!(m1.vel, dim, &(&1 - 1))}, %Moon{m2 | vel: Map.update!(m2.vel, dim, &(&1 + 1))}}
      end
    end)
  end

  @doc """
      iex> Aoc.Day12.apply_velocity(%Aoc.Day12.Moon{pos: %Aoc.Day12.Vector{x: 0, y: 0, z: 0}, vel: %Aoc.Day12.Vector{x: 1, y: -1, z: 0}})
      %Aoc.Day12.Moon{pos: %Aoc.Day12.Vector{x: 1, y: -1, z: 0}, vel: %Aoc.Day12.Vector{x: 1, y: -1, z: 0}}
  """
  def apply_velocity(moon) do
    mv = moon.vel
    ps = moon.pos

    %Moon{moon | pos: %Vector{x: ps.x + mv.x, y: ps.y + mv.y, z: ps.z + mv.z}, vel: mv}
  end

  def part2(filename) do
    moons = input(filename)

    nx = find_period(moons, :x)
    ny = find_period(moons, :y)
    nz = find_period(moons, :z)

    lcm(nx, lcm(ny, nz))
  end

  def find_period(moons, dim) do
    se =
      moons
      |> pmap(fn moon ->
        Map.get(moon.pos, dim)
      end)
      |> Enum.join(",")

    0
    |> Stream.iterate(&(&1 + 1))
    |> Enum.reduce_while({moons, [se]}, fn i, {moons, xes} ->
      moons =
        0..(Enum.count(moons) - 1)
        |> Combination.combine(2)
        |> Enum.reduce(moons, fn [m1i, m2i], moons ->
          m1 = Enum.at(moons, m1i)
          m2 = Enum.at(moons, m2i)

          {m1, m2} = grvity(m1, m2)

          moons
          |> List.replace_at(m1i, m1)
          |> List.replace_at(m2i, m2)
        end)
        |> pmap(fn moon ->
          apply_velocity(moon)
        end)

      te =
        moons
        |> pmap(fn moon ->
          Map.get(moon.pos, dim)
        end)
        |> Enum.join(",")

      if List.first(xes) == te do
        {:halt, i + 2}
      else
        {:cont, {moons, xes ++ [te]}}
      end
    end)
  end

  defp input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn x ->
      Regex.named_captures(~r/<x=(?<x>.+), y=(?<y>.+), z=(?<z>.+)>/, x)
      |> Enum.reduce(%Vector{}, fn {dim, val}, acc ->
        Map.put(acc, String.to_atom(dim), String.to_integer(val))
      end)
    end)
    |> Enum.map(fn pos ->
      %Moon{pos: pos}
    end)
  end
end
