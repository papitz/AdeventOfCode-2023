# frozen_string_literal: true

# Class for day 5 of aoc
class WastelandNavigation
  START_NODE = 'AAA'
  END_NODE = 'ZZZ'
  class << self
    def generate_node_map(lines)
      lines.map do |line|
        name, left, right = line.match(/(\w+)\s+=\s+\((\w+),\s+(\w+)\)/)[1..3]
        [name, [left, right]]
      end.to_h
    end

    def traverse_map(directions, node_map)
      steps = 0
      current_node = START_NODE
      loop do
        current_node = node_map[current_node][directions[steps % directions.size]]
        steps += 1
        return steps if current_node == END_NODE
      end
    end
  end

  def self.part_one(lines)
    directions = lines[0].chars.map { |c| c == 'L' ? 0 : 1 }
    node_map = generate_node_map(lines[2..])
    traverse_map(directions, node_map)
  end
end

lines = File.readlines('input.txt', chomp: true).to_a
p WastelandNavigation.part_one(lines)
