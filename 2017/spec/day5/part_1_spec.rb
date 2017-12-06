require "spec_helper"

require_relative "../../day5/part_1.rb"

describe "Day 5" do
  let(:solver) { Day5::Part1 }

  describe "puzzle" do
    it "1st solution" do
      expect(solver.run([0, 3, 0, 1, -3])).to eq(5)
    end

    it "D solution" do
      lines = File.readlines('spec/day5/jumps')
      expect(solver.run(lines)).to eq(391540)
    end
  end
end
