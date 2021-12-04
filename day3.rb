#! /usr/bin/env ruby

def filter(values, position, rating)
  threshold = (values.count + 1) / 2
  columns = values.transpose
  ones = columns[position].count { |e| e == '1' }
  keep = if rating == :oxygen_generator
           ones >= threshold ? '1' : '0'
         else
           ones < threshold ? '1': '0'
         end
  keepers, _ = values.partition { |number| number[position] == keep }
  keepers
end

def pretty(values)
  puts values.map { |v| v.join }.join(' ')
end

$numbers = File.readlines(ARGV[0]).map { |line| line.chomp.chars }
$columns = $numbers.transpose
$threshold = $columns[0].count / 2

counts = $columns.map do |column|
  column.count { |e| e == '1' }
end

gamma = counts.map { |c| c > $threshold ? '1' : '0' }
epsilon = gamma.map { |e| e == '0' ? '1' : '0' }

puts gamma.join.to_i(2) * epsilon.join.to_i(2)

values = $numbers.clone.map(&:clone)
position = 0
while values.count > 1 do
  values = filter(values, position, :oxygen_generator)
  position += 1
end
oxygen_generator = values.first.join.to_i(2)

values = $numbers.clone.map(&:clone)
position = 0
while values.count > 1 do
  values = filter(values, position, :co2_scrubber)
  position += 1
end
co2_scrubber = values.first.join.to_i(2)

puts oxygen_generator * co2_scrubber
