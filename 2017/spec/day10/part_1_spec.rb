require "spec_helper"

require_relative "../../day10/part_1.rb"

describe "Day 10" do
  let(:solver) { Day10::Part1 }

  describe "puzzle" do
    it "1st solution" do
      expect(solver.run(5, [3, 4, 1, 5])).to eq(12)
    end

    it "D solution" do
      expect(solver.run(256, [189,1,111,246,254,2,0,120,215,93,255,50,84,15,94,62])).to eq(38415)
    end
  end
end
