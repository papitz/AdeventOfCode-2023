# frozen_string_literal: true

DIGIT_EXPRESSION = /\d+/
SYMBOL_EXPRESSION = /[^\w.]/
LINE_LENGTH = 158
NUM_LINES = 139
# LINE_LENGTH = 9
# NUM_LINES = 9

def number_in_array_between(ary, left_bound, right_bound)
  ary.each do |num|
    return true if num.between?(left_bound, right_bound)
  end
  false
end

def adjacent_symbol(number_index_size, symbols, line_number)
  left_bound = [number_index_size[0] - 1, 0].max
  right_bound = [number_index_size[0] + number_index_size[1], LINE_LENGTH].min

  [[line_number - 1, 0].max, line_number, [line_number + 1, NUM_LINES].min].map do |current_line_number|
    number_in_array_between(symbols[current_line_number], left_bound, right_bound)
  end.reduce(:|)
end

symbol_index_map = {}
current_line_num = 0
File.readlines('input.txt', chomp: true).map do |line|
  symbol_index_map[current_line_num] = line.to_enum(:scan, SYMBOL_EXPRESSION).map { Regexp.last_match.begin(0) }
  current_line_num += 1
end

current_line_num = 0
sum = File.readlines('input.txt', chomp: true).map do |line|
  numbers = line.to_enum(:scan, DIGIT_EXPRESSION).map do
    [Regexp.last_match.begin(0), Regexp.last_match[0].size, Regexp.last_match[0]]
  end
  filtered_numbers = numbers.select do |number_index_size|
    adjacent_symbol(number_index_size, symbol_index_map, current_line_num)
  end
  filtered_numbers.map! { |number_index_size| number_index_size[2].to_i }
  p filtered_numbers
  current_line_num += 1
  filtered_numbers.sum
end.sum

puts "Sum: #{sum}"

puts DayThree2023.part_one(File.readlines('input.txt', chomp: true).to_a)
