defmodule Aoc.Day13 do
  import Drawille.Canvas

  def part1() do
    AGC.new("priv/day13/input.txt")
    |> AGC.run
    |> Map.get(:output)
    |> Enum.chunk_every(3)
    |> Enum.map(fn [x, y, tile_id] ->

      case tile_id do
        0 -> :empty
        1 -> :wall
        2 -> :block
        3 -> :horiizontal_paddle
        4 -> :ball
      end
    end)
    |> Enum.filter(fn tile ->
      tile == :block
    end)
    |> Enum.count
  end

  def part2() do
    "priv/day13/input.txt"
    |> AGC.new()
    |> AGC.hack
    |> do_part2()
    |> IO.inspect
    |> Map.get(:score)
  end

  def do_part2(machine) do
    machine = AGC.run(machine)

    chunks =
      machine
      |> Map.get(:output)
      |> Enum.chunk_every(3)

    score =
      chunks
      |> Enum.filter(fn [x, y, tile_id] ->
        x == -1 and y == 0
      end)
      |> List.last
      |> List.last
      # |> IO.inspect(label: "score")

    [ball_x, ball_y, _] =
      chunks
      |> Enum.filter(fn [x, y, tile_id] ->
        tile_id == 4
      end)
      # |> IO.inspect(label: "balls")
      |> List.last
      # |> IO.inspect(label: "ball")

    [paddle_x, paddle_y, _] =
      chunks
      |> Enum.filter(fn [x, y, tile_id] ->
        tile_id == 3
      end)
      |> List.last
      # |> IO.inspect(label: "paddle")

    block_count =
      chunks
      |> Enum.filter(fn [x, y, tile_id] ->
        tile_id == 2
      end)
      |> Enum.count

    next =
      cond do
        paddle_x > ball_x -> -1
        paddle_x == ball_x -> 0
        paddle_x < ball_x -> 1
      end

    # machine
    # |> Map.get(:output)
    # |> Enum.chunk_every(3)
    # |> Enum.filter(fn [x, y, tile_id] ->
    #   y < 21 and x < 35 and x >= 0 and y >= 0
    # end)
    # |> Enum.map(fn [x, y, tile_id] ->
    #   tile =
    #     case tile_id do
    #       0 -> :empty
    #       1 -> :wall
    #       2 -> :block
    #       3 -> :horizontal_paddle
    #       4 -> :ball
    #     end
    #   {{x, y}, tile}
    # end)
    # |> Enum.reduce(new(), fn {{x, y}, tile}, acc_canvas ->
    #   acc_canvas =
    #     case tile do
    #       :empty -> unset(acc_canvas, x + 1, y + 1)
    #       :wall -> set(acc_canvas, x + 1, y + 1)
    #       :block -> set(acc_canvas, x + 1, y + 1)
    #       :horizontal_paddle -> set(acc_canvas, x + 1, y + 1)
    #       :ball -> set(acc_canvas, x + 1, y + 1)
    #     end
    #   acc_canvas
    # end)
    # |> frame()

    machine =
      machine
      |> Map.put(:score, score)
      |> Map.put(:inputs, [next])
    if machine.state == :halt or block_count == 0 do
      machine
    else
      do_part2(machine)
    end
  end

  defp input() do
    "priv/day13/input.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn x ->
      String.to_integer(x)
    end)
  end
end
