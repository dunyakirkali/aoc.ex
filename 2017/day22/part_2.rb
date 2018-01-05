require 'matrix'

module Day22
  class Part2
    def self.run(pattern, iterations)
      @matrix = Matrix.rows(pattern.map { |e| e.strip.split('') }).to_a
      @current_node = [(@matrix.first.count / 2).floor, (@matrix.count / 2).floor]
      @direction = [0, -1]
      @infection = 0

      # puts "-- #{@current_node} - #{@direction} --"
      
      # puts @matrix.to_a.map(&:inspect)
      # puts 's---------'
      iterations.times do |i|
        burst
        # puts @matrix.to_a.map(&:inspect)
        # puts 'm---------'
        # puts "-- #{@current_node} - #{@direction} --"
        # puts 'e---------'
      end
      
      @infection
    end
    
    def self.burst
      rotate
      update
      forward
    end
    
    def self.update
      case node
      when '#'
        flag
      when '.'
        weaken
      when 'W'
        infect
      when 'F'
        clean
      end
    end
    
    def self.rotate
      case node
      when '#'
        @direction = turn_right
      when '.'
        @direction = turn_left
      when 'W'
      when 'F'
        @direction = reverse
      end
    end
    
    def self.forward
      @current_node[0] +=  @direction[0]
      @current_node[1] +=  @direction[1]
      
      if @current_node[0] < 0 || @current_node[1] < 0 || @current_node[0] == @matrix.first.count || @current_node[1] == @matrix.count
        grow
      end
    end
    
    def self.grow
      @current_node[0] += 1
      @current_node[1] += 1

      @matrix = Matrix.build(@matrix.count + 2, @matrix.first.count + 2) { |row, col|
        if row == 0 || col == 0 || row == @matrix.count + 1 || col == @matrix.first.count + 1
          '.'
        else
          @matrix[row - 1][col - 1]
        end
      }.to_a
    end
    
    def self.clean
      # puts 'clean'
      @matrix[@current_node[1]][@current_node[0]] = '.'
    end
    
    def self.infect
      @infection += 1
      @matrix[@current_node[1]][@current_node[0]] = '#'
    end
    
    def self.weaken
      # puts "infect #{@special}"
      @matrix[@current_node[1]][@current_node[0]] = 'W'
    end
    
    def self.flag
      # puts "infect #{@special}"
      @matrix[@current_node[1]][@current_node[0]] = 'F'
    end

    def self.reverse
      # puts 'left'
      case @direction
      when [0, -1]
        [0, 1]
      when [1, 0]
        [-1, 0]
      when [0, 1]
        [0, -1]
      when [-1, 0]
        [1, 0]
      end
    end
        
    def self.turn_left
      # puts 'left'
      case @direction
      when [0, -1]
        [-1, 0]
      when [1, 0]
        [0, -1]
      when [0, 1]
        [1, 0]
      when [-1, 0]
        [0, 1]
      end
    end
    
    def self.turn_right
      # puts 'right'
      case @direction
      when [0, -1]
        [1, 0]
      when [1, 0]
        [0, 1]
      when [0, 1]
        [-1, 0]
      when [-1, 0]
        [0, -1]
      end
    end
    
    def self.node
      @matrix[@current_node[1]][@current_node[0]]
    end
      
  end
end
