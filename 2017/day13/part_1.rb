module Day13
  class Part1
    def self.run(seq)
      @state = {}
      @scanner = {}
      @directions = {}
      @sum = 0
      @position = -1

      seq.each do |line|
        splits = line.split(": ")
        register = splits.first
        steps = splits.last.strip
        @state[register] = steps.to_i
        @scanner[register] = 0
        @directions[register] = 1
      end

      (seq.last.split(": ").first.to_i + 1).times do
        @position += 1

        if @state.keys.include?(@position.to_s)
          if @scanner[@position.to_s] == 0
            puts "#{@position} * #{@state[@position.to_s]}"
            @sum += @position * @state[@position.to_s]
          end
        end

        scan
      end

      @sum
    end

    def self.debug
      puts "->"
      puts "@state: #{@state}"
      puts "@scanner: #{@scanner}"
      puts "@directions: #{@directions}"
      puts "<-"
    end

    def self.scan
      @state.each do |key, value|
        @scanner[key] += @directions[key]
        @directions[key] = -1 if @scanner[key] == value - 1
        @directions[key] = 1 if @scanner[key] == 0
      end
    end
  end
end
