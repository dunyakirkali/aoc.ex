defmodule Aoc.Day23 do
  defmodule Computer do
    use GenServer

    def start(nic) do
      GenServer.start(__MODULE__, nic, name: :"nic_#{nic}")
    end

    def run(pid) do
      GenServer.cast(pid, :run)
    end

    def input(pid, list) do
      GenServer.cast(pid, {:input, list})
    end

    def stop(pid) do
      GenServer.stop(pid)
    end

    def init(nic) do
      computer =
        "priv/day23/input.txt"
        |> AGC.new()
        |> Map.put(:inputs, [nic, -1])

      {:ok, computer}
    end

    def handle_cast(:run, computer) do
      :timer.send_interval(1, :run)

      {:noreply, computer}
    end

    def handle_cast({:input, list}, computer) do
      computer = Map.update!(computer, :inputs, &(&1 ++ list))

      {:noreply, computer}
    end

    def handle_info(:run, computer) do
      if length(computer.inputs) > 0 do
        computer = AGC.run(computer)
        computer.output
        |> Enum.chunk_every(3)
        |> Enum.map(fn [nic, x, y] ->
          IO.puts("nic: #{nic} -> X: #{x} Y: #{y}")
          if nic == 255 do
            0..49
            |> Enum.map(fn nic ->
              stop(:"nic_#{nic}")
            end)

            IO.puts("=========> X: #{x}, #{y}")
          end
          input(:"nic_#{nic}", [x, y])
        end)

        {:noreply, Map.put(computer, :output, [])}
      else
        {:noreply, computer}
      end
    end
  end

  def part1() do
    max = 49
    0..max
    |> Enum.map(fn nic ->
      IO.puts("Spawning #{nic}")
      Computer.start(nic)
    end)

    0..max
    |> Enum.map(fn nic ->
      Computer.run(:"nic_#{nic}")
      :sys.get_state(:"nic_#{nic}")
    end)
  end
end
