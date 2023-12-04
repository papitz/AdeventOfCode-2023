# frozen_string_literal: true

# Day3 of advent of code. Today we evaluate Scratchcards
class Scratchcards
  LIST_EXPRESSION = /Card\s*\d+: (.+) \| (.+)/
  class << self
    def eval_card(our_numbers, winning_numbers)
      number_of_winning_nums = winning_numbers.intersection(our_numbers).size
      number_of_winning_nums.positive? ? 2**(number_of_winning_nums - 1) : 0
    end

    def get_numbers(line)
      m = line.match LIST_EXPRESSION
      [m[1].split(' ').map(&:to_i), m[2].split(' ').map(&:to_i)]
    end

    def add_copies(cards, num_of_wins, index, original_num_of_cards)
      (1..num_of_wins).each do |offset|
        break if index + 1 + offset > original_num_of_cards

        cards[index + 1 + offset] += cards[index + 1]
      end
    end
  end

  def self.part_one(lines)
    lines.map do |line|
      lists = get_numbers(line)
      winning_numbers = lists[0]
      our_numbers = lists[1]
      eval_card(our_numbers, winning_numbers)
    end.sum
  end

  def self.part_two(lines)
    original_num_of_cards = lines.size
    cards = (1..original_num_of_cards).each_with_object({}) { |key, hash| hash[key] = 1 }

    lines.each_with_index do |line, index|
      winning_numbers, our_numbers = get_numbers(line)
      num_of_wins = winning_numbers.intersection(our_numbers).size
      add_copies(cards, num_of_wins, index, original_num_of_cards)
    end
    cards.values.sum
  end
end

lines = File.readlines('input.txt', chomp: true).to_a
puts Scratchcards.part_two(lines)
