module Day12
  class Part2
    def self.run(seq)
      @leads_to = {}
      @connections = {}
      @seq = seq
      @resolved = []

      parse_connections

      (0..(seq.count)).map(&:to_s).each do |dest|
        next if @resolved.include?(dest)
        @leads_to[dest] = []
        @connections.each do |node_name, _|
          @visited = []
          if leads_to?(dest, node_name)
            @leads_to[dest] << node_name
          end
        end
        @resolved << @leads_to[dest]
        @resolved = @resolved.flatten
      end

      @leads_to.delete_if { |key, value|
        true if value.empty?
      }.count
    end

    def self.parse_connections
      @seq.each do |item|
        split = item.strip.split(" <-> ")
        node = split[0]
        connections = split[1].split(", ")
        @connections[node] = connections
      end
    end

    def self.leads_to?(dest, node)
      @visited << node
      conns = @connections[node]

      return true if node == dest
      return true if conns.include?(dest)

      conns.map { |conn|
        if @visited.include?(conn)
          false
        else
          leads_to?(dest, conn)
        end
      }.any?
    end
  end
end
