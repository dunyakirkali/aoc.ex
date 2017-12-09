module Day9
  class Part2
    def self.run(seq)
      @current_value = 0
      @line_value = 0
      @ignore = false
      @skip_one = false
      @sum = 0

      seq.split('').each do |char|
        next @skip_one = false if @skip_one

        if @ignore
          case char
          when ?>
            @ignore = false
          when ?!
            @skip_one = true
          else
            @sum += 1
          end
        else
          case char
          when ?{
            @line_value += @current_value += 1
          when ?}
            @current_value -= 1
          when ?<
            @ignore = true
          end
        end
      end
      @sum
    end
  end
end
