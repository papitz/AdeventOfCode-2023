# frozen_string_literal: true

WRITTEN_NUMBERS = {
  'one' => '1',
  'two' => '2',
  'three' => '3',
  'four' => '4',
  'five' => '5',
  'six' => '6',
  'seven' => '7',
  'eight' => '8',
  'nine' => '9'
}.freeze
DIGIT_EXPRESSION = "(?=(#{WRITTEN_NUMBERS.keys.join('|')}|\\d))".freeze

sum = File.readlines('input.txt', chomp: true).map do |line|
  matches = line.scan(Regexp.new(DIGIT_EXPRESSION)).flatten
  [
    WRITTEN_NUMBERS[matches.first] || matches.first,
    WRITTEN_NUMBERS[matches.last] || matches.last
  ].join.to_i
end.sum

puts "Sum: #{sum}"
