class SeedsDay5
  DIGIT_EXPRESSION = /(\d+) (\d+) (\d+)/
  MAP_HEADER_EXPRESSION = /.+ map:/
  class << self
    def generate_seed_list_p1(line)
      line.match(/seeds: (.*)/)[1].split(' ').map(&:to_i)
    end

    def generate_seed_list_p2(line)
      seeds = []
      pairs = line.match(/seeds: (.*)/)[1].scan(/\d+ \d+/).to_a
      pairs.map { |pair| pair.split(' ').map(&:to_i) }.each do |pair|
        seeds << (pair[0]..pair[0] + pair[1])
      end
      seeds
      # split(' ').map(&:to_i)
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
      # p map
      map = map.sort_by { |k, v| k.first }.to_h
      start_value = 0
      stuffed_ranges = []
      map.each_key do |range|
        if range.first > start_value
          one_before_range = range.first
          stuffed_ranges << [(start_value..one_before_range), [one_before_range, one_before_range]]
        end
        start_value = range.last
      end
      stuffed_ranges.each { |entry| map[entry[0]] = entry[1]}
      # p ("MAP #{map} \n\n\n")
      map
    end

    def get_value(key, map)
      res = map.detect { |k, _v| k === key }# || key
      return res unless res.is_a?(Array)

      p res

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

    def split_ranges(ranges, map)
      new_ranges, ranges = ranges.partition { |range| map.keys.detect { |k| k.cover?(range) } }
      #  TODO: Find all that are not inside, split all others
      p ranges, new_ranges
    end

    # Divide and conquer. Not fast enough yet
    def find_smallest_in_range(range, map_map)
      left = traverse_maps(range.first, map_map)
      right = traverse_maps(range.last, map_map)
      #  TODO: Minus here check if works
      return left if left == (right - (range.last - range.first))

      #  TODO: Get proper next without guessing. Possible?
      new_lower_limit = map_map[0].detect { |k, _v| k === range.first }
      p map_map[0]
      p new_lower_limit, range.first
      # [0].last + 1
      [left, find_smallest_in_range((new_lower_limit + 1..range.last), map_map)].min
    end
  end

  def self.part_one(lines)
    seeds = generate_seed_list_p1(lines[0])
    map_map = {}
    parse_data_blocks(lines[3..]).each_with_index do |data, index|
      map_map[index] = generate_map(data)
    end
    seeds.map! do |seed|
      traverse_maps(seed, map_map)
    end
    seeds.min
  end

  def self.part_two(lines)
    min = Float::INFINITY
    seeds = generate_seed_list_p2(lines[0])
    map_map = {}
    parse_data_blocks(lines[3..]).each_with_index do |data, index|
      map_map[index] = generate_map(data)
    end
    # split_ranges(seeds, map_map[0])
    seeds.each do |seed_range|
      p seed_range
      min = [min, find_smallest_in_range(seed_range, map_map)].min
      p min
    end
    min
    #  TODO: Split ranges in each step, checking where they collide
  end
end

lines = File.readlines('input.txt', chomp: true).to_a
p SeedsDay5.part_two(lines)
