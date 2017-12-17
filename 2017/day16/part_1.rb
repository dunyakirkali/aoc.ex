module Day16
  class Part1
    def self.run(string, dance)
      str = string.split('')
      dance.each do |step|
        case step[0]
        when 's'
          step.slice!(0)
          str = str.rotate(step.to_i * -1)
        when 'x'
          step.slice!(0)
          lp = step.split('/')[0].to_i
          rp = step.split('/')[1].to_i

          str[lp], str[rp] = str[rp], str[lp]
        when 'p'
          step.slice!(0)
          splits = step.split('/')
          lp = splits[0]
          rp = splits[1]

          lpi = str.index(lp.strip)
          rpi = str.index(rp.strip)

          str[lpi], str[rpi] = str[rpi], str[lpi]
        end
      end
      str.join
    end
  end
end
