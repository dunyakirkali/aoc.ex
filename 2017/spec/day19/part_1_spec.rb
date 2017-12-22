require "spec_helper"

require_relative "../../day19/part_1.rb"

describe "Day 19" do
  let(:solver) { Day19::Part1 }

  describe "puzzle" do
    it "1st solution" do
      lines = File.readlines('spec/day19/map')
      expect(solver.run(lines)).to eq("ABCDEF")
    end

    it "D solution" do
      lines = File.readlines('spec/day19/map_2.txt')
      expect(solver.run(lines)).to eq("MKXOIHZNBL")
    end
  end
end
