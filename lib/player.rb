# frozen_string_literal: true

# class for creating 2 players instances for each game
class Player
  attr_accessor :name, :symbol

  def initialize
    @name = ''
    @symbol = ''
  end
end
