require "spec_helper"

require_relative "../../day3/part_2.rb"

describe "Day 3" do
  let(:solver) { Day3::Part2 }

  describe "puzzle" do
    it "1st solution" do
      expect(solver.run(1)).to eq(1)
    end

    it "2nd solution" do
      expect(solver.run(2)).to eq(1)
    end

    it "3rd solution" do
      expect(solver.run(3)).to eq(2)
    end

    it "4th solution" do
      expect(solver.run(4)).to eq(4)
    end

    it "5th solution" do
      expect(solver.run(5)).to eq(5)
    end

    it "6th solution" do
      expect(solver.run(6)).to eq(10)
    end

    it "7th solution" do
      expect(solver.run(7)).to eq(11)
    end

    it "8th solution" do
      expect(solver.run(8)).to eq(23)
    end

    it "9th solution" do
      expect(solver.run(9)).to eq(25)
    end

    xit "nth solution" do
      expect(solver.run(277678)).to eq(25)
    end
  end
end
