module Day8
  class Part1
    def self.run(seq)
      @registers = {}
      seq.each { |line|
        register, action, condition = parse(line)
        @registers[register] = 0
      }

      seq.each { |line|
        register, action, condition = parse(line)
        if check(condition)
          execute(register, action)
        end
      }
      @registers.max_by { |k, v| v }.last
    end

    def self.parse(line)
      sides = line.split(" if ")
      register = sides.first.split(" ")[0]
      action = sides.first.split(" ")[1..-1]
      condition = sides.last

      [register, action, condition]
    end

    def self.check(condition)
      pieces = condition.split(" ")
      @registers[pieces[0]].send(pieces[1], pieces[2].to_i)
    end

    def self.execute(register, action)
      if action.first == "inc"
        @registers[register] += action.last.to_i
      else
        @registers[register] -= action.last.to_i
      end
    end
  end
end
