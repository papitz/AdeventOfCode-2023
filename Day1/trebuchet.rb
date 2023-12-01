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

sum = 0
File.readlines('input.txt', chomp: true).each do |line|
  matches = line.scan(Regexp.new(DIGIT_EXPRESSION)).flatten

  first = matches.first
  last = matches.last
  first = first.size > 1 ? WRITTEN_NUMBERS[first] : first
  last = last.size > 1 ? WRITTEN_NUMBERS[last] : last
  number = first + last
  sum += number.to_i
end

puts "sum #{sum}"
