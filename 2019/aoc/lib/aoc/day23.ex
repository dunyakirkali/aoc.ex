defmodule Aoc.Day23 do
  def part2() do
    {:ok, pid} = Agent.start_link(fn -> [] end)
    ys = []
    computers =
      0..49
      |> Enum.map(fn nic ->
        IO.puts("Spawning #{nic}")
        "priv/day23/input.txt"
        |> AGC.new()
        |> Map.put(:inputs, [nic, -1])
      end)

    loop({computers, pid, ys})
  end
  #
  # def part1() do
  #   0..49
  #   |> Enum.map(fn nic ->
  #     IO.puts("Spawning #{nic}")
  #     "priv/day23/input.txt"
  #     |> AGC.new()
  #     |> Map.put(:inputs, [nic, -1])
  #   end)
  #   |> loop(0)
  # end

  def loop({computers, pid, ys}) do
    outputs =
      computers
      |> Enum.map(fn computer ->
        Map.get(computer, :output)
      end)

    computers =
      computers
      |> Enum.map(fn computer ->
        computer |> Map.put(:output, [])
      end)

    computers =
      outputs
      |> List.flatten
      |> Enum.chunk_every(3)
      |> Enum.reduce(computers, fn packet, acc ->
        send_to(acc, packet, pid)
      end)
      |> Enum.map(fn computer ->
        AGC.run(computer)
      end)

    {computers, pid, ys}
    |> nat()
    |> loop()
  end

  def nat({computers, pid, ys}) do
    idle =
      computers
      |> Enum.map(fn computer ->
        Enum.count(Map.get(computer, :inputs))
      end)
      |> Enum.all?(fn in_count ->
        in_count == 0
      end)

    if idle do
      IO.puts("Idle")
      input = Agent.get(pid, &(&1))
      Agent.update(pid, fn (state) -> [] end)
      y = Enum.at(input, 1)
      ys =
        if y != nil do
          ys |> IO.inspect(label: "ys")
          y |> IO.inspect(label: "y")
          if  Enum.member?(ys, y) do
            exit("#{y}")
          end
          [y | ys]
        else
          ys
        end
      fc = Enum.at(computers, 0)
      fc = fc |> Map.put(:inputs, input) |> AGC.run

      {List.replace_at(computers, 0, fc), pid, ys}
    else
      {computers, pid, ys}
    end
  end

  def send_to(computers, [nic, x, y], pid) do
    IO.puts("Sending #{x}-#{y} to #{nic}")
    if nic == 255 do
      IO.inspect([x, y])
      Agent.update(pid, fn (state) -> [x, y] end)
      computers
    else
      computer = Enum.at(computers, nic)
      computer =
        computer
        |> Map.put(:inputs, [x, y])
        |> AGC.run()
      List.replace_at(computers, nic, computer)
    end
  end
end
