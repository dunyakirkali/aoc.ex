defmodule Day4Test do
  use ExUnit.Case
  doctest Day4

  test "parse_date" do
    assert Day4.parse_date("[1518-11-01 00:00]") == {"11-1", 0}
    assert Day4.parse_date("[1518-11-01 23:58]") == {"11-2", 0}
    assert Day4.parse_date("[1518-11-03 00:24]") == {"11-3", 24}
    assert Day4.parse_date("[1518-11-05 00:59]") == {"11-5", 59}
  end

  test "guard_with_most_sleep" do
    hash = %{
      "11-1" => {10, [5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54]},
      "11-2" => {99, [40,41,42,43,44,45,46,47,48,49]},
      "11-3" => {10, [24,25,26,27,28]},
      "11-4" => {99, [36,37,38,39,40,41,42,43,44,45]},
      "11-5" => {99, [45,46,47,48,49,50,51,52,53,54]},
    }
    assert Day4.guard_with_most_sleep(hash) == 10
  end

  test "favorite_time" do
    guard = 10
    hash = %{
      "11-1" => {10, [5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54]},
      "11-2" => {99, [40,41,42,43,44,45,46,47,48,49]},
      "11-3" => {10, [24,25,26,27,28]},
      "11-4" => {99, [36,37,38,39,40,41,42,43,44,45]},
      "11-5" => {99, [45,46,47,48,49,50,51,52,53,54]},
    }
    assert Day4.favorite_time(hash, guard) == 24
  end

  test "strategy_1" do
    hash = %{
      "11-1" => {10, [5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54]},
      "11-2" => {99, [40,41,42,43,44,45,46,47,48,49]},
      "11-3" => {10, [24,25,26,27,28]},
      "11-4" => {99, [36,37,38,39,40,41,42,43,44,45]},
      "11-5" => {99, [45,46,47,48,49,50,51,52,53,54]},
    }
    assert Day4.strategy_1(hash) == 240
  end

  test "transcode" do
    input = """
    [1518-11-01 00:00] Guard #10 begins shift
    [1518-11-01 00:05] falls asleep
    [1518-11-01 00:25] wakes up
    [1518-11-01 00:30] falls asleep
    [1518-11-01 00:55] wakes up
    [1518-11-01 23:58] Guard #99 begins shift
    [1518-11-02 00:40] falls asleep
    [1518-11-02 00:50] wakes up
    [1518-11-03 00:05] Guard #10 begins shift
    [1518-11-03 00:24] falls asleep
    [1518-11-03 00:29] wakes up
    [1518-11-04 00:02] Guard #99 begins shift
    [1518-11-04 00:36] falls asleep
    [1518-11-04 00:46] wakes up
    [1518-11-05 00:03] Guard #99 begins shift
    [1518-11-05 00:45] falls asleep
    [1518-11-05 00:55] wakes up
    """
    hash = %{
      "11-1" => {10, [5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54]},
      "11-2" => {99, [40,41,42,43,44,45,46,47,48,49]},
      "11-3" => {10, [24,25,26,27,28]},
      "11-4" => {99, [36,37,38,39,40,41,42,43,44,45]},
      "11-5" => {99, [45,46,47,48,49,50,51,52,53,54]},
    }
    assert Day4.transcode(input) == hash
  end

  test "example_1" do
    input = """
    [1518-11-01 00:00] Guard #10 begins shift
    [1518-11-01 00:05] falls asleep
    [1518-11-01 00:25] wakes up
    [1518-11-01 00:30] falls asleep
    [1518-11-01 00:55] wakes up
    [1518-11-01 23:58] Guard #99 begins shift
    [1518-11-02 00:40] falls asleep
    [1518-11-02 00:50] wakes up
    [1518-11-03 00:05] Guard #10 begins shift
    [1518-11-03 00:24] falls asleep
    [1518-11-03 00:29] wakes up
    [1518-11-04 00:02] Guard #99 begins shift
    [1518-11-04 00:36] falls asleep
    [1518-11-04 00:46] wakes up
    [1518-11-05 00:03] Guard #99 begins shift
    [1518-11-05 00:45] falls asleep
    [1518-11-05 00:55] wakes up
    """

    assert Day4.part_1(input) == 240
  end

  test "example_2" do
    input = """
    [1518-11-01 00:00] Guard #10 begins shift
    [1518-11-01 00:05] falls asleep
    [1518-11-01 00:25] wakes up
    [1518-11-01 00:30] falls asleep
    [1518-11-01 00:55] wakes up
    [1518-11-01 23:58] Guard #99 begins shift
    [1518-11-02 00:40] falls asleep
    [1518-11-02 00:50] wakes up
    [1518-11-03 00:05] Guard #10 begins shift
    [1518-11-03 00:24] falls asleep
    [1518-11-03 00:29] wakes up
    [1518-11-04 00:02] Guard #99 begins shift
    [1518-11-04 00:36] falls asleep
    [1518-11-04 00:46] wakes up
    [1518-11-05 00:03] Guard #99 begins shift
    [1518-11-05 00:45] falls asleep
    [1518-11-05 00:55] wakes up
    """

    assert Day4.part_2(input) == 4455
  end

  test "part_1" do
    input = 'input.txt'
    |> File.read!
    #2039
    #49
    assert Day4.part_1(input) == 99_911
  end

  test "part_2" do
    input = 'input.txt'
    |> File.read!

    assert Day4.part_2(input) != 148722
  end
end
