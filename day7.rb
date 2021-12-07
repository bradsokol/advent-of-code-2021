#! /usr/bin/env ruby

crabs = File.readlines(ARGV[0]).first.chomp.split(',').map(&:to_i)

fuel_usage = crabs.map do |target_position|
  crabs.reduce(0) { |sum, crab_position| sum + (crab_position - target_position).abs }
end

puts fuel_usage.min

fuel_usage = crabs.map do |target_position|
  crabs.reduce(0) do |sum, crab_position|
    distance = (crab_position - target_position).abs
    sum + (distance * (1 + distance) / 2)
  end
end

puts fuel_usage.min
