require "spec_helper"

require_relative "../../day9/part_1.rb"

describe "Day 9" do
  let(:solver) { Day9::Part1 }

  describe "puzzle" do
    it "1st solution" do
      expect(solver.run("{}")).to eq(1)
    end

    it "2nd solution" do
      expect(solver.run("{{{}}}")).to eq(6)
    end

    it "3rd solution" do
      expect(solver.run("{{},{}}")).to eq(5)
    end

    it "4th solution" do
      expect(solver.run("{{{},{},{{}}}}")).to eq(16)
    end

    it "5th solution" do
      expect(solver.run("{<a>,<a>,<a>,<a>}")).to eq(1)
    end

    it "6th solution" do
      expect(solver.run("{{<ab>},{<ab>},{<ab>},{<ab>}}")).to eq(9)
    end

    it "7th solution" do
      expect(solver.run("{{<!!>},{<!!>},{<!!>},{<!!>}}")).to eq(9)
    end

    it "8th solution" do
      expect(solver.run("{{<a!>},{<a!>},{<a!>},{<ab>}}")).to eq(3)
    end

    it "D solution" do
      lines = File.readlines('spec/day9/parse')[0]
      expect(solver.run(lines)).to eq(10050)
    end
  end
end
