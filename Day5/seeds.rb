class SeedsDay5
  DIGIT_EXPRESSION = /(\d+) (\d+) (\d+)/
  MAP_HEADER_EXPRESSION = /.+ map:/
  class << self
    def generate_seed_list(line)
      line.match(/seeds: (.*)/)[1].split(' ').map(&:to_i)
    end

    def get_line_data(line)
      m = line.match(DIGIT_EXPRESSION)
      [m[1], m[2], m[3]].map(&:to_i)
    end

    def generate_map(lines)
      map = {}
      lines.each do |line|
        dest_start, source_start, range = get_line_data(line)
        map[(source_start..source_start + range)] = [dest_start, source_start]
      end
      map
    end

    def get_value(key, map)
      res = map.detect { |k, _v| k === key } || key
      return res unless res.is_a?(Array)

      res[1][0] + (key - res[1][1])
    end

    def parse_data_blocks(lines)
      data_array = [[]]
      current_data_no = 0
      lines.each do |line|
        next if line.empty?

        if MAP_HEADER_EXPRESSION.match?(line)
          current_data_no += 1
          data_array[current_data_no] = []
        else
          data_array[current_data_no] << line
        end
      end
      data_array
    end

    def traverse_maps(seed, map_map)
      map_map.each_value { |map| seed = get_value(seed, map) }
      seed
    end
  end

  def self.part_one(lines)
    seeds = generate_seed_list(lines[0])
    map_map = {}
    parse_data_blocks(lines[3..]).each_with_index do |data, index|
      map_map[index] = generate_map(data)
    end
    seeds.map! do |seed|
      traverse_maps(seed, map_map)
    end
    seeds.min
  end
end

lines = File.readlines('input.txt', chomp: true).to_a
puts SeedsDay5.part_one(lines)
