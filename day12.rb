#! /usr/bin/env ruby

class Cave
  attr_reader :name, :connections

  def initialize(name)
    @name = name
    @connections = []
  end

  def add_connection(cave)
    return if @connections.any? { |c| c.name == cave.name }
    @connections << cave
  end

  def end?
    @name == 'end'
  end

  def start?
    @name == 'start'
  end

  def small?
    @name[0].upcase != @name[0]
  end

  def to_s
    name
  end

  def ==(other)
    name == other.name
  end
end

def find_or_create(caves, name)
  cave = caves[name]
  if cave.nil?
    cave = Cave.new(name)
    caves[name] = cave
  end
  cave
end

def visit(visited, cave, part2)
  if cave.end?
    $count += 1
    return
  end

  next_visited = visited.clone
  next_visited << cave if cave.small?
  cave.connections.each do |connection|
    if part2
      next if connection.start? || (next_visited.include?(connection) && next_visited.tally.values.max == 2)
    else
      next if next_visited.include?(connection)
    end

    visit(next_visited, connection, part2)
  end
end

caves = {}
start = nil
File.readlines(ARGV[0]).each do |line|
  name1, name2 = line.match(/(^[a-zA-Z]+)-([a-zA-Z]+$)/).captures

  cave1 = find_or_create(caves, name1)
  cave2 = find_or_create(caves, name2)

  cave1.add_connection(cave2)
  cave2.add_connection(cave1)

  if cave1.start?
    start = cave1
  elsif cave2.start?
    start = cave2
  end
end

$count = 0
visit([], start, false)

puts $count

$count = 0
visit([], start, true)

puts $count
