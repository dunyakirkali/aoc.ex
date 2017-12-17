module Day16
  class Part2
    def self.run(string, dance)
      str = string.split('')
      # seen = []
      # 1_000_000_000.times do |i|
      55.times do |i|
        # puts "str: #{str} & i: #{i}"
        #
        # if seen.include?(str.join)
        #   puts i
        #   exit
        # end
        # seen << str.join
        dance.each do |step|
          # puts "\t step: #{step}"
          case step[0]
          when 's'
            pic = step.slice(1, step.length - 1)
            str = str.rotate(pic.to_i * -1)
          when 'x'
            pic = step.slice(1, step.length - 1)
            lp = pic.split('/')[0].to_i
            rp = pic.split('/')[1].to_i

            str[lp], str[rp] = str[rp], str[lp]
          when 'p'
            pic = step.slice(1, step.length - 1)
            splits = pic.split('/')
            lp = splits[0]
            rp = splits[1]

            lpi = str.index(lp.strip)
            rpi = str.index(rp.strip)

            str[lpi], str[rpi] = str[rpi], str[lpi]
          end
        end
      end
      str.join
    end
  end
end
