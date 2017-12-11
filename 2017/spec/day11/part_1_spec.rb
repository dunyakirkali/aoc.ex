require "spec_helper"

require_relative "../../day11/part_1.rb"

describe "Day 11" do
  let(:solver) { Day11::Part1 }

  describe "puzzle" do
    it "1st solution" do
      expect(solver.run("ne,ne,ne")).to eq(3)
    end

    it "2nd solution" do
      expect(solver.run("ne,ne,sw,sw")).to eq(0)
    end

    it "3rd solution" do
      expect(solver.run("ne,ne,s,s")).to eq(2)
    end

    it "4th solution" do
      expect(solver.run("se,sw,se,sw,sw")).to eq(3)
    end

    it "D solution" do
      lines = File.readlines('spec/day11/steps')[0]
      expect(solver.run(lines)).to eq(774)
    end
  end
end
