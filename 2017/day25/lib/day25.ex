defmodule Day25 do
  def part_1 do
    1..12368930
    |> Enum.reduce({:a, %{}, 0}, fn _, {state, tape, index} ->
      do_step({state, tape, index})
    end)
    |> elem(1)
    |> Map.values()
    |> Enum.filter(fn v ->
      v == 1
    end)
    |> Enum.count
  end
  
  def do_step({state, tape, index}) do
    # IO.inspect({state, tape, index})
    case state do
      :a -> do_a({tape, index})
      :b -> do_b({tape, index})
      :c -> do_c({tape, index})
      :d -> do_d({tape, index})
      :e -> do_e({tape, index})
      :f -> do_f({tape, index})
    end
  end
  
  @doc """
      iex> Day25.do_a({%{}, 0})
      {:b, %{0 => 1}, 1}
      
      iex> Day25.do_a({%{0 => 1}, 0})
      {:c, %{0 => 0}, 1}
  """
  def do_a({tape, index}) do
    value = Map.get(tape, index, 0)
    state =
      case value do
        0 -> :b
        1 -> :c
      end
    tape =
      case value do
        0 -> Map.put(tape, index, 1)
        1 -> Map.put(tape, index, 0)
      end
    index = index + 1

    {state, tape, index}
  end
  
  @doc """
      iex> Day25.do_b({%{}, 0})
      {:a, %{0 => 0}, -1}
      
      iex> Day25.do_b({%{0 => 1}, 0})
      {:d, %{0 => 0}, 1}
  """
  def do_b({tape, index}) do
    value = Map.get(tape, index, 0)
    state =
      case value do
        0 -> :a
        1 -> :d
      end
    tape = Map.put(tape, index, 0)
    index =
      case value do
        0 -> index - 1
        1 -> index + 1
      end
      
    {state, tape, index}
  end
  
  @doc """
      iex> Day25.do_c({%{}, 0})
      {:d, %{0 => 1}, 1}
      
      iex> Day25.do_c({%{0 => 1}, 0})
      {:a, %{0 => 1}, 1}
  """
  def do_c({tape, index}) do
    value = Map.get(tape, index, 0)
    state =
      case value do
        0 -> :d
        1 -> :a
      end
    tape = Map.put(tape, index, 1)
    index = index + 1
      
    {state, tape, index}
  end
  
  @doc """
      iex> Day25.do_d({%{}, 0})
      {:e, %{0 => 1}, -1}
      
      iex> Day25.do_d({%{0 => 1}, 0})
      {:d, %{0 => 0}, -1}
  """
  def do_d({tape, index}) do
    value = Map.get(tape, index, 0)
    state =
      case value do
        0 -> :e
        1 -> :d
      end
    tape =
      case value do
        0 -> Map.put(tape, index, 1)
        1 -> Map.put(tape, index, 0)
      end
    index = index - 1
      
    {state, tape, index}
  end
  
  @doc """
      iex> Day25.do_e({%{}, 0})
      {:f, %{0 => 1}, 1}
      
      iex> Day25.do_e({%{0 => 1}, 0})
      {:b, %{0 => 1}, -1}
  """
  def do_e({tape, index}) do
    value = Map.get(tape, index, 0)
    state =
      case value do
        0 -> :f
        1 -> :b
      end
    tape = Map.put(tape, index, 1)
    index =
      case value do
        0 -> index + 1
        1 -> index - 1
      end
      
    {state, tape, index}
  end
  
  @doc """
      iex> Day25.do_f({%{}, 0})
      {:a, %{0 => 1}, 1}
      
      iex> Day25.do_f({%{0 => 1}, 0})
      {:e, %{0 => 1}, 1}
  """
  def do_f({tape, index}) do
    value = Map.get(tape, index, 0)
    state =
      case value do
        0 -> :a
        1 -> :e
      end
    tape = Map.put(tape, index, 1)
    index = index + 1
      
    {state, tape, index}
  end
end
