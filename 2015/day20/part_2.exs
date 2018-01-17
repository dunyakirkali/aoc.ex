defmodule Proper do
  def divisors(1), do: []
  def divisors(n), do: [1 | divisors(2,n,:math.sqrt(n))] |> Enum.sort
 
  defp divisors(k,_n,q) when k>q, do: []
  defp divisors(k,n,q) when rem(n,k)>0, do: divisors(k+1,n,q)
  defp divisors(k,n,q) when k * k == n, do: [k | divisors(k+1,n,q)]
  defp divisors(k,n,q)                , do: [k,div(n,k) | divisors(k+1,n,q)]
 
  def most_divisors(limit) do
    {length,nums} = Enum.group_by(1..limit, fn n -> length(divisors(n)) end)
                    |> Enum.max_by(fn {length,_nums} -> length end)
    IO.puts "With #{length}, Number #{inspect nums} has the most divisors"
  end
end

input = 34_000_000
max_visit = 50
1..1_000_000_000
  |> Stream.with_index
  |> Stream.take_while(fn({value, _}) ->
    presents = Proper.divisors(value) ++ [value]
      |> Enum.map(fn(divisor) ->
        if value <= max_visit * divisor do
          divisor * 11
        else
          0
        end
      end)
      |> Enum.sum
    presents < input
  end)
  |> Enum.to_list
  |> List.last
  |> elem(0)
  |> Kernel.+(1)
  |> IO.inspect
