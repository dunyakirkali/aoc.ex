require "spec_helper"

require_relative "../../day16/part_1.rb"

describe "Day 16" do
  let(:solver) { Day16::Part1 }

  describe "puzzle" do
    it "1st solution" do
      lines = File.readlines('spec/day16/dance')[0].split(",")
      expect(solver.run("abcde", lines)).to eq("baedc")
    end

    it "D solution" do
      lines = File.readlines('spec/day16/dance_2')[0].split(",")
      expect(solver.run("abcdefghijklmnop", lines)).to eq("nlciboghjmfdapek")
    end
  end
end
