input = "bgvyzdsv"

Stream.take_while(1..100_000_000, fn(num) ->
  start = input <> Integer.to_string(num)
    |> :erlang.md5
    |> Base.encode16(case: :lower)
    |> String.slice(0..4)
  start != "00000"
end)
  |> Enum.to_list
  |> List.last
  |> Kernel.+(1)
  |> IO.inspect
