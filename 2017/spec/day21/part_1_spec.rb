require "spec_helper"

require_relative "../../day21/part_1_and_2.rb"

describe "Day 21" do
  let(:solver) { Day21::Part1And2 }

  describe "puzzle" do
    it "subs 2" do
      pttr = Matrix[['.', '#'], ['#', '.']]
      expect(solver.subs(pttr).count).to eq(1)
      expect(solver.subs(pttr).first).to eq(pttr)
    end
    
    it "subs 3" do
      pttr = Matrix[['.', '#', '.'], ['#', '.', '#'], ['#', '#', '#']]
      expect(solver.subs(pttr).count).to eq(1)
      expect(solver.subs(pttr).first).to eq(pttr)
    end
    
    it "subs 4" do
      pttr = Matrix[['.', '#', '.', '#'], ['#', '.', '#', '.'], ['#', '#', '#', '.'], ['#', '#', '#', '.']]
      expect(solver.subs(pttr).count).to eq(4)
    end
    
    it "subs 6" do
      pttr = Matrix[['.', '#', '.', '#', '.', '#'], ['#', '.', '#', '.', '.', '#'], ['#', '#', '#', '.', '.', '#'], ['#', '#', '#', '.', '.', '#'], ['#', '#', '#', '.', '.', '#'], ['#', '#', '#', '.', '.', '#']]
      expect(solver.subs(pttr).count).to eq(9)
    end
    
    it "0th solution" do
      lines = File.readlines('spec/day21/pattern')
      expect(solver.run(lines, 1)).to eq(4)
    end
    
    it "1st solution" do
      lines = File.readlines('spec/day21/pattern')
      expect(solver.run(lines, 2)).to eq(12)
    end
    
    it "D solution step1" do
      lines = File.readlines('spec/day21/pattern_2')
      expect(solver.run(lines, 1)).to eq(9)
    end
    
    it "D solution step2" do
      lines = File.readlines('spec/day21/pattern_2')
      expect(solver.run(lines, 2)).to eq(16)
    end
    
    it "D solution step3" do
      lines = File.readlines('spec/day21/pattern_2')
      expect(solver.run(lines, 3)).to eq(38)
    end
    
    it "D solution step4" do
      lines = File.readlines('spec/day21/pattern_2')
      expect(solver.run(lines, 4)).to eq(71)
    end

    it "D solution step5" do
      lines = File.readlines('spec/day21/pattern_2')
      expect(solver.run(lines, 5)).to eq(164)
    end
    
    it "D solution" do
      lines = File.readlines('spec/day21/pattern_2')
      expect(solver.run(lines, 18)).to eq(2355110)
    end
  end
end
