#! /usr/bin/env ruby

require 'pry-nav'

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

polymer = Hash.new(0)
lines[0].chomp.chars.each_cons(2) do |pair|
  polymer[pair.join] += 1
end

polymer = Hash.new(0)
'NCBH'.chars.each_cons(2) do |pair|
  polymer[pair.join] += 1
end

40.times do |i|
  new_polymer = Hash.new(0)
  polymer.each do |pair, count|
    left, right = pair.chars
    insertion = rules[pair]

    new_polymer[[left, insertion].join] += count

    new_polymer[[insertion, right].join] += count

    # if new_polymer.key?(pair)
    #   new_polymer[pair] -= count
    # end
  end
  polymer = new_polymer
  binding.pry

  if i == 9
    min, max = polymer.values.minmax
    puts max - min
  end
end

min, max = polymer.values.minmax
puts max - min
