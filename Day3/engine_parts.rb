# frozen_string_literal: true

# Class to solve day3 of advent of code
class AOCDayThree
  DIGIT_EXPRESSION = /\d+/
  SYMBOL_EXPRESSION = /[^\w.]/
  STAR_EXPRESSION = /[*]/
  LINE_LENGTH = 158
  NUM_LINES = 139

  class << self
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

    def get_numbers(line)
      line.to_enum(:scan, DIGIT_EXPRESSION).map do
        [Regexp.last_match.begin(0), Regexp.last_match[0].size, Regexp.last_match[0]]
      end
    end

    def number_is_adjacent?(left_bound, right_bound, index, number_index, number_index_plus_size)
      left_bound.between?(number_index, number_index_plus_size) ||
        right_bound.between?(number_index, number_index_plus_size) ||
        index.between?(number_index, number_index_plus_size)
    end

    def get_neighboring_numbers(index, line_number, number_map)
      neighbors = []
      left_bound = [index - 1, 0].max
      right_bound = [index + 1, LINE_LENGTH].min

      [[line_number - 1, 0].max, line_number, [line_number + 1, NUM_LINES].min].each do |current_line_number|
        neighbors += number_map[current_line_number].select do |num_object|
          number_is_adjacent?(left_bound, right_bound, index, num_object[0], num_object[0] + num_object[1] - 1)
        end
      end
      neighbors.map { |number_object| number_object[2].to_i }
    end

    def build_symbol_map(lines, symbol_expression)
      symbol_index_map = {}
      current_line_num = 0
      lines.map do |line|
        symbol_index_map[current_line_num] = line.to_enum(:scan, symbol_expression).map { Regexp.last_match.begin(0) }
        current_line_num += 1
      end

      symbol_index_map
    end

    def build_number_map(lines)
      number_index_map = {}
      lines.each_with_index do |line, index|
        number_index_map[index] = get_numbers(line)
      end
      number_index_map
    end
  end

  def self.part_one(lines)
    symbol_index_map = build_symbol_map(lines, SYMBOL_EXPRESSION)
    current_line_num = 0
    lines.map do |line|
      numbers = get_numbers(line)
      filtered_numbers = numbers.select do |number_index_size|
        adjacent_symbol(number_index_size, symbol_index_map, current_line_num)
      end
      current_line_num += 1
      filtered_numbers.map! { |number_index_size| number_index_size[2].to_i }.sum
    end.sum
  end

  def self.part_two(lines)
    symbol_index_map = build_symbol_map(lines, STAR_EXPRESSION)
    number_index_map = build_number_map(lines)
    symbol_index_map.map do |line_number, index_ary|
      index_ary.map do |symbol_index|
        neighbors = get_neighboring_numbers(symbol_index, line_number, number_index_map)
        neighbors.size == 2 ? neighbors.reduce(:*) : 0
      end.sum
    end.sum
  end
end

lines = File.readlines('input.txt', chomp: true).to_a
puts AOCDayThree.part_two(lines)
