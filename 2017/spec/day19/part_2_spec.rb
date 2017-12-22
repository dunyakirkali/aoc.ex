require "spec_helper"

require_relative "../../day19/part_2.rb"

describe "Day 19" do
  let(:solver) { Day19::Part2 }

  describe "puzzle" do
    it "1st solution" do
      lines = File.readlines('spec/day19/map')
      expect(solver.run(lines)).to eq(38)
    end

    it "D solution" do
      lines = File.readlines('spec/day19/map_2.txt')
      expect(solver.run(lines)).to eq(17872)
    end
  end
end
