defmodule Aoc.Day20 do
  use Memoize

  @doc """
      iex> "priv/day20/example.txt" |> Aoc.Day20.input() |> Aoc.Day20.part1()
      32000000

      iex> "priv/day20/example2.txt" |> Aoc.Day20.input() |> Aoc.Day20.part1()
      11687500
  """
  def part1(state) do
    1..1000
    |> Enum.reduce({state, {0, 0}}, fn _, {s, {hc, lc}} ->
      run([{:button, "broadcaster", :low}], s, {hc, lc})
    end)
    |> then(fn {_, {hc, lc}} ->
      IO.inspect({hc, lc})
      hc * lc
    end)
  end

  def run([{:button, "broadcaster", :low}], state, {hc, lc}) do
    commands =
      Enum.find(state, fn obj -> obj.name == "broadcaster" end).cons
      |> Enum.map(fn con -> {"broadcaster", con, :low} end)

    run(commands, state, {hc, lc + 1})
  end

  def run([{from, to, pulse} | t], state, {hc, lc}) do
    # IO.inspect(state)
    # IO.puts("#{from} -#{pulse}-> #{to}")

    component =
      Enum.find(state, fn obj -> obj.name == to end)

    if component == nil do
      # IO.puts("output")
      run(t, state, if(pulse == :high, do: {hc + 1, lc}, else: {hc, lc + 1}))
    else
      case component.type do
        :flip_flop ->
          case pulse do
            :high ->
              run(t, state, if(pulse == :high, do: {hc + 1, lc}, else: {hc, lc + 1}))

            :low ->
              commands =
                Enum.map(component.cons, fn con ->
                  {to, con, if(component.state == :off, do: :high, else: :low)}
                end)

              state =
                Enum.map(state, fn obj ->
                  if obj.name == to do
                    Map.put(obj, :state, if(component.state == :off, do: :on, else: :off))
                  else
                    obj
                  end
                end)

              run(t ++ commands, state, if(pulse == :high, do: {hc + 1, lc}, else: {hc, lc + 1}))
          end

        :conjunction ->
          state =
            Enum.map(state, fn obj ->
              if obj.name == to do
                Map.put(obj, :states, Map.put(obj.states, from, pulse))
              else
                obj
              end
            end)

          # |> IO.inspect()

          component = Enum.find(state, fn obj -> obj.name == to end)

          to_send =
            Enum.all?(component.states, fn {_, v} -> v == :high end)

          # |> IO.inspect()

          commands =
            Enum.map(component.cons, fn con ->
              {to, con, if(to_send, do: :low, else: :high)}
            end)

          run(t ++ commands, state, if(pulse == :high, do: {hc + 1, lc}, else: {hc, lc + 1}))
      end
    end
  end

  def run([], state, {hc, lc}), do: {state, {hc, lc}}

  def part2(state) do
    # Stream.iterate(0, &(&1 + 1))
    # |> Enum.reduce_while(state, fn i, s ->
    #   {ns, _} = run([{:button, "broadcaster", :low}], s, {0, 0})
    #
    #   {:cont, ns}
    # end)
    ["sj", "qq", "ls", "bg"]

    ["hb", "hf", "dl", "lq"]

    Stream.iterate(0, &(&1 + 1))
    |> Enum.reduce_while(state, fn i, s ->
      IO.inspect(i)
      {ns, _} = run([{:button, "broadcaster", :low}], s, {0, 0})
      sj = ns |> Enum.find(fn obj -> obj.name == "qq" end)

      sjs = Enum.all?(sj.states, fn {_, v} -> v == :high end)

      if sjs == false do
        {:halt, i}
      else
        {:cont, ns}
      end
    end)
  end

  def input(filename) do
    state =
      filename
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [from, to] = String.split(line, " -> ", trim: true)

        tos = String.split(to, ", ", trim: true)

        cond do
          String.starts_with?(from, "&") ->
            %{
              name: String.slice(from, 1, String.length(from) - 1),
              type: :conjunction,
              cons: tos,
              states: %{}
            }

          String.starts_with?(from, "%") ->
            %{
              name: String.slice(from, 1, String.length(from) - 1),
              type: :flip_flop,
              cons: tos,
              state: :off
            }

          "broadcaster" ->
            %{name: "broadcaster", type: :broadcaster, cons: tos}
        end
      end)

    all_conjunctions =
      Enum.filter(state, fn obj ->
        obj.type == :conjunction
      end)
      |> Enum.map(fn c -> c.name end)
      |> Enum.map(fn c ->
        {c,
         Enum.filter(state, fn obj ->
           Enum.member?(obj.cons, c)
         end)
         |> Enum.map(fn obj -> {obj.name, :low} end)
         |> Enum.into(%{})}
      end)
      |> Enum.into(%{})

    state
    |> Enum.map(fn obj ->
      if obj.type == :conjunction do
        Map.put(obj, :states, Map.get(all_conjunctions, obj.name))
      else
        obj
      end
    end)
  end
end
