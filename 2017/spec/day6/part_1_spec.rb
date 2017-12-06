require "spec_helper"

require_relative "../../day6/part_1.rb"

describe "Day 6" do
  let(:solver) { Day6::Part1 }

  describe "puzzle" do
    it "1st solution" do
      expect(solver.run([0, 2, 7, 0])).to eq(5)
    end

    it "D solution" do
      lines = File.readlines('spec/day6/sequences').map(&:to_i)
      expect(solver.run(lines)).to eq(7864)
    end
  end
end
