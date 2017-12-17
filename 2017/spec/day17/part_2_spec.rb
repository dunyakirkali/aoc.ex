require "spec_helper"

require_relative "../../day17/part_2.rb"

describe "Day 17" do
  let(:solver) { Day17::Part2 }

  describe "puzzle" do
    it "D solution" do
      expect(solver.run(369)).to eq(31154878)
    end
  end
end
