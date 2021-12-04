#! /usr/bin/env ruby

def filter(values)
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
while values.count { |e| !e.nil? } > 1 do
  values = filter(values)
end
