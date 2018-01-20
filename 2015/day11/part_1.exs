alpha = for n <- ?a..?z, do: << n :: utf8 >>

tris = alpha
  |> Enum.chunk_every(3, 1, :discard)
  |> Enum.map(&Enum.join/1)
  |> IO.inspect

nonos = ["i", "o", "l"]
  |> IO.inspect

dubs = alpha
  |> Enum.map(fn(x) ->
    x <> x
  end)
  |> IO.inspect

defmodule StrNext do
  @character_ranges [
    {'a', 'z'}
  ]
  @characters Enum.map(@character_ranges, fn {a, z} ->
                hd(a)..hd(z)
                |> Enum.to_list()
              end)
              |> List.flatten()

  def next(str) do
    String.reverse(str)
    |> next_string()
    |> String.reverse()
  end

  def next_string(""), do: <<hd(@characters)>>

  def next_string(<<byte, rest::bitstring>>) do
    case next_character(byte) do
      {c, true} -> <<c>> <> next_string(rest)
      {c, false} -> <<c>> <> rest
    end
  end

  def next_character(c) when c in @characters do
    if (c + 1) in @characters do
      {c + 1, false}
    else
      index = Enum.find_index(@characters, &(&1 == c))

      if c = Enum.at(@characters, index + 1) do
        {c, false}
      else
        {hd(@characters), true}
      end
    end
  end

  def next_character(c) do
    {c, true}
  end
end
  
defmodule Solver do
  def increment(str) do
    ns = StrNext.next(str)
    IO.puts ns
    ns
  end
  
  def solve(pass, tris, nonos, dubs) do
    contains_tris = tris
      |> Enum.map(fn(tri) ->
        pass =~ tri
      end)
      |> Enum.reduce(false, fn(co, acc) ->
        acc || co
      end)
    
    contains_nono = nonos
      |> Enum.map(fn(nono) ->
        pass =~ nono
      end)
      |> Enum.reduce(false, fn(co, acc) ->
        acc || co
      end)
    
    contains_dubs = dubs
      |> Enum.with_index
      |> Enum.map(fn({dub, index}) ->
        List.delete_at(dubs, index)
          |> Enum.map(fn(dub_two) ->
            pass =~ dub && pass =~ dub_two
          end)
      end)
      |> List.flatten
      |> Enum.reduce(false, fn(co, acc) ->
        acc || co
      end)

    if contains_tris && !contains_nono && contains_dubs do
      pass
    else
      increment(pass)
        |> Solver.solve(tris, nonos, dubs)
    end 
  end
end

Solver.solve("hepxcrrq", tris, nonos, dubs)
  |> IO.inspect
