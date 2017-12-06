require "spec_helper"

require_relative "../../day6/part_1.rb"

describe "Day 6" do
  let(:day_6) { Day6::Part1 }

  describe "puzzle" do
    it "1st solution" do
      expect(day_6.run([0, 2, 7, 0])).to eq(5)
    end

    it "D solution" do
      lines = File.readlines('spec/day6/sequences').map(&:to_i)
      expect(day_6.run(lines)).to eq(7864)
    end
  end
end
