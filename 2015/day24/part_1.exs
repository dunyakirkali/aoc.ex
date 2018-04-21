input = """
1
2
3
5
7
13
17
19
23
29
31
37
41
43
53
59
61
67
71
73
79
83
89
97
101
103
107
109
113
"""

arr = input
|> String.split("\n", trim: true)
|> Enum.map(&String.to_integer/1)

bucket_size = (arr |> Enum.sum) / 3
|> IO.inspect
# |
# Generate groups
# |
[[[10, 3, 4], [9, 8], [17]], [[13, 4], [9, 8], [17]], [[13, 4], [9, 8], [18]]]
|> Enum.map(&(Enum.at(&1, 0)))
|> Enum.map(fn(list)-> 
  list |> Enum.reduce(1, fn(items, acc) ->
    acc * items
  end)
end)
|> Enum.min
|> IO.inspect
