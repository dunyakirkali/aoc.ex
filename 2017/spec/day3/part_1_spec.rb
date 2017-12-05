require "spec_helper"

require_relative "../../day3/part_1.rb"

describe "Day 3" do
  let(:day_3) { Day3::Part1 }

  describe "puzzle" do
    it "1st solution" do
      expect(day_3.run(1)).to eq(0)
    end

    it "2nd solution" do
      expect(day_3.run(12)).to eq(3)
    end

    it "3rd solution" do
      expect(day_3.run(23)).to eq(2)
    end

    it "4th solution" do
      expect(day_3.run(1024)).to eq(31)
    end

    it "D solution" do
      expect(day_3.run(277678)).to eq(475)
    end
  end
end
