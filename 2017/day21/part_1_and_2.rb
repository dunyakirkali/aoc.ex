require 'matrix'

module Day21
  class Part1And2
    def self.run(rules, iterations)
      @rules = {}
      @pattern = Matrix[
        [".", "#", "."],
        [".", ".", "#"],
        ["#", "#", "#"]
      ]
      
      parse(rules)
      iterations.times do |i|
        # puts "---#{i} => #{@pattern}---"
        sub_matrices = subs(@pattern).map { |sp| transpose(sp) }
        @pattern = merge(sub_matrices)
        # puts "---#{i}---"
      end
      
      count
    end
    
    def self.merge(sub_matrices)
      return sub_matrices.first if sub_matrices.count == 1
      row_col_count = sub_matrices.first.row_count * Math.sqrt(sub_matrices.count)
      # puts "--> will pick #{sub_matrices}"
      Matrix.build(row_col_count, row_col_count) { |row, col|
        #########################################################
        scol = col / sub_matrices.first.row_count
        col_val = col % sub_matrices.first.row_count
        
        srow = row / sub_matrices.first.column_count
        row_val = row % sub_matrices.first.column_count
        
        
        pick = srow + (scol * Math.sqrt(sub_matrices.count))
        
        # puts "--> picked #{pick} [#{col_val}, #{row_val}]"
        
        picked_matrix = sub_matrices[pick]
        picked_matrix[row_val, col_val]
        #########################################################
      }
    end
    
    def self.transpose(pttr)
      # puts "from #{pattern_as_row(pttr)}"
      action = @rules[pattern_as_row(pttr)]
      try = 1
      org_ptt = pttr
      while action.nil? && try < 8
        if try == 1
          npttr = Matrix.columns(org_ptt.transpose.to_a.reverse)
        elsif try == 2
          npttr = Matrix.columns(org_ptt.to_a.reverse)
        elsif try == 3
          npttr = Matrix.rows(org_ptt.to_a.reverse)
        elsif try == 4
          npttr = Matrix.rows(org_ptt.to_a.reverse)
          npttr = Matrix.columns(npttr.to_a.reverse)
        elsif try == 5
          npttr = Matrix.columns(org_ptt.to_a.reverse)
          npttr = Matrix.columns(npttr.to_a.reverse)
        elsif try == 6
          npttr = Matrix.columns(org_ptt.to_a.reverse)
          npttr = Matrix.columns(npttr.to_a.reverse)
          npttr = Matrix.columns(npttr.to_a.reverse)
        elsif try == 7
          npttr = Matrix.columns(org_ptt.transpose.to_a.reverse)
          npttr = Matrix.columns(npttr.to_a.reverse)
        end
        # puts "r#{try} #{pattern_as_row(npttr)}"
        try += 1
        action = @rules[pattern_as_row(npttr)]
      end
      # puts "to #{action}"
      grid_from_pattern(action)
    end
    
    def self.subs(pttr)
      row_size = pttr.row_size
      mul = row_size % 2 == 0 ? 2 : 3
      piece_size = row_size / mul
      pieces = []
      piece_size.times do |i|
        piece_size.times do |j|
          r_rng_s = (j * mul)
          r_rng_e = r_rng_s + mul
          c_rng_s = (i * mul)
          c_rng_e = c_rng_s + mul
          pieces << pttr.minor(r_rng_s, mul, c_rng_s, mul)
        end
      end
      # puts "#{pieces.count} pieces found"
      pieces
    end
    
    def self.count
      sum = 0
      @pattern.to_a.each do |row|
        row.each do |cell|
          sum += 1 if cell == '#'
        end
      end
      sum
    end 
    
    def self.parse(rules)
      rules.each do |row|
        split = row.split(' => ')
        @rules[split.first.strip] = split.last.strip
      end
    end

    def self.pattern_as_row(patt)
      patt.to_a.map { |row| row.join }.join('/')
    end

    def self.grid_from_pattern(row)
      Matrix.rows(row.split('/').map { |e| e.split('') })
    end
  end
end
