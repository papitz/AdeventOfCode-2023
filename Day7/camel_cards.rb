require 'pp'

class CamelCards
  class << self
  end

  def self.part_one(lines)
    # out = File.open("r_out.txt", "w")
    hands = lines.map do |line|
      hand_string, bid = line.split(/\s+/)
      [Hand.new(hand_string), bid.to_i]
    end.sort_by(&:first).to_h
    pp hands
    winnings = 0
    hands.keys.each_with_index do |key, index|
      puts "Key#{key.hand_string} index #{index} bid #{hands[key]}"
      # out.puts(key.hand_string)
      winnings += hands[key] * (index + 1)
    end
    winnings
  end

  def self.part_two(lines)
    out = File.open("r_out.txt", "w")
    hands = lines.map do |line|
      hand_string, bid = line.split(/\s+/)
      [HandPartTwo.new(hand_string), bid.to_i]
    end.sort_by(&:first).to_h
    pp hands
    winnings = 0
    hands.keys.each_with_index do |key, index|
      puts "Key#{key.hand_string} index #{index} bid #{hands[key]}"
      out.puts(key.hand_string)
      winnings += hands[key] * (index + 1)
    end
    winnings
  end
end

class Hand
  include Comparable
  attr_reader :hand_string

  @@order = {
    '2' => 0,
    '3' => 1,
    '4' => 3,
    '5' => 4,
    '6' => 5,
    '7' => 6,
    '8' => 7,
    '9' => 8,
    'T' => 9,
    'J' => 10,
    'Q' => 11,
    'K' => 12,
    'A' => 13
  }.freeze

  def initialize(hand_string)
    @hand_string = hand_string
  end

  # 6 = Five of a kind
  # 5 = Four of a kind
  # 4 = Full house
  # 3 = three of a kind
  # 2 = two pair
  # 1 = One pair
  # 0 = High Card
  def evaluate_type
    counts = @hand_string.chars.group_by(&:itself).transform_values(&:size).values
    type_from_counts(counts)
  end

  def type_from_counts(counts)
    if counts.include?(5)
      6
    elsif counts.include?(4)
      5
    elsif counts.include?(2) && counts.include?(3)
      4
    elsif counts.include?(3)
      3
    elsif counts.count(2) == 2
      2
    elsif counts.include?(2)
      1
    else
      0
    end
  end

  def <=>(other)
    return evaluate_type <=> other.evaluate_type if evaluate_type != other.evaluate_type

    @hand_string.chars.each_with_index do |char, index|
      return @@order[char] <=> @@order[other.hand_string[index]] if char != other.hand_string[index]
    end
    0
  end
end

class HandPartTwo < Hand
  @@order = {
    'J' => 0,
    '2' => 1,
    '3' => 3,
    '4' => 4,
    '5' => 5,
    '6' => 6,
    '7' => 7,
    '8' => 8,
    '9' => 9,
    'T' => 10,
    'Q' => 11,
    'K' => 12,
    'A' => 13
  }.freeze

  def evaluate_type
    counts = @hand_string.chars.group_by(&:itself).transform_values(&:size)
    if counts.keys.include?('J') && counts['J'] == 5
      counts['A'] = 5
      counts['J'] = 0
    elsif counts.keys.include? 'J'
      j_amount = counts['J']
      counts['J'] = 0
      counts[counts.max_by { |_k, v| v }.first] += j_amount
    end
    type_from_counts(counts.values)
  end
end

lines = File.readlines('input.txt', chomp: true).to_a
# puts CamelCards.part_one(lines)
puts CamelCards.part_two(lines)
hand = Hand.new('AA5A8')
hand2 = Hand.new('AKAAK')
puts hand2.evaluate_type
