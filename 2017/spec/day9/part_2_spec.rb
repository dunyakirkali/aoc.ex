require "spec_helper"

require_relative "../../day9/part_2.rb"

describe "Day 9" do
  let(:solver) { Day9::Part2 }

  describe "puzzle" do
    it "1st solution" do
      expect(solver.run("<>")).to eq(0)
    end

    it "2nd solution" do
      expect(solver.run("<random characters>")).to eq(17)
    end

    it "3rd solution" do
      expect(solver.run("<<<<>")).to eq(3)
    end

    it "4th solution" do
      expect(solver.run("<{!>}>")).to eq(2)
    end

    it "5th solution" do
      expect(solver.run("<!!>")).to eq(0)
    end

    it "6th solution" do
      expect(solver.run("<!!!>>")).to eq(0)
    end

    it "7th solution" do
      expect(solver.run('<{o"i!a,<{i<a>')).to eq(10)
    end

    it "D solution" do
      lines = File.readlines('spec/day9/parse')[0]
      expect(solver.run(lines)).not_to eq(7274)
      expect(solver.run(lines)).to eq(4482)
    end
  end
end
