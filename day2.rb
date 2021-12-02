#! /usr/bin/env ruby

location = File.readlines(ARGV[0]).each_with_object({x: 0, z: 0}) do |line, location|
  direction, distance = line.chomp.split(' ')
  distance = distance.to_i
  case direction
  when 'forward'
    location[:x] += distance
  when 'down'
    location[:z] += distance
  when 'up'
    location[:z] -= distance
  else
    puts "Bad direction: #{direction}"
    exit(1)
  end
end

puts location.values.reduce(:*)

location = File.readlines(ARGV[0]).each_with_object({x: 0, z: 0, aim: 0}) do |line, location|
  direction, distance = line.chomp.split(' ')
  distance = distance.to_i
  case direction
  when 'forward'
    location[:z] += (distance * location[:aim])
    location[:x] += distance
  when 'down'
    location[:aim] += distance
  when 'up'
    location[:aim] -= distance
  else
    puts "Bad direction: #{direction}"
    exit(1)
  end
  location
end

puts location[:x] * location[:z]
