input = """
Rudolph can fly 22 km/s for 8 seconds, but then must rest for 165 seconds.
Cupid can fly 8 km/s for 17 seconds, but then must rest for 114 seconds.
Prancer can fly 18 km/s for 6 seconds, but then must rest for 103 seconds.
Donner can fly 25 km/s for 6 seconds, but then must rest for 145 seconds.
Dasher can fly 11 km/s for 12 seconds, but then must rest for 125 seconds.
Comet can fly 21 km/s for 6 seconds, but then must rest for 121 seconds.
Blitzen can fly 18 km/s for 3 seconds, but then must rest for 50 seconds.
Vixen can fly 20 km/s for 4 seconds, but then must rest for 75 seconds.
Dancer can fly 7 km/s for 20 seconds, but then must rest for 119 seconds.
"""

deers = input
|> String.split("\n", trim: true)
|> Enum.reduce([], fn(line, acc) ->
  [name, "can", "fly", speed, "km/s", "for", duration, "seconds,", "but", "then", "must", "rest", "for", rest_time, "seconds."] = String.split(line, " ")

  acc ++ [%{name: name, speed: String.to_integer(speed), duration: String.to_integer(duration), rest_time: String.to_integer(rest_time)}]
end)
|> Enum.reduce([], fn(deer, acc) ->
  cycle = deer[:duration] + deer[:rest_time]
  remainder = Integer.mod(2503, cycle)
  divident = div(2503, cycle)
  
  distance = divident * deer[:speed] * deer[:duration]
  rest = 
    if remainder < deer[:duration] do
      remainder * deer[:speed]
    else
      deer[:duration] * deer[:speed]
    end
  acc ++ [distance + rest]
end)
|> Enum.max
|> IO.inspect
