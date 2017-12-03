class Day1
  def self.run(s_input)
    return 0 if s_input.length < 2

    prev_digit = s_input[s_input.length - 1]
    sum = 0
    s_input.chars.each_with_index do |curr_digit, index|
      sum += curr_digit.to_i if prev_digit == curr_digit
      prev_digit = curr_digit
    end
    sum
  end
end
