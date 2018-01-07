input = "bgvyzdsv"

Stream.take_while(0..10_000_000_000, fn(num) ->
  start = input <> Integer.to_string(num)
    |> :erlang.md5
    |> Base.encode16(case: :lower)
    |> String.slice(0..5)
  start != "000000"
end)
  |> Enum.to_list
  |> List.last
  |> Kernel.+(1)
  |> IO.inspect
