defmodule M do
  def look_n_say(str, acc) when acc == 40, do: str
  def look_n_say(str, acc) when acc < 40 do
    new_str = str
    |> String.graphemes
    |> Enum.chunk_by(fn arg -> arg end)
    |> Enum.map(fn(chunk) ->
      Integer.to_string(length(chunk)) <> List.first(chunk)
    end)
    |> Enum.join
    look_n_say(new_str, acc + 1)
  end
end

"1113122113"
|> M.look_n_say(0)
|> String.length
|> IO.inspect
