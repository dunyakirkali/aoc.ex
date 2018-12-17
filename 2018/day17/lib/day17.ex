defmodule Day17 do
  import NimbleParsec

  @moduledoc """
  Documentation for Day17.
  """
  
  @doc """
      iex> map = Day17.generate_map("priv/example.txt")
      ...> Day17.tick(map, {500, 0}, :flow)
      []
  """
  def tick(map, pos, action) do
    maxY = Map.keys(map) |> Enum.map(fn x -> elem(x, 1) end) |> Enum.max()
    y = elem(pos, 1)
    
    if y == maxY do
      Enum.filter(map, fn {key, val} ->
        ["~", "|"]
        |> Enum.member?(val)
      end)
      |> Enum.count
    else
      case action do
        :flow ->
          next_pos = {elem(pos, 0), elem(pos, 1) + 1}
          case map[next_pos] do
            nil ->
              map = Map.put(map, next_pos, "|")
              print_game(map)
              tick(map, next_pos, :flow)
            "#" ->
              map = Map.put(map, pos, "~")
              print_game(map)
              tick(map, pos, :fill)
          end
        :fill ->
          left =
            1..500
            |> Enum.reduce_while(0, fn i, acc -> 
              next_pos = {elem(pos, 0) - i, elem(pos, 1)}
              next_pos_floor = {elem(pos, 0) - i, elem(pos, 1) + 1}
              if map[next_pos] == "#" do
                if Enum.member?(["#", "~"], map[next_pos_floor]) do
                  {:halt, -1 * (i - 1)}
                else
                  IO.puts("TODO - A")
                end
              else
                if Enum.member?(["#", "~"], map[next_pos_floor]) do
                  {:cont, i}
                else
                  {:halt, 1}
                end
              end
            end)
          
          right = 
            1..500
            |> Enum.reduce_while(0, fn i, acc -> 
              next_pos = {elem(pos, 0) + i, elem(pos, 1)}
              next_pos_floor = {elem(pos, 0) + i, elem(pos, 1) + 1}
              if map[next_pos] == "#" do
                if Enum.member?(["#", "~"], map[next_pos_floor]) do
                  {:halt, i - 1}
                else
                  IO.puts("TODO - C")
                end
              else
                if Enum.member?(["#", "~"], map[next_pos_floor]) do
                  {:cont, i}
                else
                  {:halt, -1}
                end
              end
            end)
          
          
          map =
            cond do
              left > 0 && right < 0 ->
                IO.puts("TODO")
              left <= 0 && right < 0 ->
                {map, next_pos} = left..999
                |> Enum.reduce_while({map, pos}, fn x, {map, _} ->
                  next_pos_floor = {elem(pos, 0) + x, elem(pos, 1) + 1}
                  if Enum.member?(["#", "~"], map[next_pos_floor]) do
                    {:cont, {Map.put(map, {elem(pos, 0) + x, elem(pos, 1)}, "|"), pos}}
                  else
                    {:halt, {Map.put(map, {elem(pos, 0) + x, elem(pos, 1)}, "|"), {elem(pos, 0) + x, elem(pos, 1)}}}
                  end 
                end)
                print_game(map)
                tick(map, next_pos, :flow)
                
              left <= 0 && right >= 0 ->
                map = left..right
                |> Enum.reduce(map, fn x, map ->
                  Map.put(map, {elem(pos, 0) + x, elem(pos, 1)}, "~")
                end)
                print_game(map)
                tick(map, {elem(pos, 0), elem(pos, 1) - 1}, :fill)
            end
      end
    end
  end
  
  # def next(map, pos) do
  #   next_pos = {elem(pos, 0), elem(pos, 1) + 1}
  #   case map[next_pos] do
  #     nil -> {Map.put(map, next_pos, "|"), next_pos}
  #     "#" -> fill(map, pos)
  #   end
  # end
  # 
  # def fill(map, pos) do
  #   next_pos = {elem(pos, 0) - 1, elem(pos, 1)}
  #   next_pos_floor = {elem(pos, 0) - 1, elem(pos, 1) + 1}
  #   if map[next_pos_floor] == "#" do
  #     if map[next_pos] == "#" do
  #       map
  #     else
  #       map = Map.put(map, next_pos, "~")
  #       fill(map, next_pos)
  #     end
  #   else
  #     map
  #   end
  # end

  @doc """
      iex> map = Day17.generate_map("priv/example.txt")
      ...> Day17.rains(map)
      []
  """
  def rains(map) do
    map
    |> Enum.filter(fn {key, val} -> val == "|" end)
  end
    
  @doc """
      iex> map = Day17.generate_map("priv/example.txt")
      ...> Day17.stills(map)
      []
  """
  def stills(map) do
    map
    |> Enum.filter(fn {key, val} -> val == "~" end)
  end
  
  @doc """
      iex> map = Day17.generate_map("priv/example.txt")
      ...> Day17.source(map)
      {500, 0}
  """
  def source(map) do
    map
    |> Enum.find(fn {key, val} -> val == "+" end)
    |> elem(0)
  end

  @doc """
      iex> map = Day17.generate_map("priv/example.txt")
      ...> map[{495, 1}]
      nil
      ...> map[{495, 2}]
      "#"
      ...> map[{0, 123}]
      "#"
      ...> map[{0, 124}]
      nil
      ...> map[{24, 123}]
      nil
      ...> map[{500, 0}]
      "+"
  """
  def generate_map(filename) do
    filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.reduce(%{}, fn line, acc ->
        case slit_x(line) do
          {:ok, list, _, _, _, _} ->
            # X
            x = Enum.at(list, 0)
            # Y
            Enum.at(list, 1)..Enum.at(list, 2)
            |> Enum.reduce(acc, fn y, acc ->
              Map.put(acc, {x, y}, "#")
            end)
            
          {:error, _, _, _, _, _} ->
            case slit_y(line) do
              {:ok, list, _, _, _, _} ->
                # Y
                y = Enum.at(list, 0)
                # X
                Enum.at(list, 1)..Enum.at(list, 2)
                |> Enum.reduce(acc, fn x, acc ->
                  Map.put(acc, {x, y}, "#")
                end)
              {:error, _, _, _, _} ->
                IO.puts("WAT")
            end
        end
    end)
    |> Map.put({500, 0}, "+")
  end
  
  defp print_game(map) do
    # IO.ANSI.clear()

    xses = Map.keys(map) |> Enum.map(fn x -> elem(x, 0) end)
    maxX = Enum.max(xses) + 5
    minX = Enum.min(xses) - 5
    maxY = Map.keys(map) |> Enum.map(fn x -> elem(x, 1) end) |> Enum.max()

    Enum.each(Range.new(0, maxY), fn y ->
      Enum.map(Range.new(minX, maxX), fn x ->
        p = {x, y}

        # u = Enum.find(units, fn {_u, unit} -> unit.position == p end)

        cond do
          is_nil(map[p]) -> "."
          true -> map[p]
        end
      end)
      |> Enum.join("")
      |> IO.puts()
    end)
  end
  
  defparsec(
    :slit_x,
    ignore(string("x="))
    |> integer(min: 1)
    |> ignore(string(", y="))
    |> integer(min: 1)
    |> ignore(string(".."))
    |> integer(min: 1)
  )
  
  defparsec(
    :slit_y,
    ignore(string("y="))
    |> integer(min: 1)
    |> ignore(string(", x="))
    |> integer(min: 1)
    |> ignore(string(".."))
    |> integer(min: 1)
  )
end
