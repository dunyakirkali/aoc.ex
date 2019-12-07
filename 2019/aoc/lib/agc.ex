defmodule AGC do
  defstruct [:instructions, :output, inputs: [], ip: 0, state: :cont]

  def new(filename) do
    instructions = input(filename)
    %AGC{instructions: instructions}
  end

  def run(machine) do
    ip = machine.ip
    opcode = Enum.at(machine.instructions, ip)
    machine =
      case opcode do
        00001 ->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          add(machine, ini1, ini2, outi, :position, :position)
        00101 ->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          add(machine, ini1, ini2, outi, :immediate, :position)
        01001 ->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          add(machine, ini1, ini2, outi, :position, :immediate)
        01101 ->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          add(machine, ini1, ini2, outi, :immediate, :immediate)

        00002 ->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          mul(machine, ini1, ini2, outi, :position, :position)
        00102 ->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          mul(machine, ini1, ini2, outi, :immediate, :position)
        01002 ->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          mul(machine, ini1, ini2, outi, :position, :immediate)
        01102 ->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          mul(machine, ini1, ini2, outi, :immediate, :immediate)

        3 ->
          [_, ini] = Enum.slice(machine.instructions, ip, 2)
          input(machine, ini)

        104 ->
          [_, ini] = Enum.slice(machine.instructions, ip, 2)
          output(machine, ini, :immediate)
        4 ->
          [_, ini] = Enum.slice(machine.instructions, ip, 2)
          output(machine, ini, :position)

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

        0007->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          less_than(machine, ini1, ini2, outi, :position, :position)
        0107->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          less_than(machine, ini1, ini2, outi, :immediate, :position)
        1007->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          less_than(machine, ini1, ini2, outi, :position, :immediate)
        1107->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          less_than(machine, ini1, ini2, outi, :immediate, :immediate)

        0008->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          equals(machine, ini1, ini2, outi, :position, :position)
        0108->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          equals(machine, ini1, ini2, outi, :immediate, :position)
        1008->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          equals(machine, ini1, ini2, outi, :position, :immediate)
        1108->
          [_, ini1, ini2, outi] = Enum.slice(machine.instructions, ip, 4)
          equals(machine, ini1, ini2, outi, :immediate, :immediate)

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

  defp input(machine, ini) do
    ip = machine.ip
    if Enum.count(machine.inputs) == 0 do
      %AGC{machine | state: :wait}
    else
      [input | remaining_input] = machine.inputs
      instructions = List.replace_at(machine.instructions, ini, input)
      %AGC{machine | instructions: instructions, ip: ip + 2, inputs: remaining_input, state: :cont}
    end
  end

  defp output(machine, ini, m1) do
    ip = machine.ip
    in1 = value(m1, machine, ini)

    %AGC{machine | ip: ip + 2, output: in1}
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

  defp less_than(machine, ini1, ini2, outi, m1, m2) do
    ip = machine.ip
    in1 = value(m1, machine, ini1)
    in2 = value(m2, machine, ini2)

    if in1 < in2 do
      instructions = List.replace_at(machine.instructions, outi, 1)

      %AGC{machine | instructions: instructions, ip: ip + 4}
    else
      instructions = List.replace_at(machine.instructions, outi, 0)

      %AGC{machine | instructions: instructions, ip: ip + 4}
    end
  end

  defp equals(machine, ini1, ini2, outi, m1, m2) do
    ip = machine.ip
    in1 = value(m1, machine, ini1)
    in2 = value(m2, machine, ini2)

    if in1 == in2 do
      instructions = List.replace_at(machine.instructions, outi, 1)

      %AGC{machine | instructions: instructions, ip: ip + 4}
    else
      instructions = List.replace_at(machine.instructions, outi, 0)

      %AGC{machine | instructions: instructions, ip: ip + 4}
    end
  end

  defp mul(machine, ini1, ini2, outi, m1, m2) do
    ip = machine.ip
    in1 = value(m1, machine, ini1)
    in2 = value(m2, machine, ini2)
    instructions = List.replace_at(machine.instructions, outi, in1 * in2)

    %AGC{machine | instructions: instructions, ip: ip + 4}
  end

  defp add(machine, ini1, ini2, outi, m1, m2) do
    ip = machine.ip
    in1 = value(m1, machine, ini1)
    in2 = value(m2, machine, ini2)

    instructions = List.replace_at(machine.instructions, outi, in1 + in2)

    %AGC{machine | instructions: instructions, ip: ip + 4}
  end

  defp value(mode, machine, val) do
    if mode == :position do
      Enum.at(machine.instructions, val)
    else
      val
    end
  end
end
