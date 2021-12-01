#! /usr/bin/env ruby

def window_sum(data, size)
  last = data[0..size - 1].reduce(:+)
  (1..data.length - size).reduce(0) do |count, i|
    sum = data[i..(i + size - 1)].reduce(:+)
    next_count = sum > last ? count + 1 : count
    last = sum
    next_count
  end
end

depths = File.readlines(ARGV[0]).map(&:to_i)

puts window_sum(depths, 1)
puts window_sum(depths, 3)
