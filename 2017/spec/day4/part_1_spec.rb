require "spec_helper"

require_relative "../../day4/part_1.rb"

describe "Day 4" do
  let(:day_4) { Day4::Part1 }

  describe "puzzle" do
    it "1st solution" do
      expect(day_4.run("aa bb cc dd ee")).to eq(1)
    end

    it "2nd solution" do
      expect(day_4.run("aa bb cc dd aa")).to eq(0)
    end

    it "3rd solution" do
      expect(day_4.run("aa bb cc dd aaa")).to eq(1)
    end

    it "4th solution" do
      expect(day_4.run(["aa bb cc dd aaa", "dd"])).to eq(2)
    end

    it "D solution" do
      lines = File.readlines('spec/day4/passphrases')
      expect(day_4.run(lines)).to eq(337)
    end
  end
end
