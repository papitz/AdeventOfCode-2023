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

    def traverse_map(directions, node_map, start_node, end_node = nil)
      steps = 0
      current_node = start_node
      loop do
        current_node = node_map[current_node][directions[steps % directions.size]]
        steps += 1
        return steps if end_node.nil? ? current_node[-1] == 'Z' : current_node == end_node
      end
    end

    def traverse_map_as_ghost(directions, node_map)
      current_nodes = node_map.keys.select { |string| string[-1] == 'A' }
      current_nodes = current_nodes.map do |current_node|
        traverse_map(directions, node_map, current_node)
      end
      current_nodes.reduce(1, &:lcm)
    end
  end

  def self.part_one(lines)
    directions = lines[0].chars.map { |c| c == 'L' ? 0 : 1 }
    node_map = generate_node_map(lines[2..])
    traverse_map(directions, node_map, START_NODE, END_NODE)
  end

  def self.part_two(lines)
    directions = lines[0].chars.map { |c| c == 'L' ? 0 : 1 }
    node_map = generate_node_map(lines[2..])
    traverse_map_as_ghost(directions, node_map)
  end
end

lines = File.readlines('input.txt', chomp: true).to_a
# lines = File.readlines('example.txt', chomp: true).to_a
p WastelandNavigation.part_two(lines)
