input = """
jio a, +18
inc a
tpl a
inc a
tpl a
tpl a
tpl a
inc a
tpl a
inc a
tpl a
inc a
inc a
tpl a
tpl a
tpl a
inc a
jmp +22
tpl a
inc a
tpl a
inc a
inc a
tpl a
inc a
tpl a
inc a
inc a
tpl a
tpl a
inc a
inc a
tpl a
inc a
inc a
tpl a
inc a
inc a
tpl a
jio a, +8
inc b
jie a, +4
tpl a
inc a
jmp +2
hlf a
jmp -7
"""

computer = %{a: 0, b: 0}

input
  |> String.split("\n", trim: true)
  |> Enum.map(&(String.split(&1, " ")))
  |> Enum.reduce(computer, fn(line, acc) ->
    case line do
      ["hlf", r] ->
        reg = String.to_atom(r)
        Map.put(acc, reg, Map.get(acc, reg) / 2)
      ["tpl", r] ->
        reg = String.to_atom(r)
        Map.put(acc, reg, Map.get(acc, reg) * 3)
      ["inc", r] ->
        reg = String.to_atom(r)
        Map.put(acc, reg, Map.get(acc, reg) + 1)
      ["jmp", offset] ->
        IO.inspect "jump #{offset}"
        acc
      ["jie", r, offset] ->
        reg = String.to_atom(String.slice(r, 0, String.length(r) -1))
        if rem(Map.get(acc, reg), 2) == 0 do
          IO.inspect "jump #{offset}"
          acc
        else
          acc
        end
      ["jio", r, offset] ->
        reg = String.to_atom(String.slice(r, 0, String.length(r) -1))
        if rem(Map.get(acc, reg), 2) == 1 do
          IO.inspect "jump #{offset}"
          acc
        else
          acc
        end
    end
  end)
  |> Map.get(:b)
  |> IO.inspect
