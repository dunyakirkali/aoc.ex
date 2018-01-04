require 'matrix'

module Day22
  class Part1
    def self.run(pattern, iterations)
      @matrix = Matrix.rows(pattern.map { |e| e.strip.split('') })
      @current_node = [(@matrix.column_count / 2).floor, (@matrix.row_count / 2).floor]
      @direction = [0, -1]
      @infection = 0
      @specials = [
        #[2, 0], [0, 1]
      ]
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
      @direction = infected? ? turn_right : turn_left
      infected? ? clean : infect
      forward
    end
    
    def self.forward
      @current_node[0] +=  @direction[0]
      @current_node[1] +=  @direction[1]
      
      if @current_node[0] < 0 || @current_node[1] < 0 || @current_node[0] == @matrix.column_count || @current_node[1] == @matrix.row_count
        grow
      end
    end
    
    def self.grow
      @current_node[0] += 1
      @current_node[1] += 1
      
      @specials.each { |chr| chr[0] += 1; chr[1] += 1 }

      @matrix = Matrix.build(@matrix.row_count + 2, @matrix.column_count + 2) { |row, col|
        if row == 0 || col == 0 || row == @matrix.row_count + 1 || col == @matrix.column_count + 1
          '.'
        else
          @matrix[row - 1, col - 1]
        end
      }
    end
    
    def self.clean
      # puts 'clean'
      @matrix = Matrix.build(@matrix.row_count, @matrix.column_count) { |row, col|
        if row == @current_node[1] && col == @current_node[0]
          '.'
        else
          @matrix[row, col]
        end
      }
    end
    
    def self.infect
      # puts "infect #{@special}"
      @infection += 1 unless @specials.include?(@current_node)
      @matrix = Matrix.build(@matrix.row_count, @matrix.column_count) { |row, col|
        if row == @current_node[1] && col == @current_node[0]
          '#'
        else
          @matrix[row, col]
        end
      }
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
    
    def self.infected?
      node == '#'
    end
    
    def self.node
      @matrix[@current_node[1], @current_node[0]]
    end
      
  end
end
