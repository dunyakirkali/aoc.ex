import aoc
import gleam/should

pub fn hello_world_test() {
  aoc.hello_world()
  |> should.equal(3550236)
}

pub fn fuel_test() {
  aoc.fuel(12)
  |> should.equal(2)
  aoc.fuel(14)
  |> should.equal(2)
  aoc.fuel(1969)
  |> should.equal(654)
  aoc.fuel(100756)
  |> should.equal(33583)
}
