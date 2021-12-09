#! /usr/bin/env ruby

require 'pry'
require 'pry-nav'

unique_digit_segment_counts = [2, 3, 4, 7]

seven_segments = {
  'abcefg': 0,
  'cf': 1,
  'acdeg': 2,
  'acdfg': 3,
  'bcdf': 4,
  'abdfg': 5,
  'abdefg': 6,
  'acf': 7,
  'abcdefg': 8,
  'abcdfg': 9,
}

counts = File.readlines(ARGV[0]).map do |line|
  _signals, outputs = line.split('|').map(&:split)

  outputs.count { |digit| unique_digit_segment_counts.include?(digit.length) }
end

puts counts.reduce(:+)

outputs = File.readlines(ARGV[0]).map do |line|
  signals, scrambled_outputs = line.split('|').map(&:split)

  mappings = {}

  i = signals.find_index { |signal| signal.length == 2 }
  one = signals.delete_at(i)
  i = signals.find_index { |signal| signal.length == 3 }
  seven = signals.delete_at(i)
  i = signals.find_index { |signal| signal.length == 4 }
  four = signals.delete_at(i)

  a = seven.chars.reject { |c| four.include?(c) }.first 
  raise a if mappings.key?(a)
  mappings[a] = 'a'

  x = four + a
  i = signals.find_index { |signal| (signal.length - x.length) == 1 && (signal.chars - x.chars).length == 1 }
  nine = signals.delete_at(i)
  g = (nine.chars - x.chars).first
  raise g if mappings.key?(g)
  mappings[g] = 'g'

  x = one + a + g
  i = signals.find_index { |signal| (signal.length - x.length) == 1 && (signal.chars - x.chars).length == 1 }
  three = signals.delete_at(i)
  d = (three.chars - x.chars).first
  raise d if mappings.key?(d)
  mappings[d] = 'd'

  b = (nine.chars - three.chars).first
  raise b if mappings.key?(b)
  mappings[b] = 'b'

  x = a + g + b + d
  i = signals.find_index { |signal| (signal.length - x.length) == 1 && (signal.chars - x.chars).length == 1 }
  five = signals.delete_at(i)
  f = (five.chars - x.chars).first
  raise f if mappings.key?(f)
  mappings[f] = 'f'

  i = signals.find_index { |signal| (signal.length - five.length) == 1 && (signal.chars - five.chars).length == 1 }
  six = signals.delete_at(i)
  e = (six.chars - five.chars).first
  raise e if mappings.key?(e)
  mappings[e] = 'e'

  c = (nine.chars - five.chars).first
  raise c if mappings.key?(c)
  mappings[c] = 'c'

  digits = scrambled_outputs.map do |s|
    s = s.chars.map { |ss| mappings[ss] }.sort.join.to_sym
    seven_segments[s]
  end

  digits[0] * 1000 + digits[1] * 100 + digits[2] * 10 + digits[3]
end

puts outputs.reduce(:+)
