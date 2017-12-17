require "spec_helper"

require_relative "../../day16/part_2.rb"

describe "Day 16" do
  let(:solver) { Day16::Part2 }

  describe "puzzle" do
    it "D solution" do
      lines = File.readlines('spec/day16/dance_2')[0].split(",")
      expect(solver.run("abcdefghijklmnop", lines)).to eq("nlciboghmkedpfja")
    end
  end
end
