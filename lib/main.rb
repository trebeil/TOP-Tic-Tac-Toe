# frozen_string_literal: true

require_relative 'player'
require_relative 'board'
require_relative 'game'

play_again = 'y'
puts 'Welcome to Tic-Tac-Toe!'

while play_again == 'y'
  game = Game.new
  game.start_new_game
  game.run_game

  puts
  puts 'Do you want to play again? [y/n]'
  play_again = gets.chomp
  until /^[yn]{1}$/.match?(play_again)
    puts
    puts 'Invalid option. Do you want to play again? [y/n]'
    play_again = gets.chomp
  end
end
