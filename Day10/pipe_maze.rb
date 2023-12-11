# frozen_string_literal: true

# Class for Day10 of AOC
class Pipes
  PIPE_DIRECTIONS = {
    '|' => { :^ => :^, :v => :v },
    '-' => { :> => :>, :< => :< },
    'J' => { :v => :<, :> => :^ },
    'F' => { :< => :v, :^ => :> },
    'L' => { :< => :^, :v => :> },
    '7' => { :> => :v, :^ => :< }
  }.freeze

  DIRECTIONS_COORD = {
    :v => [1, 0],
    :^ => [-1, 0],
    :> => [0, 1],
    :< => [0, -1]
  }.freeze

  class << self
    def generate_matrix(lines)
      matrix = []
      lines.each do |line|
        matrix.append(line.chars.to_a)
      end
    end

    def get_next_pipe(row, col, dir, matrix)
      next_row = row + DIRECTIONS_COORD[dir][0]
      next_col = col + DIRECTIONS_COORD[dir][1]
      char = matrix[next_row][next_col]
      p char
      next_dir = PIPE_DIRECTIONS[char][dir]
      [[next_row, next_col], next_dir]
    end

    def find_start(matrix)
      row = matrix.detect { |curr_row| curr_row.include?('S') }
      [matrix.index(row), row.index('S')]
    end

    def traverse(start_row, start_col, matrix)
      curr_check = [start_row, start_col]
      dir = :> # Hard coded
      steps = 0
      loop do
        curr_check, dir = get_next_pipe(curr_check[0], curr_check[1], dir, matrix)
        steps += 1
        break if curr_check == [start_row, start_col]
      end
      steps / 2
    end
  end
  def self.part_one(lines)
    matrix = generate_matrix(lines)
    start_row, start_col = find_start(matrix)
    matrix[start_row][start_col] = 'L' # Hard coded
    traverse(start_row, start_col, matrix)
  end
end

lines = File.readlines('input.txt', chomp: true).to_a
p Pipes.part_one(lines)
