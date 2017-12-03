class Day1_2
  def self.run(s_input)
    return 0 if s_input.length < 2
    jump = s_input.length / 2
    sum = 0
    s_input.chars.each_with_index do |curr_digit, index|
      pair = s_input[(index + jump) % s_input.length]
      sum += curr_digit.to_i if pair == curr_digit
    end
    sum
  end
end
