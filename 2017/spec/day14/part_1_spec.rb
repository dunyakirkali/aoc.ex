require "spec_helper"

require_relative "../../day14/part_1.rb"

describe "Day 14" do
  let(:solver) { Day14::Part1 }

  describe "puzzle" do
    it "1st solution" do
      expect(solver.run("flqrgnkx")).to eq(8108)
    end

    it "D solution" do
      expect(solver.run("amgozmfv")).to eq(-1)
    end
  end
end
