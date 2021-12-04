#! /usr/bin/env ruby

def mark_board(board, call)
  (0..4).each do |row|
    (0..4).each { |column| board[row][column] = '*' if board[row][column] == call }
  end
end

def board_wins?(board)
  board.each { |row| return true if row.join == '*' * 5 }

  rotated = board.transpose
  rotated.each { |row| return true if row.join == '*' * 5 }
  false
end

boards = []
calls = []
File.open(ARGV[0]) do |file|
  calls = file.readline.chomp.split(',')

  loop do
    begin
      file.readline
    rescue EOFError
      break
    end

    board = []
    5.times do
      board << file.readline.chomp.split(' ')
    end
    boards << board
  end
end

first = false
calls.each do |call|
  boards.each { |board| mark_board(board, call) }
  winning_boards = boards.select { |board| board_wins?(board) }
  if winning_boards.count == 1 && !first
    puts winning_boards
      .first
      .join(',')
      .split(',')
      .select { |e| e != '*' }
      .map(&:to_i)
      .reduce(:+) * call.to_i
    first = true
  elsif winning_boards.count == 100
    last = winning_boards - $winners
    puts last
      .first
      .join(',')
      .split(',')
      .select { |e| e != '*' }
      .map(&:to_i)
      .reduce(:+) * call.to_i
    break
  end

  $winners = winning_boards
end
