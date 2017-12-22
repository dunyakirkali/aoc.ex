require "spec_helper"

require_relative "../../day20/part_2.rb"

describe "Day 20" do
  let(:solver) { Day20::Part2 }

  describe "puzzle" do
    it "1st solution" do
      lines = File.readlines('spec/day20/particles_3')
      expect(solver.run(lines)).to eq(1)
    end

    it "D solution" do
      lines = File.readlines('spec/day20/particles_2')
      expect(solver.run(lines)).to eq(648)
    end
  end
end
