require "spec_helper"

require_relative "../../day17/part_1.rb"

describe "Day 17" do
  let(:solver) { Day17::Part1 }

  describe "puzzle" do
    it "1st solution" do
      expect(solver.run(3)).to eq(638)
    end

    it "D solution" do
      expect(solver.run(369)).to eq(1547)
    end
  end
end
