field = {}
File.open("input.txt", "r") do |f|
  f.each_line do |line|
    capture = line.match(/#(?<id>\d+)\s@\s(?<x>\d+),(?<y>\d*):\s(?<width>\d*)x(?<height>\d*).*/)
    puts capture[:x]
    for i in capture[:x].to_i..(capture[:x].to_i + capture[:width].to_i - 1)
      for j in capture[:y].to_i..(capture[:y].to_i + capture[:height].to_i - 1)
        key = "#{i}x#{j}"
        if field[key].nil?
          field[key] = 1
        else
          field[key] = field[key] + 1
        end
      end
    end
  end
end

res = field.values.select { |item|
  item > 1
}.count

puts "=> #{res}"
