import gleam/file
import gleam/bit_string
import gleam/result
import gleam/io
import gleam/string
import gleam/list
import gleam/int

pub fn hello_world() -> Int {
  "priv/day01/input.txt"
  |> file.read_to_bitstring()
  |> result.unwrap(<<>>)
  |> bit_string.to_string
  |> result.unwrap("")
  |> string.trim_right()
  |> string.split("\n")
  |> list.map(fn(line) {
    line
    |> int.parse()
    |> result.unwrap(0)
  })
  |> list.map(fn(mass) { fuel(mass) })
  |> list.fold(0, fn(acc, val) {
    acc + val
  })
}

pub fn fuel(mass: Int) -> Int {
  mass / 3 - 2
}
