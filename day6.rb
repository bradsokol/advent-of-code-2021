#! /usr/bin/env ruby

def cycle(counts)
  counts.each_with_object(Hash.new(0)) do |(day_count, n), new_counts|
    if day_count.zero?
      new_counts[6] += n
      new_counts[8] = n
    else
      new_counts[day_count - 1] += n
    end
  end
end

counts = File.readlines(ARGV[0])
  .first
  .split(',')
  .map(&:to_i)
  .tally

80.times { counts = cycle(counts) }

puts counts.values.sum

counts = File.readlines(ARGV[0])
  .first
  .split(',')
  .map(&:to_i)
  .tally

256.times { counts = cycle(counts) }

puts counts.values.sum
