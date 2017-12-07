require 'tree'

module Day7
  class Part1
    def self.run(seq)
      @seq = seq

      create_all_nodes

      @seq.each { |row|
        data = row.split(" ")
        name = data[0]
        children_row = row.split(" -> ")[1]

        if children_row
          children_row = children_row.strip
          children = children_row.split(", ")
          root = @nodes.find { |node| node.name == name }
          children.each do |child|
            child_node = @nodes.find { |node| node.name == child }
            root << child_node
          end
        end
      }
      @nodes.find { |node| node.parent.nil? }.name
    end

    def self.create_all_nodes
      @nodes = @seq.map { |row|
        data = row.split(" ")
        name = data[0]
        weight = data[1].match('\((\d+)\)')[1]
        node = Tree::TreeNode.new(name, weight)
      }
    end
  end
end
