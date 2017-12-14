require "spec_helper"

require_relative "../../day12/part_1.rb"

describe "Day 12" do
  let(:solver) { Day12::Part1 }

  describe "puzzle" do
    it "1st solution" do
      lines = File.readlines('spec/day12/connections')
      expect(solver.run(lines)).to eq(6)
    end

    it "D solution" do
      lines = File.readlines('spec/day12/connections_2')
      expect(solver.run(lines)).to eq(169)
    end
  end
end
