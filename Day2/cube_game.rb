# frozen_string_literal: true

GAME_SPLIT_EXPRESSION = /Game \d+: (.*)/
NUMBER_COLOR_EXPRESSION = /(\d+) (.*)/

sum = File.readlines('input.txt', chomp: true).map do |line|
  cubes = {}
  m = line.match(GAME_SPLIT_EXPRESSION)
  game_data = m[1].split(';')
  game_data.each do |game|
    game.split(',').each do |cube|
      number_color = cube.match(NUMBER_COLOR_EXPRESSION)
      cubes[number_color[2]] = [number_color[1].to_i, cubes[number_color[2]].to_i].max
    end
  end
  cubes.values.inject(:*)
end.sum

puts "Sum: #{sum}"
