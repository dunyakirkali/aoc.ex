defmodule Aoc do
  defmodule Parallel do
    def pmap(collection, func) do
      collection
      |> Enum.map(&Task.async(fn -> func.(&1) end))
      |> Enum.map(fn x ->
        Task.await(x, 1_000_000_000)
      end)
    end
  end

  @moduledoc """
  Documentation for `Aoc`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Aoc.hello()
      :world

  """
  def hello do
    :world
  end
end
