#! /usr/bin/env ruby

require 'set'

def adjacent_cells(map, x, y)
  cells = []

  width = map.first.length
  height = map.length

  (-1..1).each do |dy|
    (-1..1).each do |dx|
      next unless dx.abs + dy.abs == 1
      xx = x + dx
      yy = y + dy
      if (xx >= 0 && xx < width && yy >= 0 && yy < height)
        cells << [xx, yy]
      end
    end
  end

  cells
end

def find_basin(map, x, y)
  q = [[x, y]]
  cells = Set.new

  until q.empty?
    x, y = q.shift
    next if cells.include?([x, y])

    if map[y][x] < 9
      cells << [x, y]
      q += adjacent_cells(map, x, y)
    end
  end

  cells.size
end

map = File.readlines(ARGV[0]).map { |line| line.chomp.chars.map(&:to_i) }

low_points = []
map.each_with_index do |row, y|
  row.each_with_index do |depth, x|
    if depth < adjacent_cells(map, x, y).map { |x, y| map[y][x] }.min
      low_points << [x, y]
    end
  end
end

puts low_points.reduce(0) { |sum, p| sum + map[p[1]][p[0]] + 1 }

sizes = []
low_points.each do |x, y|
  sizes << find_basin(map, x, y)
end

puts sizes.max(3).reduce(:*)
