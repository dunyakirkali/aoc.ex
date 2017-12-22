require 'matrix'

module Day19
  class Part1
    def self.run(lines)
      @matrix = Matrix[]
      @position = [0, 0]
      @direction = [0, 1]
      @visited = ""
      
      max = lines.map { |line| line.split("").length }.max
      lines.each do |line|
        @matrix = Matrix.rows(@matrix.to_a << line.split(""))
      end

      find_start

      val = @matrix.row(@position.last).to_a[@position.first]
      while val != " "
        walk(val)
        val = @matrix.row(@position.last).to_a[@position.first]
      end
      @visited
    end

    def self.find_start
      @position = [@matrix.row(0).to_a.index("|"), 0]
    end

    def self.define_direction
      if @direction.first == 0
        if @matrix.row(@position.last).to_a[@position.first + 1] == " "
          @direction = [-1, 0]
        else
          @direction = [1, 0]
        end
      else
        if @matrix.row(@position.last + 1).to_a[@position.first] == " "
          @direction = [0, -1]
        else
          @direction = [0, 1]
        end
      end
    end

    def self.walk(val)
      if val == "+"
        define_direction
      end
      @visited << val if val != "+" && val != "|" && val != "-"
      @position = [@position.first + @direction.first, @position.last + @direction.last]
    end
  end
end
