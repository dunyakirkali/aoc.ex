require "spec_helper"

require_relative "../../day10/part_2.rb"

describe "Day 10" do
  let(:solver) { Day10::Part2 }

  describe "puzzle" do
    it "1st solution" do
      expect(solver.run(256, "")).to eq("a2582a3a0e66e6e86e3812dcb672a272")
    end

    it "2nd solution" do
      expect(solver.run(256, "AoC 2017")).to eq("33efeb34ea91902bb2f59c9920caa6cd")
    end

    it "3rd solution" do
      expect(solver.run(256, "1,2,3")).to eq("3efbe78a8d82f29979031a4aa0b16a9d")
    end

    it "4th solution" do
      expect(solver.run(256, "1,2,4")).to eq("63960835bcdc130f0b66d7ff4f6a5a8e")
    end

    it "D solution" do
      expect(solver.run(256, "189,1,111,246,254,2,0,120,215,93,255,50,84,15,94,62")).to eq("9de8846431eef262be78f590e39a4848")
    end
  end
end
