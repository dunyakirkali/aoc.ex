defmodule Day10 do
  import NimbleParsec

  defmodule Bot do
    defstruct [:id, values: []]
  end

  defmodule Instruction do
    defstruct [:bot, :l_type, :l_id, :h_type, :h_id]
  end

  @doc """
      iex> Day10.part_1([
      ...>   "value 5 goes to bot 2",
      ...>   "bot 2 gives low to bot 1 and high to bot 0",
      ...>   "value 3 goes to bot 1",
      ...>   "bot 1 gives low to output 1 and high to bot 0",
      ...>   "bot 0 gives low to output 2 and high to output 0",
      ...>   "value 2 goes to bot 2"
      ...> ], {2, 5})
      2
  """
  def part_1(instructions, {low, high}) do
    bots = load_bots(%{}, instructions)
    steps = load_steps([], instructions)

    do_part_1(bots, steps, {low, high})
  end

  def part_2(instructions, {low, high}) do
    bots = load_bots(%{}, instructions)
    steps = load_steps([], instructions)

    do_part_2(bots, steps, {low, high})
  end

  defp load_steps(steps, []), do: steps
  defp load_steps(steps, instructions) do
    [head | tail] = instructions
    case transfer(head) do
      {:ok, match, _, _, _, _} ->
        steps = process(steps, match)
        load_steps(steps, tail)
      _ ->
        load_steps(steps, tail)
    end
  end

  def do_part_1(bots, steps, {low, high}) do
    bot_to_move = Enum.find(Map.values(bots), fn bot ->
      length(bot.values) == 2
    end)

    if Enum.member?(bot_to_move.values, low) and Enum.member?(bot_to_move.values, high) do
      bot_to_move.id
    else
      move = Enum.find(steps, fn step ->
        step.bot == bot_to_move.id
      end)

      bots = move(bots, bot_to_move.id, {move.l_type, move.l_id, move.h_type, move.h_id})
      steps = Enum.filter(steps, fn step -> step != move end)

      do_part_1(bots, steps, {low, high})
    end
  end

  def do_part_2(bots, [], {low, high}), do: bots
  def do_part_2(bots, steps, {low, high}) do
    bot_to_move = Enum.find(Map.values(bots), fn bot ->
      length(bot.values) == 2
    end)

    move = Enum.find(steps, fn step ->
      step.bot == bot_to_move.id
    end)

    bots = move(bots, bot_to_move.id, {move.l_type, move.l_id, move.h_type, move.h_id})
    steps = Enum.filter(steps, fn step -> step != move end)

    do_part_2(bots, steps, {low, high})
  end

  defp load_bots(bots, []), do: bots
  defp load_bots(bots, instructions) do
    [head | tail] = instructions
    case value(head) do
      {:ok, [value, bot], _, _, _, _} ->
        bots = process(bots, {value, bot})
        load_bots(bots, tail)
      _ ->
        load_bots(bots, tail)
    end
  end

  defp move(bots, bot_id, {"bot", l_id, "bot", h_id}) do
    bot = Map.get(bots, bot_id, %Bot{id: bot_id})
    l_bot = Map.get(bots, l_id, %Bot{id: l_id})
    h_bot = Map.get(bots, h_id, %Bot{id: h_id})

    [l_val, h_val] = bot.values

    bots
    |> Map.put(l_id, %{l_bot | values: Enum.sort(l_bot.values ++ [l_val])})
    |> Map.put(h_id, %{h_bot | values: Enum.sort(h_bot.values ++ [h_val])})
    |> Map.put(bot_id, %{bot | values: []})
  end

  defp move(bots, bot_id, {"bot", l_id, "output", h_id}) do
    bot = Map.get(bots, bot_id, %Bot{id: bot_id})
    l_bot = Map.get(bots, l_id, %Bot{id: l_id})
    h_out = Map.get(bots, h_id - 100, %Bot{id: h_id - 100})

    [l_val, h_val] = bot.values

    bots
    |> Map.put(l_id, %{l_bot | values: Enum.sort(l_bot.values ++ [l_val])})
    |> Map.put(h_id - 100, %{h_out | values: Enum.sort(h_out.values ++ [h_val])})
    |> Map.put(bot_id, %{bot | values: []})
  end

  defp move(bots, bot_id, {"output", l_id, "output", h_id}) do
    bot = Map.get(bots, bot_id, %Bot{id: bot_id})
    l_out = Map.get(bots, l_id - 100, %Bot{id: l_id - 100})
    h_out = Map.get(bots, h_id - 100, %Bot{id: h_id - 100})

    [l_val, h_val] = bot.values

    bots
    |> Map.put(l_id - 100, %{l_out | values: Enum.sort(l_out.values ++ [l_val])})
    |> Map.put(h_id - 100, %{h_out | values: Enum.sort(h_out.values ++ [h_val])})
    |> Map.put(bot_id, %{bot | values: []})
  end

  defp move(bots, bot_id, {"output", l_id, "bot", h_id}) do
    bot = Map.get(bots, bot_id, %Bot{id: bot_id})
    l_out = Map.get(bots, l_id - 100, %Bot{id: l_id - 100})
    h_bot = Map.get(bots, h_id, %Bot{id: h_id})

    [l_val, h_val] = bot.values

    bots
    |> Map.put(l_id - 100, %{l_out | values: Enum.sort(l_out.values ++ [l_val])})
    |> Map.put(h_id, %{h_bot | values: Enum.sort(h_bot.values ++ [h_val])})
    |> Map.put(bot_id, %{bot | values: []})
  end

  defp process(bots, {value, bot_id}) do
    bot = Map.get(bots, bot_id, %Bot{id: bot_id})
    updated_bot = %{bot | values: Enum.sort([value | bot.values])}
    Map.put(bots, bot_id, updated_bot)
  end

  defp process(steps, [bot_id, l_type, l_id, h_type, h_id]) do
    step = %Instruction{bot: bot_id, l_type: l_type, l_id: l_id, h_type: h_type, h_id: h_id}
    steps ++ [step]
  end

  defparsec(
    :value,
    ignore(string("value "))
    |> integer(max: 3)
    |> ignore(string(" goes to bot "))
    |> integer(max: 3)
  )

  defparsec(
    :transfer,
    ignore(string("bot "))
    |> integer(max: 3)
    |> ignore(string(" gives low to "))
    |> choice([string("bot"), string("output")])
    |> ignore(string(" "))
    |> integer(max: 3)
    |> ignore(string(" and high to "))
    |> choice([string("bot"), string("output")])
    |> ignore(string(" "))
    |> integer(max: 3)
  )
end
