lines = File.readlines('priv/input.txt').map(&:strip)

bots = lines.map do |line|
  line.scan(/-?\d+/).map(&:to_i)
end

START = 2**28
DIVISOR = 2

mult = START

xs = bots.map{ |b| b[0] / mult }
ys = bots.map{ |b| b[1] / mult }
zs = bots.map{ |b| b[2] / mult }

rx = xs.min..xs.max
ry = ys.min..ys.max
rz = zs.min..zs.max

loop do
  best = [0,0,0,0]
  mbots = bots.map { |bot| bot.map { |c| c / mult } }

  rx.each do |x|
    ry.each do |y|
      rz.each do |z|
        c = mbots.count do |bot|
          ((bot[0]-x).abs + (bot[1]-y).abs + (bot[2]-z).abs) <= bot[3]
        end
        next if c < best.last
        next if c == best.last && (x.abs+y.abs+z.abs > best[0].abs+best[1].abs+best[2].abs)
        best = [x,y,z,c]
      end
    end
  end

  rx = ((best[0] - 1) * DIVISOR)..((best[0] + 1) * DIVISOR)
  ry = ((best[1] - 1) * DIVISOR)..((best[1] + 1) * DIVISOR)
  rz = ((best[2] - 1) * DIVISOR)..((best[2] + 1) * DIVISOR)

  p [mult, best]

  (p best[0].abs+best[1].abs+best[2].abs; exit) if mult == 1
  mult /= DIVISOR
end