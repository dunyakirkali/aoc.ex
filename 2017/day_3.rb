class Day3
  @mat = {}
  @board_size = 0
  @destination

  def self.run(destination)
    @destination = destination
    calculate_board_size()
    arr = (1..@board_size).step(2).to_a

    arr.each_with_index do |ss, index|
      if ss == 1
        @mat[1] = [0, 0]
      else
        increment_previous
        fill_mat_for_layer(ss)
        clear_previous(ss)
      end
    end

    (center.first - @mat[destination].first).abs + (center.last - @mat[destination].last).abs
  end

  def self.clear_previous(ss)
    @mat = @mat.to_a.last(ss * ss).to_h
  end

  def self.increment_previous
    @mat.each do |key, value|
      value[0] = value[0] + 1
      value[1] = value[1] + 1
    end
  end

  def self.center
    [(@board_size / 2).floor, (@board_size / 2).floor]
  end

  def self.calculate_board_size
    size = 1
    loop do
      break if @destination <= size * size
      size += 2
    end
    @board_size = size
  end

  def self.fill_mat_for_layer(ss)
    loop do
      curr = @mat[@mat.count]
      break if curr[0] == ss - 1
      @mat[@mat.count + 1] = [@mat[@mat.count][0] + 1, @mat[@mat.count][1]]
    end

    loop do
      curr = @mat[@mat.count]
      break if curr[1] == 0
      @mat[@mat.count + 1] = [@mat[@mat.count][0], @mat[@mat.count][1] - 1]
    end

    loop do
      curr = @mat[@mat.count]
      break if curr[0] == 0
      @mat[@mat.count + 1] = [@mat[@mat.count][0] - 1, @mat[@mat.count][1]]
    end

    loop do
      curr = @mat[@mat.count]
      break if curr[1] == ss - 1
      @mat[@mat.count + 1] = [@mat[@mat.count][0], @mat[@mat.count][1] + 1]
    end

    loop do
      curr = @mat[@mat.count]
      break if curr[0] == ss - 1
      @mat[@mat.count + 1] = [@mat[@mat.count][0] + 1, @mat[@mat.count][1]]
    end
  end
end
