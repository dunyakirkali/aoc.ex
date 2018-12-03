field = {}
ids = []
captures = []
do_break = false
File.open("input.txt", "r") do |f|
  f.each_line do |line|
    capture = line.match(/#(?<id>\d+)\s@\s(?<x>\d+),(?<y>\d*):\s(?<width>\d*)x(?<height>\d*).*/)
    captures.push({id: capture[:id], x: capture[:x], y: capture[:y], width: capture[:width], height: capture[:height]})
    ids.push(capture[:id])
  end
end

captures.each { |capture|
  for i in capture[:x].to_i..(capture[:x].to_i + capture[:width].to_i - 1)
    for j in capture[:y].to_i..(capture[:y].to_i + capture[:height].to_i - 1)
      key = "#{i}x#{j}"
      if field[key].nil?
        field[key] = [capture[:id]]
      else
        field[key].push(capture[:id])
      end
    end
  end
}

field.select { |key, value|
  value.count > 1
}.values.flatten.uniq.each { |item|
  ids.delete(item)
}

puts "=> #{ids}"
