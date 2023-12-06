# Class for Day 6 of 
class BoatRace
  class << self
    def get_race_tuples_p1(lines)
      times = lines[0].match(/Time:\s*(.*)/)[1].split(/\s+/).map(&:to_i)
      distances = lines[1].match(/Distance:\s*(.*)/)[1].split(/\s+/).map(&:to_i)
      times.zip(distances)
    end

    def get_race_tuples_p2(lines)
      times = lines[0].match(/Time:\s*(.*)/)[1].split(/\s+/).join.to_i
      p times
      distances = lines[1].match(/Distance:\s*(.*)/)[1].split(/\s+/).join.to_i
      [[times, distances]]
    end

    def calc(races)
      races.map do |time_distance|
        win_nums = 0
        (1..time_distance[0]).each do |button_press|
          win_nums += 1 if button_press * (time_distance[0] - button_press) > time_distance[1]
        end
        win_nums.positive? ? win_nums : 1
      end.reduce(:*)
    end
  end
  def self.part_one(lines)
    races = get_race_tuples_p1(lines)
    calc(races)
  end

  def self.part_two(lines)
    races = get_race_tuples_p2(lines)
    calc(races)
  end

end

lines = File.readlines('input.txt', chomp: true).to_a
p BoatRace.part_one(lines)
p BoatRace.part_two(lines)
