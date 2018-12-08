defmodule Day8 do
  @moduledoc """
  Documentation for Day8.
  """

  @doc """
      # iex> Day8.sum_metas([0, 0])
      # 0
      #
      # iex> Day8.sum_metas([0, 1, 12])
      # 12
      #
      # iex> Day8.sum_metas([1, 1, 0, 1, 2, 12])
      # 14
      #
      # iex> Day8.sum_metas([2, 1, 0, 0, 0, 0, 12])
      # 12

      iex> Day8.sum_metas([2, 3, 0, 3, 10, 11, 12, 1, 1, 0, 1, 99, 2, 1, 1, 2])
      138
  """
  def sum_metas(list) do
    list
    |> Enum.reduce({[], [], 0, :children_count}, fn x, {children, metas, sum, state} ->
      children |> IO.inspect(label: "Children")
      metas |> IO.inspect(label: "Metas")
      sum |> IO.inspect(label: "Sum")
      state |> IO.inspect(label: "State")

      IO.puts("---- #{x} ----")

      case state do
        :children_count ->
          {[x | children], metas, sum, :metas}
        :metas ->
          cc = List.first(children) |> IO.inspect(label: "children count")

          if cc > 0 do
            {children, [x | metas], sum, :children_count}
          else
            {children, [x | metas], sum, :sum}
          end
        :sum ->
          IO.puts("------D-----------")
          cc = List.first(children) |> IO.inspect(label: "children count")
          mc = List.first(metas) |> IO.inspect(label: "meta  count")

          if mc > 1 do
            {children, List.replace_at(metas, 0, mc - 1), sum + x, :sum}
          else
            if cc > 1 do
              {List.delete_at(children, 0), List.delete_at(metas, 0), sum + x, :children_count}
            else
              {List.delete_at(children, 0), List.delete_at(metas, 0), sum + x, :metas}
            end
          end
      end
    end)
    |> elem(2)
  end

  # @doc """
  #     iex> Day8.parse_node([])
  #     []
  #
  #     # iex> Day8.parse_node([0, 0])
  #     # %{metadata: [], children: []}
  #     #
  #     # iex> Day8.parse_node([0, 1, 12])
  #     # %{metadata: [12], children: []}
  #
  #     # iex> Day8.parse_node([1, 1, 0, 0, 12])
  #     # %{metadata: [12], children: [%{metadata: [], children: []}]}
  #
  #     iex> Day8.parse_node([2, 1, 0, 0, 0, 0, 12])
  #     [%{metadata: [12], children: [%{metadata: [], children: []}, %{metadata: [], children: []}]}]
  #
  #     # iex> Day8.parse_node([1, 0, 0, 0])
  #     # %{metadata: [], children: [%{metadata: [], children: []}]}
  #     #
  #     # iex> Day8.parse_node([0, 3, 10, 11, 12])
  #     # %{metadata: [10, 11, 12], children: []}
  #     #
  #     # iex> Day8.parse_node([1, 3, 0, 1, 1, 10, 11, 12])
  #     # %{metadata: [10, 11, 12], children: [%{metadata: [1], children: []}]}
  # """
  # def parse_node(list) when length(list) == 0, do: []
  # def parse_node([children_count | tail]) do
  #   IO.puts("parse_node")
  #
  #   children_count |> IO.inspect(label: "child #")
  #   [head | rest] = tail
  #   children = Enum.take(rest, length(rest) - head) |> IO.inspect(label: "remainder")
  #   metas = Enum.take(rest, -1 * head) |> IO.inspect(label: "metas")
  #
  #   %{children: parse_node(children), metadata: metas}
  # end
end
