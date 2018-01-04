require "spec_helper"

require_relative "../../day22/part_1.rb"

describe "Day 22" do
  let(:solver) { Day22::Part1 }

  describe "puzzle" do
    it "Example" do
      lines = File.readlines('spec/day22/pattern')
      expect(solver.run(lines, 0)).to eq(0)
    end
    
    it "Example" do
      lines = File.readlines('spec/day22/pattern')
      expect(solver.run(lines, 1)).to eq(1)
    end
    
    it "Example" do
      lines = File.readlines('spec/day22/pattern')
      expect(solver.run(lines, 7)).to eq(5)
    end
    
    it "Example" do
      lines = File.readlines('spec/day22/pattern')
      expect(solver.run(lines, 70)).to eq(41)
    end
    
    it "Example" do
      lines = File.readlines('spec/day22/pattern')
      expect(solver.run(lines, 10_000)).to eq(5587)
    end

    it "D solution" do
      lines = File.readlines('spec/day22/pattern_2')
      expect(solver.run(lines, 10_000)).to eq(5348)
    end
  end
end
