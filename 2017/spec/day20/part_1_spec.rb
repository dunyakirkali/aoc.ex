require "spec_helper"

require_relative "../../day20/part_1.rb"

describe "Day 20" do
  let(:solver) { Day20::Part1 }

  describe "puzzle" do
    it "1st solution" do
      lines = File.readlines('spec/day20/particles')
      expect(solver.run(lines)).to eq(0)
    end

    it "D solution" do
      lines = File.readlines('spec/day20/particles_2')
      expect(solver.run(lines)).to eq(243)
    end
  end
end
