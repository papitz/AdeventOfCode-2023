# frozen_string_literal: true

max_cubes = {
  'red' => 12,
  'green' => 13,
  'blue' => 14
}
GAME_SPLIT_EXPRESSION = /Game (\d+): (.*)/
NUMBER_COLOR_EXPRESSION = /(\d+) (.*)/

sum = File.readlines('input.txt', chomp: true).map do |line|
  m = line.match(GAME_SPLIT_EXPRESSION)
  game_number = m[1]
  game_data = m[2].split(';')
  game_data.each do |game|
    game.split(',').each do |cube|
      number_color = cube.match(NUMBER_COLOR_EXPRESSION)
      game_number = 0 if number_color[1].to_i > max_cubes[number_color[2]]
    end
  end

  game_number.to_i
end.sum

puts "Sum: #{sum}"
