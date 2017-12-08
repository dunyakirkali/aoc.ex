require "spec_helper"

require_relative "../../day8/part_1.rb"

describe "Day 8" do
  let(:solver) { Day8::Part1 }

  describe "puzzle" do
    it "1st solution" do
      lines = File.readlines('spec/day8/registers_1')
      expect(solver.run(lines)).to eq(1)
    end

    it "D solution" do
      lines = File.readlines('spec/day8/registers_2')
      expect(solver.run(lines)).to eq(3880)
    end
  end
end
