#! /usr/bin/env ruby

class Packet
  attr_reader type, version, packets
  attr_accessor literal

  def initialize(version, type)
    @version = version
    @type = type
    @literal = nil
  end
end

line = File.readlines(ARGV[0]).first.chomp
data = line.chars.map do |c|
  b = c.to_i(16).to_s(2)
  '0000'[...(4 - b.length)] + b
end.join

def parse_packet(data, i)
  version = data[i...(i + 3)].to_i(2)
  i += 3
  type = data[i...(i + 3)].to_i(2)
  i += 3
  packet = Packet.new(version, type)

  if type == 4
    groups = 0
    literal = ''
    loop do
      prefix = data[i]
      i += 1
      literal += data[i...(i + 4)]
      i += 4
      groups += 1
      break if prefix == '0'
    end
    packet.literal = literal.to_i(2)
    i += 4 - (groups * 5 + 6) % 4
  else
    length_type = data[i]
    i += 1
    if length_type == '0'
    else
    end
  end

  packet
end

packets = []
i = 0

first_packet = parse_packet(data, i)
