require "spec_helper"

require_relative "../../day5/part_2.rb"

describe "Day 5" do
  let(:solver) { Day5::Part2 }

  describe "puzzle" do
    it "1st solution" do
      expect(solver.run([0, 3, 0, 1, -3])).to eq(10)
    end

    it "D solution" do
      lines = File.readlines('spec/day5/jumps')
      expect(solver.run(lines)).to eq(30513679)
    end
  end
end
