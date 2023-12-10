class Mirage
  class << self
    def get_next_num(nums)
      return 0 if nums.all?(&:zero?)

      next_line = []
      nums.each_with_index { |elem, index| next_line << ((nums[index + 1] || 0) - elem) }
      nums[-1] + get_next_num(next_line[...-1])
    end

    def get_next_num_p2(nums)
      return 0 if nums.all?(&:zero?)

      next_line = []
      nums.each_with_index { |elem, index| next_line << ((nums[index + 1] || 0) - elem) }
      nums[0] - get_next_num_p2(next_line[...-1])
    end
  end
  def self.part_one(lines)
    lines.map do |line|
      get_next_num(line.split(/\s+/).map(&:to_i))
    end.sum
  end

  def self.part_two(lines)
    lines.map do |line|
      num = get_next_num_p2(line.split(/\s+/).map(&:to_i))
      num
    end.sum
  end
end

lines = File.readlines('input.txt', chomp: true).to_a
p Mirage.part_two(lines)
