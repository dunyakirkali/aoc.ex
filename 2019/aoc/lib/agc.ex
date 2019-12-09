defmodule AGC do
  defstruct [:instructions, output: [], inputs: [], ip: 0, state: :cont, relative_base_offset: 0]

  def new(filename) do
    instructions = input(filename)
    memory = for _ <- 0..5_000_000, do: 0
    %AGC{instructions: instructions ++ memory}
  end

  def run(machine) do
    ip = machine.ip
    opcode = Enum.at(machine.instructions, ip)
    machine =
      case opcode do
        00001 ->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          add(machine, ini1, ini2, outi, :position, :position, :position)
        00101 ->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          add(machine, ini1, ini2, outi, :immediate, :position, :position)
        01001 ->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          add(machine, ini1, ini2, outi, :position, :immediate, :position)
        01101 ->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          add(machine, ini1, ini2, outi, :immediate, :immediate, :position)
        01201 ->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          add(machine, ini1, ini2, outi, :relative, :immediate, :position)
        02101 ->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          add(machine, ini1, ini2, outi, :immediate, :relative, :position)
        21101 ->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          add(machine, ini1, ini2, outi, :immediate, :immediate, :relative)
        21201 ->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          add(machine, ini1, ini2, outi, :relative, :immediate, :relative)
        22201 ->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          add(machine, ini1, ini2, outi, :relative, :relative, :relative)

        00002 ->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          mul(machine, ini1, ini2, outi, :position, :position, :position)
        00102 ->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          mul(machine, ini1, ini2, outi, :immediate, :position, :position)
        1202 ->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          mul(machine, ini1, ini2, outi, :relative, :immediate, :position)
        01002 ->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          mul(machine, ini1, ini2, outi, :position, :immediate, :position)
        01102 ->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          mul(machine, ini1, ini2, outi, :immediate, :immediate, :position)
        02102 ->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          mul(machine, ini1, ini2, outi, :immediate, :relative, :position)
        21102 ->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          mul(machine, ini1, ini2, outi, :immediate, :immediate, :relative)
        22102 ->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          mul(machine, ini1, ini2, outi, :immediate, :relative, :relative)
        21202 ->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          mul(machine, ini1, ini2, outi, :relative, :immediate, :relative)

        003->
          [_, ini] = Enum.slice(machine.instructions, ip, 2)
          input(machine, ini, :position)
        203->
          [_, ini] = Enum.slice(machine.instructions, ip, 2)
          input(machine, ini, :relative)

        004 ->
          [_, ini] = Enum.slice(machine.instructions, ip, 2)
          output(machine, ini, :position)
        104 ->
          [_, ini] = Enum.slice(machine.instructions, ip, 2)
          output(machine, ini, :immediate)
        204 ->
          [_, ini] = Enum.slice(machine.instructions, ip, 2)
          output(machine, ini, :relative)

        0005->
          [_, ini1, ini2] = Enum.slice(machine.instructions, ip, 3)
          jump_if_true(machine, ini1, ini2, :position, :position)
        0105->
          [_, ini1, ini2] = Enum.slice(machine.instructions, ip, 3)
          jump_if_true(machine, ini1, ini2, :immediate, :position)
        1005->
          [_, ini1, ini2] = Enum.slice(machine.instructions, ip, 3)
          jump_if_true(machine, ini1, ini2, :position, :immediate)
        1105->
          [_, ini1, ini2] = Enum.slice(machine.instructions, ip, 3)
          jump_if_true(machine, ini1, ini2, :immediate, :immediate)
        1205->
          [_, ini1, ini2] = Enum.slice(machine.instructions, ip, 3)
          jump_if_true(machine, ini1, ini2, :relative, :immediate)
        2105->
          [_, ini1, ini2] = Enum.slice(machine.instructions, ip, 3)
          jump_if_true(machine, ini1, ini2, :immediate, :relative)

        0006->
          [_, ini1, ini2] = Enum.slice(machine.instructions, ip, 3)
          jump_if_false(machine, ini1, ini2, :position, :position)
        0106->
          [_, ini1, ini2] = Enum.slice(machine.instructions, ip, 3)
          jump_if_false(machine, ini1, ini2, :immediate, :position)
        1006->
          [_, ini1, ini2] = Enum.slice(machine.instructions, ip, 3)
          jump_if_false(machine, ini1, ini2, :position, :immediate)
        1106->
          [_, ini1, ini2] = Enum.slice(machine.instructions, ip, 3)
          jump_if_false(machine, ini1, ini2, :immediate, :immediate)
        1206->
          [_, ini1, ini2] = Enum.slice(machine.instructions, ip, 3)
          jump_if_false(machine, ini1, ini2, :relative, :immediate)
        2106->
          [_, ini1, ini2] = Enum.slice(machine.instructions, ip, 3)
          jump_if_false(machine, ini1, ini2, :immediate, :relative)

        00007->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          less_than(machine, ini1, ini2, outi, :position, :position, :position)
        00107->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          less_than(machine, ini1, ini2, outi, :immediate, :position, :position)
        01007->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          less_than(machine, ini1, ini2, outi, :position, :immediate, :position)
        01107->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          less_than(machine, ini1, ini2, outi, :immediate, :immediate, :position)
        01207->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          less_than(machine, ini1, ini2, outi, :relative, :immediate, :position)
        02107->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          less_than(machine, ini1, ini2, outi, :immediate, :relative, :position)
        21107->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          less_than(machine, ini1, ini2, outi, :immediate, :immediate, :relative)

        00008->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          equals(machine, ini1, ini2, outi, :position, :position)
        00108->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          equals(machine, ini1, ini2, outi, :immediate, :position)
        01008->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          equals(machine, ini1, ini2, outi, :position, :immediate)
        01108->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          equals(machine, ini1, ini2, outi, :immediate, :immediate)
        01208->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          equals(machine, ini1, ini2, outi, :relative, :immediate, :position)
        21108->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          equals(machine, ini1, ini2, outi, :immediate, :immediate, :relative)
        2108->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          equals(machine, ini1, ini2, outi, :immediate, :relative, :position)

        009->
          [_, ini] = Enum.slice(machine.instructions, ip, 2)
          adjust_relative_base(machine, ini, :position)
        109->
          [_, ini] = Enum.slice(machine.instructions, ip, 2)
          adjust_relative_base(machine, ini, :immediate)
        209->
          [_, ini] = Enum.slice(machine.instructions, ip, 2)
          adjust_relative_base(machine, ini, :relative)

        99 ->
          %AGC{machine | state: :halt}
      end

    case machine.state do
      :cont ->
        run(machine)
      :halt ->
        machine
      :wait ->
        machine
    end
  end

  def set(machine, noun, verb) do
    new_instructions =
      machine.instructions
      |> List.replace_at(1, noun)
      |> List.replace_at(2, verb)

    %AGC{machine | instructions: new_instructions}
  end

  defp input(filename) do
    filename
    |> File.read!()
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(fn x ->
      String.to_integer(x)
    end)
  end

  defp input(machine, ini, m1) do
    ip = machine.ip
    if Enum.count(machine.inputs) == 0 do
      %AGC{machine | state: :wait}
    else
      [input | remaining_input] = machine.inputs
      ini = in_value(machine, ini, m1)

      instructions = List.replace_at(machine.instructions, ini, input)

      %AGC{machine | instructions: instructions, ip: ip + 2, inputs: remaining_input, state: :cont}
    end
  end

  defp adjust_relative_base(machine, ini, m1) do
    ip = machine.ip
    rbo = machine.relative_base_offset
    in1 = value(m1, machine, ini)

    %AGC{machine | ip: ip + 2, relative_base_offset: rbo + in1}
  end

  defp output(machine, ini, m1) do
    ip = machine.ip
    in1 = value(m1, machine, ini)
    out = machine.output

    %AGC{machine | ip: ip + 2, output: out ++ [in1]}
  end

  defp jump_if_true(machine, ini1, ini2, m1, m2) do
    ip = machine.ip
    in1 = value(m1, machine, ini1)
    in2 = value(m2, machine, ini2)

    if in1 != 0 do
      %AGC{machine | ip: in2}
    else
      %AGC{machine | ip: ip + 3}
    end
  end

  defp jump_if_false(machine, ini1, ini2, m1, m2) do
    ip = machine.ip
    in1 = value(m1, machine, ini1)
    in2 = value(m2, machine, ini2)

    if in1 == 0 do
      %AGC{machine | ip: in2}
    else
      %AGC{machine | ip: ip + 3}
    end
  end

  defp less_than(machine, ini1, ini2, outi, m1, m2, m3) do
    ip = machine.ip
    in1 = value(m1, machine, ini1)
    in2 = value(m2, machine, ini2)
    outi = out_value(m3, machine, outi)
    if in1 < in2 do
      instructions = List.replace_at(machine.instructions, outi, 1)

      %AGC{machine | instructions: instructions, ip: ip + 4}
    else
      instructions = List.replace_at(machine.instructions, outi, 0)

      %AGC{machine | instructions: instructions, ip: ip + 4}
    end
  end

  defp equals(machine, ini1, ini2, outi, m1, m2, m3 \\ :position) do
    ip = machine.ip
    in1 = value(m1, machine, ini1)
    in2 = value(m2, machine, ini2)
    outi = out_value(m3, machine, outi)

    if in1 == in2 do
      instructions = List.replace_at(machine.instructions, outi, 1)
      %AGC{machine | instructions: instructions, ip: ip + 4}
    else
      instructions = List.replace_at(machine.instructions, outi, 0)
      %AGC{machine | instructions: instructions, ip: ip + 4}
    end
  end

  defp mul(machine, ini1, ini2, outi, m1, m2, m3) do
    ip = machine.ip
    in1 = value(m1, machine, ini1)
    in2 = value(m2, machine, ini2)
    outi = out_value(m3, machine, outi)

    instructions = List.replace_at(machine.instructions, outi, in1 * in2)
    %AGC{machine | instructions: instructions, ip: ip + 4}
  end

  defp add(machine, ini1, ini2, outi, m1, m2, m3) do
    ip = machine.ip
    in1 = value(m1, machine, ini1)
    in2 = value(m2, machine, ini2)
    outi = out_value(m3, machine, outi)

    instructions = List.replace_at(machine.instructions, outi, in1 + in2)
    %AGC{machine | instructions: instructions, ip: ip + 4}
  end

  defp value(mode, machine, val) do
    case mode do
      :position ->
        Enum.at(machine.instructions, val)
      :immediate ->
        val
      :relative ->
        Enum.at(machine.instructions, machine.relative_base_offset + val)
    end
  end

  def in_value(machine, val, :position), do: Enum.at(machine.instructions, val)
  def in_value(machine, val, :relative), do: val + machine.relative_base_offset
  def in_value(_, val, :immediate), do: val

  defp out_value(mode, machine, val) do
    case mode do
      :position ->
        val
      :relative ->
        val + machine.relative_base_offset
    end
  end
end
