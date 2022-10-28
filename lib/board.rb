# frozen_string_literal: true

# class for creating 1 board instance for each game
class Board
  attr_reader :positions

  def initialize
    @positions = []
  end

  def start_board
    (1..9).each { |i| positions[i] = i }
  end

  def show_board
    puts
    puts " #{positions[1]} | #{positions[2]} | #{positions[3]} \n---+---+---\n"\
         " #{positions[4]} | #{positions[5]} | #{positions[6]} \n---+---+---\n"\
         " #{positions[7]} | #{positions[8]} | #{positions[9]} "
  end

  def game_ended?
    positions[1] == positions[2] && positions[2] == positions[3] ||
    positions[4] == positions[5] && positions[5] == positions[6] ||
    positions[7] == positions[8] && positions[8] == positions[9] ||
    positions[1] == positions[4] && positions[4] == positions[7] ||
    positions[2] == positions[5] && positions[5] == positions[8] ||
    positions[3] == positions[6] && positions[6] == positions[9] ||
    positions[1] == positions[5] && positions[5] == positions[9] ||
    positions[3] == positions[5] && positions[5] == positions[7] ||
    positions.none?(1..9)
  end

  def change_positions(index, value)
    positions[index] = value
  end

end
