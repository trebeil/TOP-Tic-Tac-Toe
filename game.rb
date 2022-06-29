# frozen_string_literal: true

# class for creating each game instance
class Game
  attr_reader :board
  attr_accessor :player1, :player2

  def initialize
    @player1 = Player.new
    @player2 = Player.new
    @board = Board.new
  end

  def start_new_game
    puts
    puts 'What\'s the name of the first player?'

    player1.name = gets.chomp

    puts
    puts 'What character do you want to use, to represent your choices on the board?'

    player1.symbol = gets.chomp

    until /^[a-zA-Z]{1}$/.match?(player1.symbol)
      puts
      puts 'Invalid choice. Please choose a valid character (a-z) or (A-Z):'
      player1.symbol = gets.chomp
    end

    puts
    puts 'What\'s the name of the second player?'

    player2.name = gets.chomp

    while player2.name == player1.name
      puts
      puts 'Name already chosen. Please choose another name for the second player'
      player2.name = gets.chomp
    end

    puts
    puts 'What character do you want to use, to represent your choices on the board?'

    player2.symbol = gets.chomp

    until /^[a-zA-Z]{1}$/.match?(player2.symbol) && 
        player2.symbol != player1.symbol
      puts
      if player2.symbol == player1.symbol
        puts "Character already chosen by #{player1.name}. Please choose another character:"
      else
        puts 'Invalid choice. Please choose a valid character (a-z) or (A-Z):'
      end
      player2.symbol = gets.chomp
    end

    puts
    puts "Hi #{player1.name} and #{player2.name}! Let's start!"

    sleep 2

    puts
    puts "#{player1.name} will be represented by #{player1.symbol} and "\
            "#{player2.name} will be represented by #{player2.symbol}."

    sleep 2

    puts
    puts 'This is the board. All positions with numbers are available.'
    board.start_board
    board.show_board
  end

  def run_game
    current_player = player1

    until board.game_ended?
      puts
      puts "#{current_player.name}, choose an available position:"

      choice = gets.chomp.to_i

      until /^[1-9]{1}$/.match?(choice.to_s) &&
            (board.positions[choice] != player1.symbol && 
              board.positions[choice] != player2.symbol)

        puts

        if board.positions[choice] == player1.symbol || 
          board.positions[choice] == player2.symbol
          puts 'Position already chosen. Choose another position:'
        else
          puts 'Invalid choice. Please choose a valid position:'
        end

        choice = gets.chomp.to_i
      end

      board.change_positions(choice, current_player.symbol)

      current_player = current_player == player1 ? player2 : player1

      puts
      board.show_board
    end

    puts
    if board.positions.none?(1..9)
      puts 'It\'s a Draw!'
    else
      current_player = current_player == player1 ? player2 : player1
      puts "#{current_player.name} wins!"
    end
  end
end
