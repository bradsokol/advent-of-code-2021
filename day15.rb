#! /usr/bin/env ruby

require 'pry-nav'

INFINITY = 1_000_000

def each_adjacent(grid, x, y)
  width = grid.first.size
  height = grid.size

  ((x - 1)..(x + 1)).each do |xx|
    ((y - 1)..(y + 1)).each do |yy|
      next if xx == x && yy == y
      next if xx < 0 || xx >= width
      next if yy < 0 || yy >= height
      next if x - xx != 0 && y - yy != 0

      yield xx, yy
    end
  end
end

def shortest_path(grid, source, target)
  q = []
  distance = {}
  previous = {}
  grid.each_with_index do |line, y|
    line.each_with_index do |location, x|
      distance[[x, y]] = INFINITY
      previous[[x, y]] = nil
      q << [[x, y], grid[y][x]]
    end
  end
  distance[source] = 0

  until q.empty?
    u = q.min_by { |node| distance[node[0]] }
    q.delete(u)

    ux, uy = u[0]
    each_adjacent(grid, ux, uy) do |vx, vy|
      v = [vx, vy]
      weight = grid[vy][vx]
      next unless q.index([v, weight])

      alt = distance[u[0]] + weight
      if alt < distance[v]
        distance[v] = alt
        previous[v] = u
        q << [v, weight]
      end
    end
  end

  s = []
  u = [target, 0]
  if previous.key?(u[0]) || u[0] == source
    while u
      s << u
      u = previous[u[0]]
    end
  end
  s
end

grid = File.readlines(ARGV[0]).map { |line| line.chomp.split('').map(&:to_i) }
goal = [grid.first.size - 1, grid.size - 1]

path = shortest_path(grid, goal, [0, 0])
puts path.map { |v| v[1] }.sum

def next_risk(risk, offset)
  new_risk = risk + offset
  new_risk = (new_risk % 10) + 1 if new_risk > 9
  new_risk
end

big_grid = grid.map do |line|
  big_line = []
  5.times do |i|
    line.each { |n| big_line << next_risk(n, i) }
  end
  big_line
end

big_grid2 = []
5.times do |i|
  big_grid.each do |line|
    big_grid2 << line.map { |n| next_risk(n, i) }
  end
end

# big_grid2.each { |line| puts line.map(&:to_s).join }
goal = [big_grid2.first.size - 1, big_grid2.size - 1]

path = shortest_path(big_grid2, goal, [0, 0])
puts path.map { |v| v[1] }.sum
