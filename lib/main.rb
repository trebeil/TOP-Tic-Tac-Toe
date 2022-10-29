# frozen_string_literal: true

require_relative 'game'

Game.welcome_message
loop do
  game = Game.new
  game.play_game
  break unless game.play_again?
end
