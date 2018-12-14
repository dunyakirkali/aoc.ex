defmodule Day13 do
  use Memoize

  @moduledoc """
  Documentation for Day13.
  """
  
  # def part_2(filename) do
  #   map = map(filename)
  #   carts = parse_carts(map)
  # 
  #   0..100_000_000
  #   |> Enum.reduce_while(carts, fn iteration, carts ->
  #     IO.inspect(iteration, label: "Iteration")
  #     carts = tick(carts, filename)
  # 
  #     if collision(carts) do
  #       {:halt, carts}
  #     else
  #       {:cont, carts}
  #     end
  #   end)
  #   |> IO.inspect
  #   |> Enum.reduce(%{}, fn %{direction: _, position: pos, should_turn: _}, acc ->
  #     Map.update(acc, pos, 1, &(&1 + 1))
  #   end)
  #   |> Enum.max_by(fn {_, count} -> count end)
  #   |> elem(0)
  # end

  def part_1(filename) do
    map = map(filename)
    carts = parse_carts(map)

    0..999_000_000
    |> Enum.reduce_while(carts, fn iteration, carts ->
      IO.inspect(iteration, label: "Iteration")
      carts =
        carts
        |> Enum.sort
        |> tick(filename)
        # IO.inspect(carts, label: "Updated")

      if collision(carts), do: {:halt, carts}, else: {:cont, carts}
    end)
    |> IO.inspect
    |> Enum.reduce(%{}, fn %{direction: _, position: pos, should_turn: _}, acc ->
      Map.update(acc, pos, 1, &(&1 + 1))
    end)
    |> Enum.max_by(fn {_, count} -> count end)
    |> elem(0)
  end

  @doc """
      iex> Day13.collision([%{position: {3, 3}, direction: :n, should_turn: :left}, %{position: {3, 3}, direction: :n, should_turn: :left}])
      true
      
      iex> Day13.collision([%{position: {3, 2}, direction: :n, should_turn: :left}, %{position: {3, 3}, direction: :n, should_turn: :left}])
      false
  """
  def collision(carts) do
    positions = Enum.map(carts, fn cart -> cart[:position] end)
    length(positions) != length(Enum.uniq(positions))
  end

  @doc """
      iex> Day13.tick([%{position: {8, 4}, direction: :n, should_turn: :left}], "priv/example_2.txt")
      [%{position: {8, 3}, direction: :n, should_turn: :left}]

      iex> Day13.tick([%{position: {4, 1}, direction: :s, should_turn: :right}], "priv/example_2.txt")
      [%{position: {4, 2}, direction: :s, should_turn: :right}]
  """
  def tick(carts, filename) when is_list(carts) do
    Enum.map(carts, fn cart ->
      tick(cart, filename)
    end)
  end
  
  def tick(cart, filename) when is_map(cart) do
    case tile(cart[:position], filename) do
      "|" ->
        move(cart)

      "-" ->
        move(cart)

      "/" ->
        cart
        |> Map.update!(:direction, fn old ->
          case old do
            :w -> :s
            :n -> :e
            :e -> :n
            :s -> :w
          end
        end)
        |> move

      "\\" ->
        cart
        |> Map.update!(:direction, fn old ->
          case old do
            :e -> :s
            :s -> :e
            :n -> :w
            :w -> :n
          end
        end)
        |> move

      "+" ->
        cart
        |> turn
        |> move
    end
  end

  @doc """
      iex> Day13.clean(%{{0, 0} => "|", {0, 1} => "v", {0, 2} => "|", {0, 3} => "|", {0, 4} => "|", {0, 5} => "^", {0, 6} => "|"})
      %{{0, 0} => "|", {0, 1} => "|", {0, 2} => "|", {0, 3} => "|", {0, 4} => "|", {0, 5} => "|", {0, 6} => "|"}
      
      iex> Day13.clean(%{{0, 0} => "-", {1, 0} => ">", {2, 0} => "-", {3, 0} => "-", {4, 0} => "-", {5, 0} => "<", {6, 0} => "-"})
      %{{0, 0} => "-", {1, 0} => "-", {2, 0} => "-", {3, 0} => "-", {4, 0} => "-", {5, 0} => "-", {6, 0} => "-"}
  """
  def clean(map) do
    map
    |> Enum.map(fn {position, char} ->
      char =
        case char do
          "v" -> "|"
          "^" -> "|"
          ">" -> "-"
          "<" -> "-"
          _ -> char
        end
      {position, char}
    end)
    |> Enum.into(%{})
  end

  @doc """
      iex> Day13.parse_carts(%{{0, 0} => "|", {0, 1} => "v", {0, 2} => "|", {0, 3} => "|", {0, 4} => "|", {0, 5} => "^", {0, 6} => "|"})
      [
        %{position: {0, 1}, direction: :s, should_turn: :left},
        %{position: {0, 5}, direction: :n, should_turn: :left}
      ]
  """
  def parse_carts(map) do
    map
    |> Enum.map(fn {position, char} ->
      case char do
        "v" -> %{position: position, direction: :s, should_turn: :left}
        "^" -> %{position: position, direction: :n, should_turn: :left}
        ">" -> %{position: position, direction: :e, should_turn: :left}
        "<" -> %{position: position, direction: :w, should_turn: :left}
        _ -> nil
      end
    end)
    |> Enum.filter(fn x -> x != nil end)
  end

  @doc """
      iex> Day13.tile({0, 0}, "priv/example_1.txt")
      "|"
      
      iex> Day13.tile({0, 1}, "priv/example_1.txt")
      "|"
      
      iex> Day13.tile({0, 2}, "priv/example_1.txt")
      "|"
      
      iex> Day13.tile({0, 0}, "priv/example_2.txt")
      "/"
      
      iex> Day13.tile({2, 0}, "priv/example_2.txt")
      "-"
      
      iex> Day13.tile({2, 2}, "priv/example_2.txt")
      "/"
  """
  defmemo tile(pos, filename) do
    clean_map =
      filename
      |> map
      |> clean

    clean_map[pos]
  end

  defmemo map(filename) do
    filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(fn row ->
      String.codepoints(row)
    end)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {col, y}, acc ->
      col
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {char, x}, acc ->
        Map.put(acc, {x, y}, char)
      end)
    end)
  end

  @doc """
      iex> Day13.move(%{position: {3, 3}, direction: :n, should_turn: :left})
      %{position: {3, 2}, direction: :n, should_turn: :left}

      iex> Day13.move(%{position: {2, 2}, direction: :s, should_turn: :right})
      %{position: {2, 3}, direction: :s, should_turn: :right}

      iex> Day13.move(%{position: {2, 2}, direction: :ne, should_turn: :right})
      %{position: {3, 2}, direction: :e, should_turn: :right}

      iex> Day13.move(%{position: {2, 2}, direction: :se, should_turn: :right})
      %{position: {2, 3}, direction: :s, should_turn: :right}
  """
  def move(cart) do
    case cart[:direction] do
      :n ->
        Map.update!(cart, :position, fn {x, y} -> {x, y - 1} end)

      :e ->
        Map.update!(cart, :position, fn {x, y} -> {x + 1, y} end)

      :s ->
        Map.update!(cart, :position, fn {x, y} -> {x, y + 1} end)

      :w ->
        Map.update!(cart, :position, fn {x, y} -> {x - 1, y} end)

      :ne ->
        cart
        |> Map.update!(:direction, fn _ -> :e end)
        |> Map.update!(:position, fn {x, y} -> {x + 1, y} end)

      :se ->
        cart
        |> Map.update!(:direction, fn _ -> :s end)
        |> Map.update!(:position, fn {x, y} -> {x, y + 1} end)

      :sw ->
        cart
        |> Map.update!(:direction, fn _ -> :w end)
        |> Map.update!(:position, fn {x, y} -> {x - 1, y} end)

      :nw ->
        cart
        |> Map.update!(:direction, fn _ -> :n end)
        |> Map.update!(:position, fn {x, y} -> {x, y - 1} end)
    end
  end

  @doc """
      iex> Day13.turn(%{position: {3, 3}, direction: :n, should_turn: :left})
      %{position: {3, 3}, direction: :w, should_turn: :straight}

      iex> Day13.turn(%{position: {2, 2}, direction: :s, should_turn: :right})
      %{position: {2, 2}, direction: :w, should_turn: :left}
  """
  def turn(%{position: pos, direction: dir, should_turn: turn_to}) do
    {dir, turn_to} =
      case {dir, turn_to} do
        {:n, :left} -> {:w, :straight}
        {:n, :straight} -> {:n, :right}
        {:n, :right} -> {:e, :left}
        {:e, :left} -> {:n, :straight}
        {:e, :straight} -> {:e, :right}
        {:e, :right} -> {:s, :left}
        {:s, :left} -> {:e, :straight}
        {:s, :straight} -> {:s, :right}
        {:s, :right} -> {:w, :left}
        {:w, :left} -> {:s, :straight}
        {:w, :straight} -> {:w, :right}
        {:w, :right} -> {:n, :left}
      end

    %{position: pos, direction: dir, should_turn: turn_to}
  end
end
