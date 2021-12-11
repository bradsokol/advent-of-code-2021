#! /usr/bin/env ruby

def each_octopus(grid)
  grid.each_with_index do |row, y|
    row.each_with_index do |octopus, x|
      yield octopus, x, y
    end
  end
end

def each_adjacent(grid, x, y)
  width = grid.first.size
  height = grid.size

  ((x - 1)..(x + 1)).each do |xx|
    ((y - 1)..(y + 1)).each do |yy|
      next if xx == x && yy == y
      next if xx < 0 || xx >= width
      next if yy < 0 || yy >= height

      yield xx, yy
    end
  end
end

grid = File.readlines(ARGV[0]).map { |line| line.chomp.split('').map(&:to_i) }

flashes = 0
cycles = 0
loop do
  each_octopus(grid) { |_, x, y| grid[y][x] += 1 }

  loop do
    flashers = []
    each_octopus(grid) { |octopus, x, y| flashers << [x, y] if octopus == 10 }
    break if flashers.empty?

    flashes += flashers.size
    flashers.each do |x, y|
      grid[y][x] = 11
      each_adjacent(grid, x, y) { |xx, yy| grid[yy][xx] += 1 if grid[yy][xx] < 10 }
    end
  end

  each_octopus(grid) { |octopus, x, y| grid[y][x] = 0 if octopus == 11 }

  cycles += 1
  puts flashes if cycles == 100
  if grid.reduce(0) { |sum, row| sum + row.sum } == 0
    puts cycles
    break
  end
end
