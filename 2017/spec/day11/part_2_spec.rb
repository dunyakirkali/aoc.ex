require "spec_helper"

require_relative "../../day11/part_2.rb"

describe "Day 11" do
  let(:solver) { Day11::Part2 }

  describe "puzzle" do
    it "D solution" do
      lines = File.readlines('spec/day11/steps')[0]
      expect(solver.run(lines)).to eq(1560)
    end
  end
end
