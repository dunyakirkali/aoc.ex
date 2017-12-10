require "spec_helper"

require_relative "../../day10/part_2.rb"

describe "Day 10" do
  let(:solver) { Day10::Part2 }

  describe "puzzle" do
    it "1st solution" do
      expect(solver.run("<>")).to eq(0)
    end

    it "D solution" do
      lines = File.readlines('spec/day9/parse')[0]
      expect(solver.run(lines)).not_to eq(7274)
      expect(solver.run(lines)).to eq(4482)
    end
  end
end
