module Day9
  class Part1
    def self.run(seq)
      @stack = []
      @sum = 0
      @ignore = false
      @skip_one = false

      seq.split('').each do |char|
        if @skip_one
          @skip_one = false
          next
        end

        if char == '!'
          @skip_one = true
          next
        end

        if @ignore
          @ignore = false if char == '>'
          next
        end

        case char
        when '{'
          @stack.push(@stack.count + 1)
        when '}'
          @sum += @stack.pop
        when '<'
          @ignore = true
        end
      end
      @sum
    end
  end
end
