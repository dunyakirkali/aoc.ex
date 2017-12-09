require "spec_helper"

require_relative "../../day7/part_2.rb"

describe "Day 7" do
  let(:solver) { Day7::Part2 }

  describe "puzzle" do
    xit "1st solution" do
      lines = File.readlines('spec/day7/tree_1')
      expect(solver.run(lines)).to eq(60)
    end

    xit "D solution" do
      lines = File.readlines('spec/day7/tree_2')
      expect(solver.run(lines)).to eq(-1)
    end
  end
end
