defmodule Day20 do
  @moduledoc """
  Documentation for Day20.
  """

  def part_1() do
    "priv/input.txt"
    |> input()
    |> part_1()
  end
  
  def part_1(regex) do
    regex
    |> generate()
    |> distance()
    |> Enum.max_by(fn {_string, distance} ->
      distance
    end)
    |> elem(0)
    |> String.length()
  end
  
  def input(filename) do
    File.read!(filename)
  end
  
  @doc """
      iex> Day20.generate("^WNE$")
      ["WNE"]
  
      iex> Day20.generate("^ENWWW(NEEE|SSE(EE|N))$")
      ["ENWWWNEEE", "ENWWWSSEEE", "ENWWWSSEN"]
  """
  def generate(regex) do
    # relen = relen(regex)
    relen =
      String.split(regex, "", trim: true)
      |> Enum.filter(fn char ->
        Enum.member?(["N", "W", "E", "S"], char)
      end)
      |> Enum.count
      |> IO.inspect(label: "len")
  
    ["N", "W", "E", "S"]
    |> Brute.generic(1..relen)
    |> Stream.filter(fn x ->
      Regex.match?(~r/#{regex}/, x)
    end)
    |> Enum.to_list()
    |> Enum.sort()
  end
  
  # @doc """
  #     # iex> Day20.relen("^WNE$")
  #     # 3
  # 
  #     iex> Day20.relen("^ENWWW(NEEE|SSE(EE|N))$")
  #     10
  # """
  # def relen(regex) do
  #   regex
  #   |> String.split("", trim: true)
  #   |> do_relen(0)
  #   |> IO.inspect(label: "length")
  # end
  # 
  # defp do_relen([], acc) do
  #   IO.puts("A")
  #   acc
  # end
  # defp do_relen([last], acc) when last == "$" do
  #   IO.puts("B")
  #   acc
  # end
  # defp do_relen([head | tail], acc) when head == "^" do
  #   IO.puts("C")
  #   do_relen(tail, acc)
  # end
  # defp do_relen([head | tail], acc) when head == "(" do
  #   IO.puts("D")
  #   max =
  #     tail
  #     |> Enum.reduce_while({[], 0}, fn char, {counts, running} ->
  #       case char do
  #         ")" -> {:halt, {counts, 0}}
  #         "|" -> {:cont, {[running | counts], 0}}
  #          _  -> {:cont, {counts, running + 1}}
  #       end
  #     end)
  #     |> elem(0)
  #     |> Enum.max()
  #   do_relen(tail, acc + max)
  # end
  # defp do_relen([head | tail], acc) do
  #   IO.puts("E")
  #   do_relen(tail, acc + 1)
  # end
  
  @doc """
      iex> Day20.distance(["WNE", "ENWWWNEEE"])
      [{"WNE", 1}, {"ENWWWNEEE", 3}]
  """
  def distance(strings) when is_list(strings) do
    strings
    |> Enum.map(fn string ->
      {string, distance(string)}
    end)
  end
  
  @doc """
      iex> Day20.distance("WNE")
      1
      
      iex> Day20.distance("ENWWWNEEE")
      3
      
      iex> Day20.distance("ENWWWSSEEE")
      2
      
      iex> Day20.distance("ENWWWSSEN")
      1
      
      iex> Day20.distance("ENNWSWWSSSEENEESWEN")
      3
      
      iex> Day20.distance("ENNWSWWSSSEENEENNN")
      4
  """
  def distance(string) do
    destination = 
      string
      |> String.split("", trim: true)
      |> Enum.reduce({0, 0}, fn direction, coords ->
        case direction do
          "N" -> put_elem(coords, 1, elem(coords, 1) - 1)
          "E" -> put_elem(coords, 0, elem(coords, 0) + 1)
          "S" -> put_elem(coords, 1, elem(coords, 1) + 1)
          "W" -> put_elem(coords, 0, elem(coords, 0) - 1)
        end
      end)
    man_dist({0, 0}, destination)
  end
  
  defp man_dist(a, b) do
    abs(elem(a, 0) - elem(b, 0)) + abs(elem(a, 1) - elem(b, 1))
  end
end
