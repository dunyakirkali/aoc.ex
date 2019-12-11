defmodule Aoc.Day11 do
  defmodule Painter do
    defstruct [:brain, direction: :up, position: {500, 500}]
  end


  def part1(map) do
    robot = %Aoc.Day11.Painter{brain: AGC.new("priv/day11/input.txt")}

    0
    |> Stream.iterate(&(&1 + 1))
    |> Enum.reduce_while({map, robot, []}, fn i, {map, robot, colored} ->
      input = color_code(Map.get(map, robot.position))

      brain =
        robot.brain
        |> Map.put(:inputs, [input])
        |> AGC.run()

      robot = %Aoc.Day11.Painter{robot | brain: brain}

      [color_c, direction_c] = Map.get(brain, :output) |> Enum.take(-2)
      color = color(color_c)

      direction = direction(direction_c)

      pos_to_point = robot.position
      robot =
        robot
        |> turn(direction)
        |> move

      if brain.state == :halt do
        draw(map)
        {:halt, colored}
      else
        {:cont,
          {
            Map.put(map, pos_to_point, color),
            robot,
            [pos_to_point | colored]
          }
        }
      end
    end)
    |> Enum.uniq
    |> Enum.count
  end

  def draw(map) do
    map
    |> Enum.reduce(Drawille.Canvas.new(), fn({{x, y}, color}, acc_canvas) ->
      acc_canvas =
        case color do
          :black -> Drawille.Canvas.unset(acc_canvas, x + 1, y + 1)
          :white -> Drawille.Canvas.set(acc_canvas, x + 1, y + 1)
        end
      acc_canvas
    end)
    |> Drawille.Canvas.frame
  end

  def color_code(val) do
    case val do
      :black -> 0
      :white -> 1
    end
  end

  def color(val) do
    case val do
      0 -> :black
      1 -> :white
    end
  end

  def direction(val) do
    case val do
      0 -> :left
      1 -> :right
    end
  end

  def move(robot) do
    {x, y} = robot.position
    case robot.direction do
      :up -> %Aoc.Day11.Painter{robot | position: {x, y - 1}}
      :left -> %Aoc.Day11.Painter{robot | position: {x - 1, y}}
      :down -> %Aoc.Day11.Painter{robot | position: {x, y + 1}}
      :right -> %Aoc.Day11.Painter{robot | position: {x + 1, y}}
    end
  end

  def turn(robot, :left) do
    case robot.direction do
      :up -> %Aoc.Day11.Painter{robot | direction: :left}
      :left -> %Aoc.Day11.Painter{robot | direction: :down}
      :down -> %Aoc.Day11.Painter{robot | direction: :right}
      :right -> %Aoc.Day11.Painter{robot | direction: :up}
    end
  end

  def turn(robot, :right) do
    case robot.direction do
      :up -> %Aoc.Day11.Painter{robot | direction: :right}
      :left -> %Aoc.Day11.Painter{robot | direction: :up}
      :down -> %Aoc.Day11.Painter{robot | direction: :left}
      :right -> %Aoc.Day11.Painter{robot | direction: :down}
    end
  end
end
