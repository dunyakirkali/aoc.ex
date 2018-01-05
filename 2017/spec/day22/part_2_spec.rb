require "spec_helper"

require_relative "../../day22/part_2.rb"

describe "Day 22" do
  let(:solver) { Day22::Part2 }

  describe "puzzle" do
    it "Example" do
      lines = File.readlines('spec/day22/pattern')
      expect(solver.run(lines, 0)).to eq(0)
    end
    
    it "Example" do
      lines = File.readlines('spec/day22/pattern')
      expect(solver.run(lines, 1)).to eq(0)
    end
    
    it "Example" do
      lines = File.readlines('spec/day22/pattern')
      expect(solver.run(lines, 100)).to eq(26)
    end
    
    it "Example" do
      lines = File.readlines('spec/day22/pattern')
      expect(solver.run(lines, 10_000_000)).to eq(2511944)
    end

    it "D solution" do
      lines = File.readlines('spec/day22/pattern_2')
      expect(solver.run(lines, 10_000_000)).to eq(2512225)
    end
  end
end
