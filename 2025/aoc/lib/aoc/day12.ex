defmodule Aoc.Day12 do
  @doc """
      iex> "priv/day12/example.txt" |> Aoc.Day12.input() |> Aoc.Day12.part1()
      2
  """
  def part1({shapes, grids}) do
    grids
    |> Enum.filter(fn {size, freqs} ->
      shape_list =
        freqs
        |> Enum.flat_map(fn {count, index} ->
          for _i <- if(count > 0, do: 1..count, else: []) do
            Enum.at(shapes, index)
            |> elem(1)
            |> Map.filter(fn {_pos, val} -> val == "#" end)
          end
        end)

      case find_placement_fast(shape_list, size) do
        {:ok, _} -> true
        {:error, _} -> false
      end
    end)
    |> length()
  end

  # New efficient backtracking approach
  def find_placement_fast(shapes, grid_size) do
    # Try multiple orderings of shapes to find a solution
    # Generate various orderings to try
    base_orderings = [
      shapes,
      Enum.reverse(shapes)
    ]

    # Add just 2 random shuffles for better coverage (minimal for performance)
    random_orderings = for _ <- 1..2, do: Enum.shuffle(shapes)

    orderings = base_orderings ++ random_orderings

    orderings
    |> Enum.find_value(fn ordering ->
      case backtrack_place(ordering, grid_size, MapSet.new(), []) do
        {:ok, placed} -> {:ok, placed}
        :error -> nil
      end
    end)
    |> case do
      nil -> {:error, :no_solution}
      result -> result
    end
  end

  defp backtrack_place([], _grid_size, _occupied, placed) do
    {:ok, Enum.reverse(placed)}
  end

  defp backtrack_place([shape | rest_shapes], grid_size, occupied, placed) do
    # Try all transformations of this shape
    transformations(shape)
    |> Enum.find_value(:error, fn transformed_shape ->
      # Try all positions for this transformation
      case try_all_positions(transformed_shape, grid_size, occupied) do
        [] ->
          nil

        positions ->
          positions
          |> Enum.find_value(:error, fn {_pos, translated} ->
            new_occupied = MapSet.union(occupied, MapSet.new(Map.keys(translated)))

            case backtrack_place(rest_shapes, grid_size, new_occupied, [translated | placed]) do
              {:ok, _} = success -> success
              :error -> nil
            end
          end)
      end
    end)
  end

  defp try_all_positions(shape, {width, height} = grid_size, occupied) do
    # Grid size is {width, height} where width = num columns, height = num rows
    # Shapes use {row, col} coordinates
    # Try positions in order: top-left first, then scan left-to-right, top-to-bottom
    # This helps find solutions faster by placing shapes compactly
    positions =
      for offset_row <- 0..(height - 1),
          offset_col <- 0..(width - 1),
          do: {offset_row, offset_col}

    # Try positions in order, stop early if we find enough valid ones
    positions
    |> Enum.reduce_while([], fn {offset_row, offset_col}, acc ->
      translated = translate_shape(shape, offset_row, offset_col)

      if shape_fits_at_position?(translated, grid_size, occupied) do
        new_acc = [{{offset_row, offset_col}, translated} | acc]
        # Collect all valid positions
        {:cont, new_acc}
      else
        {:cont, acc}
      end
    end)
    |> Enum.reverse()
  end

  def transformations(shape) do
    [
      shape,
      rotate_90(shape),
      rotate_180(shape),
      rotate_270(shape),
      flip_horizontal(shape),
      flip_vertical(shape),
      shape |> flip_horizontal() |> rotate_90(),
      shape |> flip_vertical() |> rotate_90()
    ]
    |> Enum.uniq()
  end

  def rotate_90(shape) do
    # Rotate 90 degrees clockwise: {row, col} -> {col, -row}
    # Then normalize to start at {0, 0}
    shape
    |> Enum.map(fn {{row, col}, value} -> {{col, -row}, value} end)
    |> Map.new()
    |> normalize()
    |> Map.filter(fn {_pos, val} -> val == "#" end)
  end

  def rotate_180(shape) do
    shape
    |> Enum.map(fn {{row, col}, value} -> {{-row, -col}, value} end)
    |> Map.new()
    |> normalize()
    |> Map.filter(fn {_pos, val} -> val == "#" end)
  end

  def rotate_270(shape) do
    # Rotate 270 degrees clockwise (90 counter-clockwise): {row, col} -> {-col, row}
    shape
    |> Enum.map(fn {{row, col}, value} -> {{-col, row}, value} end)
    |> Map.new()
    |> normalize()
    |> Map.filter(fn {_pos, val} -> val == "#" end)
  end

  def flip_horizontal(shape) do
    # Flip horizontally: mirror across vertical axis, {row, col} -> {row, -col}
    shape
    |> Enum.map(fn {{row, col}, value} -> {{row, -col}, value} end)
    |> Map.new()
    |> normalize()
    |> Map.filter(fn {_pos, val} -> val == "#" end)
  end

  def flip_vertical(shape) do
    # Flip vertically: mirror across horizontal axis, {row, col} -> {-row, col}
    shape
    |> Enum.map(fn {{row, col}, value} -> {{-row, col}, value} end)
    |> Map.new()
    |> normalize()
    |> Map.filter(fn {_pos, val} -> val == "#" end)
  end

  def normalize(shape) do
    coords = Map.keys(shape)

    if Enum.empty?(coords) do
      shape
    else
      min_row = coords |> Enum.map(&elem(&1, 0)) |> Enum.min()
      min_col = coords |> Enum.map(&elem(&1, 1)) |> Enum.min()

      shape
      |> Enum.map(fn {{row, col}, value} -> {{row - min_row, col - min_col}, value} end)
      |> Map.new()
    end
  end

  def bounds(shape) do
    coords = Map.keys(shape)

    if Enum.empty?(coords) do
      {0, 0, 0, 0}
    else
      rows = Enum.map(coords, &elem(&1, 0))
      cols = Enum.map(coords, &elem(&1, 1))
      {Enum.min(rows), Enum.min(cols), Enum.max(rows), Enum.max(cols)}
    end
  end

  def fits_in_grid?(shapes, {width, height}) do
    all_positions =
      shapes
      |> Enum.flat_map(fn shape -> Map.keys(shape) end)

    has_no_overlap = length(all_positions) == length(Enum.uniq(all_positions))

    within_bounds =
      Enum.all?(all_positions, fn {row, col} ->
        row >= 0 and row < height and col >= 0 and col < width
      end)

    has_no_overlap and within_bounds
  end

  defp translate_shape(shape, offset_row, offset_col) do
    # Shapes use {row, col} coordinates
    # Add offsets to translate the shape to a new position
    shape
    |> Enum.map(fn {{row, col}, value} -> {{row + offset_row, col + offset_col}, value} end)
    |> Map.new()
  end

  defp shape_fits_at_position?(shape, {width, height}, occupied) do
    # Shapes use {row, col}, grid is {width, height}
    # Width = number of columns, Height = number of rows
    positions = Map.keys(shape)

    within_bounds =
      Enum.all?(positions, fn {row, col} ->
        row >= 0 and row < height and col >= 0 and col < width
      end)

    no_overlap = MapSet.disjoint?(MapSet.new(positions), occupied)
    within_bounds and no_overlap
  end

  def input(filename) do
    list =
      filename
      |> File.read!()
      |> String.split("\n\n", trim: true)

    shapes =
      Enum.drop(list, -1)
      |> Enum.map(fn shape ->
        [i | p] =
          shape
          |> String.split("\n", trim: true)

        {
          i
          |> String.split(":", trim: true)
          |> List.first()
          |> String.to_integer(),
          p
          |> Enum.with_index()
          |> Enum.reduce(%{}, fn {l, row}, acc ->
            l
            |> String.graphemes()
            |> Enum.with_index()
            |> Enum.reduce(acc, fn {c, col}, acc ->
              Map.put(acc, {row, col}, c)
            end)
          end)
        }
      end)

    s =
      list
      |> List.last()
      |> String.split("\n", trim: true)
      |> Enum.map(fn size ->
        [xx, fre] =
          size
          |> String.split(": ", trim: true)

        {
          xx
          |> String.split("x", trim: true)
          |> Enum.map(&String.to_integer/1)
          |> List.to_tuple(),
          fre
          |> String.split(" ", trim: true)
          |> Enum.map(&String.to_integer/1)
          |> Enum.with_index()
        }
      end)

    {shapes, s}
  end
end
