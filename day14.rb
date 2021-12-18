#! /usr/bin/env ruby

require 'pry-nav'

lines = File.readlines(ARGV[0])
rules = {}
(2...lines.length).to_a.each do |i|
  adjacents, insertion = lines[i].chomp.match(/^([A-Z]{2}) -> ([A-Z])$/).captures
  rules[adjacents] = insertion
end

polymer = Hash.new(0)
template = lines[0].chomp
template.chars.each_cons(2) do |pair|
  polymer[pair.join] += 1
end
first = template[0]
last = template[-1]

40.times do |i|
  new_polymer = Hash.new(0)
  polymer.each do |pair, count|
    left, right = pair.chars
    insertion = rules.fetch(pair)

    new_polymer[[left, insertion].join] += count

    new_polymer[[insertion, right].join] += count
  end
  polymer = new_polymer

  if i == 9 || i == 39
    counts = Hash.new(0)
    polymer.each { |pair, count| counts[pair[0]] += count }
    counts[first] -= 1
    counts[last] += 1
    min, max = counts.values.minmax
    puts max - min
  end
end
