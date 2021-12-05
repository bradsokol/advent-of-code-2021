#! /usr/bin/env ruby

def trace_lines(input, with_diagonals:)
  input.each_with_object(Hash.new(0)) do |line, points|
    x1, y1, x2, y2 = line.match(/(\d+),(\d+) -> (\d+),(\d+)/).captures.map(&:to_i)
    unless with_diagonals
      next unless x1 == x2 || y1 == y2
    end

    line = if x1 == x2
            start, finish = [y1, y2].sort
            (start..finish).map { |y| [x1, y] }
          elsif y1 == y2
            start, finish = [x1, x2].sort
            (start..finish).map { |x| [x, y1] }
          else
            slope, start_x, start_y = if x1 < x2
              [y1 < y2 ? 1 : -1, x1, y1]
            else
              [y2 < y1 ? 1 : -1, x2, y2]
            end
            length = (x1 - x2).abs
            (0..length).map { |i| [start_x + i, start_y + (i * slope)] }
          end

    line.each { |point| points[point] += 1 }
  end
end

input = File.readlines(ARGV[0])
puts trace_lines(input, with_diagonals: false).values.count { |e| e > 1 }
puts trace_lines(input, with_diagonals: true).values.count { |e| e > 1 }
