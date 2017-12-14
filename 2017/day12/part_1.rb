module Day12
  class Part1
    def self.run(seq)
      @leads_to_zero = []
      @connections = {}
      @seq = seq

      parse_connections

      @connections.each do |node_name, _|
        @visited = []
        if leads_to_zero?(node_name)
          @leads_to_zero << node_name
        end
      end

      @leads_to_zero.count
    end

    def self.parse_connections
      @seq.each do |item|
        split = item.strip.split(" <-> ")
        node = split[0]
        connections = split[1].split(", ")
        @connections[node] = connections
      end
    end

    def self.leads_to_zero?(node)
      @visited << node
      conns = @connections[node]
      return true if node == "0"
      return true if conns.include?("0")

      conns.map { |conn|
        if @visited.include?(conn)
          false
        else
          leads_to_zero?(conn)
        end
      }.any?
    end
  end
end
