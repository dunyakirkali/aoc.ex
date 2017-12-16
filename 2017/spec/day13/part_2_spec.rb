require "spec_helper"

require_relative "../../day13/part_2.rb"

describe "Day 13" do
  let(:solver) { Day13::Part2 }

  describe "puzzle" do
    it "1st solution" do
      lines = File.readlines('spec/day13/conf')
      expect(solver.run(lines)).to eq(10)
    end

    it "D solution" do
      lines = File.readlines('spec/day13/conf_2')
      expect(solver.run(lines)).to eq(3943252)
    end
  end
end
