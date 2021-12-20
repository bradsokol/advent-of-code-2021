#! /usr/bin/env ruby

require 'minitest/autorun'

class TestWindowSum < MiniTest::Test
  def setup
    @input = <<~EOS
      199
      200
      208
      210
      200
      207
      240
      269
      260
      263
    EOS
  end

  def test_input_parsing
    depths = parse_input(@input.split)

    assert_equal(10, depths.size)
    assert_equal(Integer, depths.first.class)
    assert_equal(199, depths.first)
    assert_equal(263, depths.last)
  end

  def test_window_sum
    depths = parse_input(@input.split)
    sum = window_sum(depths, 1)

    assert_equal(7, sum)
  end
end

def parse_input(input)
  input.map(&:to_i)
end

def window_sum(data, size)
  last = data[0..size - 1].reduce(:+)
  (1..data.length - size).reduce(0) do |count, i|
    sum = data[i..(i + size - 1)].reduce(:+)
    next_count = sum > last ? count + 1 : count
    last = sum
    next_count
  end
end

depths = parse_input(File.readlines(ARGV[0]))

puts window_sum(depths, 1)
puts window_sum(depths, 3)
