require 'tree'

module Day7
  class Part2
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
      root = @nodes.find { |node| node.parent.nil? }

      root.children.each do |child|
        # puts "#{child.name} => #{find_balance(child)}"
        if child.name == "lsire"
          child.children.each do |sub_child|
            # puts "#{sub_child.name} => #{find_balance(sub_child)}"
            if sub_child.name == "ycpcv"
              sub_child.children.each do |sub_sub_child|
                puts "#{sub_sub_child.name} => #{find_balance(sub_sub_child)}"
              end
            end
          end
        end
      end
    end

    def self.create_all_nodes
      @nodes = @seq.map { |row|
        data = row.split(" ")
        name = data[0]
        weight = data[1].match('\((\d+)\)')[1]
        node = Tree::TreeNode.new(name, weight)
      }
    end

    def self.find_balance(root)
      if root.children.count == 0
        root.content.to_i
      else
        root.children.inject(0) { |sum, child| sum + find_balance(child) } + root.content.to_i
      end
    end
  end
end
