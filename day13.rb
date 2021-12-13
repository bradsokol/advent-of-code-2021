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

position = folds.first[1]
deletions = []
paper.each do |(x, y)|
  next if x < position

  new_x = position - (x - position)
  unless paper.find_index([new_x, y])
    paper << [new_x, y]
  end
  deletions << [x, y]
end
deletions.each { |d| paper.delete(d) }

puts paper.size
