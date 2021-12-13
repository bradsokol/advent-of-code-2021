#! /usr/bin/env ruby

folds = []
paper = []
File.readlines(ARGV[0]).each do |line|
  m = line.chomp.match(/^([\d]+),([\d]+)$/)
  if m.nil?
    m = line.chomp.match(/^fold along (.)=([\d]+)$/)
    unless m.nil?
      direction, position = m.captures
      folds << [direction, position.to_i]
    end
  else
    x, y = m.captures.map(&:to_i)
    paper << [x, y]
  end
end

folds.each_with_index do |(direction, position), i|
  deletions = paper.each_with_object([]) do |(x, y), deletions|
    if direction == 'x'
      next if x < position

      new_x = position - (x - position)
      unless paper.find_index([new_x, y])
        paper << [new_x, y]
      end
    else
      next if y < position

      new_y = position - (y - position)
      unless paper.find_index([x, new_y])
        paper << [x, new_y]
      end
    end
    deletions << [x, y]
  end
  deletions.each { |d| paper.delete(d) }

  puts paper.size if i == 0
end

min_x, max_x = paper.map { |p| p[0] }.minmax
min_y, max_y = paper.map { |p| p[1] }.minmax

(min_y..max_y).each do |y|
  (min_x..max_x).each do |x|
    print (paper.find_index([x, y]) ? '#' : ' ')
  end
  print "\n"
end
