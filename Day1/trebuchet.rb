# frozen_string_literal: true

DIGIT_EXPRESSION = /\D*(\d).*?(\d)?\D*$/.freeze
sum = 0
File.readlines('input.txt', chomp: true).each do |line|
  match = line.match(DIGIT_EXPRESSION)
  number = match[1] + (match[2].nil? ? match[1] : match[2])
  sum += number.to_i
end

puts "sum #{sum}"
