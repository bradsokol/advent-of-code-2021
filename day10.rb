#! /usr/bin/env ruby

require 'pry'

closings = {
  '(' => ')',
  '<' => '>',
  '[' => ']',
  '{' => '}',
}

scores = {
  ')' => 3,
  '>' => 25137,
  ']' => 57,
  '}' => 1197,
}

completion_scores = {
  ')' => 1,
  '>' => 4,
  ']' => 2,
  '}' => 3,
}

completions = []
score = File.readlines(ARGV[0]).reduce(0) do |sum, line|
  stack = []
  score = 0
  line.chomp.chars.each do |c|
    if closings.keys.include?(c)
      stack.push(closings[c])
    else
      expected_closing = stack.pop
      unless expected_closing == c
        score = scores[c]
        break
      end
    end
  end
  completions << stack if score.zero?

  sum + score
end

puts score

scores = completions.map do |completion|
  sum = 0
  completion.reverse.each_with_index do |c, i|
    sum = sum * 5 + completion_scores[c]
  end
  sum
end

puts scores.sort[scores.length / 2]
