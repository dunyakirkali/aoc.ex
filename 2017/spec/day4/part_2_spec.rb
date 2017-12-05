require "spec_helper"

require_relative "../../day4/part_2.rb"

describe "Day 4" do
  let(:day_4) { Day4::Part2 }

  describe "puzzle" do
    it "1st solution" do
      expect(day_4.run("abcde fghij")).to eq(1)
    end

    it "2nd solution" do
      expect(day_4.run("abcde xyz ecdab")).to eq(0)
    end

    it "3rd solution" do
      expect(day_4.run("a ab abc abd abf abj")).to eq(1)
    end

    it "4th solution" do
      expect(day_4.run("oooi oooo")).to eq(1)
    end

    it "5th solution" do
      expect(day_4.run("oiii ioii iioi iiio")).to eq(0)
    end

    it "D solution" do
      lines = File.readlines('spec/day4/passphrases')
      expect(day_4.run(lines)).to eq(231)
    end
  end
end
