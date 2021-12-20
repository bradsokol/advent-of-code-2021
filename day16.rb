#! /usr/bin/env ruby

require 'pry-nav'

class Packet
  attr_reader :type, :version, :subpackets
  attr_accessor :literal

  def initialize(version, type)
    @version = version
    @type = type
    @literal = nil
    @subpackets = []
  end

  def add_subpacket(subpacket)
    @subpackets << subpacket
  end
end

class PacketParser
  attr_reader :index, :packet

  LITERAL_TYPE = 4

  BIT_LENGTH = 0
  PACKET_LENGTH = 0

  def initialize(data, index = 0)
    @data = data
    @index = index
  end

  def parse_packet
    version = parse_int(3)
    type = parse_int(3)
    @packet = Packet.new(version, type)

    if type == LITERAL_TYPE
      packet.literal = parse_literal
    else
      parse_operator
    end

    packet
  end

  private

  attr_reader :data
  attr_writer :index, :packet

  def parse_int(length)
    parse_string(length).to_i(2)
  end

  def parse_literal
    literal = ''
    loop do
      prefix = parse_int(1)
      literal += parse_string(4)
      break if prefix == 0
    end
    literal.to_i(2)
  end

  def parse_operator
    length_type = parse_int(1)
    if length_type == BIT_LENGTH
      packets_length = parse_int(15)
      parse_packet_bits(packets_length)
    else
      subpackets_count = parse_int(11)
      parse_subpackets(subpackets_count)
    end
  end

  def parse_packet_bits(length)
    end_index = index + length

    loop do
      parser = PacketParser.new(data, index)
      @packet.add_subpacket(parser.parse_packet)
      @index = parser.index

      break if index == end_index
    end
  end

  def parse_subpackets(count)
    count.times do
      parser = PacketParser.new(data, index)
      packet.add_subpacket(parser.parse_packet)
      @index = parser.index
    end
  end

  def parse_string(length)
    result = data[index...(index + length)]
    @index += length
    result
  end
end

line = File.readlines(ARGV[0]).first.chomp
data = line.chars.map do |c|
  b = c.to_i(16).to_s(2)
  '0000'[...(4 - b.length)] + b
end.join

def sum_versions(packet)
  packet.subpackets.reduce(packet.version) { |sum, subpacket| sum + sum_versions(subpacket) }
end

first_packet = PacketParser.new(data).parse_packet
puts sum_versions(first_packet)
