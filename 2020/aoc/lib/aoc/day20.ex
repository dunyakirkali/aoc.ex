defmodule Aoc.Day20 do
  defmodule Piece do
    use Tensor

    defstruct [:id, :chart, rotation: 0, flip: false]

    def new(raw) do
      [info | content] = String.split(raw, "\n", trim: true)
      match = Regex.named_captures(~r/Tile (?<id>.*):/, info)

      list_of_lists =
        content
        |> Enum.map(fn line ->
          String.split(line, "", trim: true)
        end)

      %Aoc.Day20.Piece{
        id: String.to_integer(match["id"]),
        chart: Matrix.new(list_of_lists, 10, 10)
      }
    end

    def fit?(p1, direction, p2) do
      case direction do
        :left ->
          Matrix.column(p1.chart, 0) == Matrix.column(p2.chart, 9)

        :right ->
          Matrix.column(p1.chart, 9) == Matrix.column(p2.chart, 0)

        :top ->
          Matrix.row(p1.chart, 0) == Matrix.row(p2.chart, 9)

        :bottom ->
          Matrix.row(p1.chart, 9) == Matrix.row(p2.chart, 0)
      end
    end

    def permutate(piece) do
      # TODO: (dunyakirkali) Use comprehensions
      r1 =
        piece
        |> Map.update!(:chart, fn mat ->
          mat
          |> Matrix.rotate_clockwise()
        end)
        |> Map.put(:rotation, 90)

      r2 =
        piece
        |> Map.update!(:chart, fn mat ->
          mat
          |> Matrix.rotate_clockwise()
          |> Matrix.rotate_clockwise()
        end)
        |> Map.put(:rotation, 180)

      r3 =
        piece
        |> Map.update!(:chart, fn mat ->
          mat
          |> Matrix.rotate_clockwise()
          |> Matrix.rotate_clockwise()
          |> Matrix.rotate_clockwise()
        end)
        |> Map.put(:rotation, 270)

      piece_flip =
        piece
        |> Map.update!(:chart, &Matrix.flip_horizontal(&1))
        |> Map.put(:flip, true)

      r1_flip =
        r1
        |> Map.update!(:chart, &Matrix.flip_horizontal(&1))
        |> Map.put(:flip, true)

      r2_flip =
        r2
        |> Map.update!(:chart, &Matrix.flip_horizontal(&1))
        |> Map.put(:flip, true)

      r3_flip =
        r3
        |> Map.update!(:chart, &Matrix.flip_horizontal(&1))
        |> Map.put(:flip, true)

      [piece, r1, r2, r3, piece_flip, r1_flip, r2_flip, r3_flip]
    end
  end

  @doc """
      iex> Aoc.Day20.part1("priv/day20/example.txt")
      20899048083289
  """
  def part1(filename) do
    inp =
      filename
      |> File.read!()
      |> String.split("\n\n", trim: true)

    size =
      inp
      |> Enum.count()
      |> :math.sqrt()
      |> floor
      |> IO.inspect(label: "size")

    inp
    |> Enum.map(fn group ->
      group
      |> Aoc.Day20.Piece.new()
    end)
    |> Enum.reduce(fn piece, acc ->
      if is_list(acc) do
        Comb.cartesian_product(acc, Piece.permutate(piece))
      else
        Comb.cartesian_product(Piece.permutate(acc), Piece.permutate(piece))
      end
    end)
    |> IO.inspect()
    |> Stream.map(fn comb ->
      List.flatten(comb)
    end)
    |> Stream.map(fn comb ->
      comb
      |> Enum.chunk_every(size)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {row, rc}, acc ->
        row
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {col, cc}, acc ->
          Map.put(acc, {cc, rc}, col)
        end)
      end)
    end)
    |> Enum.reduce_while(%{}, fn map, acc ->
      res =
        map
        |> Enum.reduce_while(false, fn {{x, y} = pos, piece}, acc ->
          tp = Map.get(map, {x, y - 1}, nil)
          rp = Map.get(map, {x + 1, y}, nil)
          bp = Map.get(map, {x, y + 1}, nil)
          lp = Map.get(map, {x - 1, y}, nil)

          rs = size - 1

          case pos do
            {0, 0} ->
              if Piece.fit?(piece, :right, rp) && Piece.fit?(piece, :bottom, bp) do
                {:cont, true}
              else
                {:halt, false}
              end

            {0, rs} ->
              if Piece.fit?(piece, :right, rp) && Piece.fit?(piece, :top, tp) do
                {:cont, true}
              else
                {:halt, false}
              end

            {rs, 0} ->
              if Piece.fit?(piece, :left, lp) && Piece.fit?(piece, :bottom, bp) do
                {:cont, true}
              else
                {:halt, false}
              end

            {rs, rs} ->
              if Piece.fit?(piece, :left, lp) && Piece.fit?(piece, :top, tp) do
                {:cont, true}
              else
                {:halt, false}
              end

            _ ->
              {:halt, acc}
          end
        end)

      if res do
        {:halt, map}
      else
        {:halt, acc}
      end
    end)

    # |> Enum.count

    #   |> Enum.map(fn comb ->
    #     comb
    #     |> Enum.chunk_every(size)
    #     |> Enum.with_index
    #     |> Enum.reduce(%{}, fn {row, rc}, acc ->
    #       row
    #       |> Enum.with_index
    #       |> Enum.reduce(acc, fn {col, cc}, acc ->
    #         Map.put(acc, {cc, rc}, col)
    #       end)
    #     end)
    #   end)
    #   |> Enum.reduce_while(%{}, fn tiles, acc ->
    #     if valid?(tiles, corners, size - 1) do
    #       {:halt, tiles}
    #     else
    #       {:cont, acc}
    #     end
    #   end)
    #   |> IO.inspect(label: "Solution")
    #
    # [
    #   Map.get(solution, {0, 0}),
    #   Map.get(solution, {0, size - 1}),
    #   Map.get(solution, {size - 1, 0}),
    #   Map.get(solution, {size - 1, size - 1})
    # ]
    # |> IO.inspect
    # |> Enum.reduce(1, fn x, acc ->
    #   acc * x
    # end)
  end
end
