require "spec_helper"

require_relative "../../day6/part_2.rb"

describe "Day 6" do
  let(:solver) { Day6::Part2 }

  describe "puzzle" do
    it "1st solution" do
      expect(solver.run([0, 2, 7, 0])).to eq(4)
    end

    it "D solution" do
      lines = File.readlines('spec/day6/sequences').map(&:to_i)
      expect(solver.run(lines)).to eq(1695)
    end
  end
end
