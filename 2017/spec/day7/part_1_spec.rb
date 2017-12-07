require "spec_helper"

require_relative "../../day7/part_1.rb"

describe "Day 7" do
  let(:solver) { Day7::Part1 }

  describe "puzzle" do
    it "1st solution" do
      lines = File.readlines('spec/day7/tree_1')
      expect(solver.run(lines)).to eq('tknk')
    end

    it "D solution" do
      lines = File.readlines('spec/day7/tree_2')
      expect(solver.run(lines)).to eq('wiapj')
    end
  end
end
