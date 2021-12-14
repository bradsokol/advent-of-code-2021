#! /usr/bin/env ruby

lines = File.readlines(ARGV[0])
polymer = lines[0].chomp.chars
rules = {}
(2...lines.length).to_a.each do |i|
  adjacents, insertion = lines[i].chomp.match(/^([A-Z]{2}) -> ([A-Z])$/).captures
  rules[adjacents] = insertion
end

10.times do
  new_polymer = []
  polymer.each_cons(2) do |pair|
    insertion = rules[pair.join]
    new_polymer << pair[0]
    new_polymer << insertion
  end
  new_polymer << polymer[-1]
  polymer = new_polymer
end

min, max = polymer.tally.values.minmax
puts max - min
