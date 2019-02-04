defmodule Day14 do
  @doc """
      iex> Day14.part_2([
      ...>   "Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.",
      ...>   "Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds."
      ...> ])
      689
  """
  def part_2(lines, length \\ 1000) do
    deers = parse(lines)
    1..length
    |> Enum.reduce({0, deers}, fn _, {_, deers} ->
      deers = tick(deers)
      
      max_dist =
        deers
        |> Enum.map(fn deer ->
          deer[:distance]
        end)
        |> Enum.max
      
      deers =
        deers
        |> Enum.map(fn deer ->
          if deer[:distance] == max_dist do
            Map.update!(deer, :points, &(&1 + 1))
          else
            deer
          end
        end)
      
      max =
        deers
        |> Enum.map(fn deer ->
          deer[:points]
        end)
        |> Enum.max
      {max, deers}
    end)
    |> elem(0)
  end
  
  def tick(deers) do
    deers
    |> Enum.map(fn deer ->
      deer =
        if deer[:progress] == 0 do
          case deer[:state] do
            :idle ->
              deer
              |> Map.put(:state, :running)
              |> Map.put(:progress, deer[:sprint])
            :running ->
              deer
              |> Map.put(:state, :idle)
              |> Map.put(:progress, deer[:pause])
          end
        else
          deer
        end

      case deer[:state] do
        :idle ->
          deer
          |> Map.put(:progress, deer[:progress] - 1)
        :running ->
          deer
          |> Map.put(:progress, deer[:progress] - 1)
          |> Map.update!(:distance, &(&1 + deer[:speed]))
      end
    end)
  end
  
  @doc """
      iex> Day14.parse(["Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds."])
      [%{name: "Comet", speed: 14, sprint: 10, pause: 127, state: :idle, progress: 0, points: 0, distance: 0}]

      iex> Day14.parse("Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.")
      %{name: "Comet", speed: 14, sprint: 10, pause: 127, state: :idle, progress: 0, points: 0, distance: 0}
  """
  def parse(lines) when is_list(lines) do
    Enum.map(lines, &parse/1)
  end
  
  def parse(line) when is_binary(line) do
    captures = Regex.named_captures(regex(), line)
    
    %{
      name: captures["name"],
      speed: String.to_integer(captures["speed"]),
      sprint: String.to_integer(captures["sprint"]),
      pause: String.to_integer(captures["pause"]),
      state: :idle,
      progress: 0,
      points: 0,
      distance: 0
    }
  end
  
  defp regex do
    ~r/(?<name>\S+) can fly (?<speed>\d+) km\/s for (?<sprint>\d+) seconds, but then must rest for (?<pause>\d+) seconds./
  end
end
