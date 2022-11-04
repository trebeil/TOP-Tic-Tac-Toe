# frozen_string_literal: true

require_relative 'player'

class Game

  def initialize
    @player1 = Player.new
    @player2 = Player.new
    @board = []
    @current_player = @player1
  end

  def Game.welcome_message
    puts 'Welcome to Tic-Tac-Toe!'
  end

  def play_game
    choose_name('first', @player1)
    choose_symbol(@player1)
    choose_name('second', @player2)
    choose_symbol(@player2)
    player_greetings
    
    puts "\nThis is the board. All positions with numbers are available."
    
    create_board
    show_board
    run_game
    show_result
  end

  def choose_name(order, player_object)
    puts "\nWhat\'s the name of the #{order} player?"
    
    until valid_name?(player_object.name)
      player_object.name = gets.chomp

      puts 'Name cannot be empty. Please choose another name:' unless name_not_empty?(player_object.name)
      puts 'Name already chosen. Please choose another name:' unless different_names? || order == 'first'
    end
  end

  def valid_name?(name)
    name_not_empty?(name) && different_names?
  end

  def name_not_empty?(name)
    name != ''
  end

  def different_names?
    @player2.name != @player1.name
  end

  def choose_symbol(player_object)
    puts "\nWhat character do you want to use, to represent this player\'s choices on the board?"

    until valid_symbol?(player_object.symbol)
      player_object.symbol = gets.chomp

      puts 'Invalid choice. Please choose a valid character (a-z) or (A-Z):' unless char_symbol?(player_object.symbol)

      puts "Character already chosen by #{@player1.name}. Please choose another character:" unless different_symbols? || player_object == @player1
    end
  end

  def valid_symbol?(symbol)
    char_symbol?(symbol) && different_symbols?
  end

  def char_symbol?(symbol)
    /^[a-zA-Z]{1}$/.match?(symbol)
  end

  def different_symbols?
    @player2.symbol != @player1.symbol
  end

  def player_greetings
    puts "\nHi #{@player1.name} and #{@player2.name}! Let's start!"

    sleep 2

    puts "\n#{@player1.name} will be represented by #{@player1.symbol} and "\
            "#{@player2.name} will be represented by #{@player2.symbol}."

    sleep 2
  end

  def create_board
    (1..9).each { |i| @board[i] = i }
  end

  def show_board
    puts "\n #{@board[1]} | #{@board[2]} | #{@board[3]} \n---+---+---\n"\
         " #{@board[4]} | #{@board[5]} | #{@board[6]} \n---+---+---\n"\
         " #{@board[7]} | #{@board[8]} | #{@board[9]} "
  end

  def run_game
    until game_ended?
      choice = choose_position
      change_position_value(choice, @current_player.symbol)
      change_player
      show_board
    end
  end

  def game_ended?
    @board[1] == @board[2] && @board[2] == @board[3] ||
    @board[4] == @board[5] && @board[5] == @board[6] ||
    @board[7] == @board[8] && @board[8] == @board[9] ||
    @board[1] == @board[4] && @board[4] == @board[7] ||
    @board[2] == @board[5] && @board[5] == @board[8] ||
    @board[3] == @board[6] && @board[6] == @board[9] ||
    @board[1] == @board[5] && @board[5] == @board[9] ||
    @board[3] == @board[5] && @board[5] == @board[7] ||
    @board.none?(1..9)
  end

  def choose_position
    puts "\n#{@current_player.name}, choose an available position:"

    choice = gets.chomp.to_i

    until valid_choice?(choice)
      puts "Invalid choice. Please choose a valid position:" unless choice_is_digit?(choice)
      puts "Position already chosen. Choose another position:" unless position_available?(choice)
      choice = gets.chomp.to_i
    end
    choice
  end

  def valid_choice?(choice)
    choice_is_digit?(choice) && position_available?(choice)
  end

  def choice_is_digit?(choice)
    /^[1-9]{1}$/.match?(choice.to_s)
  end

  def position_available?(choice)
    @board[choice] != @player1.symbol && @board[choice] != @player2.symbol
  end

  def change_position_value(index, value)
    @board[index] = value
  end

  def change_player
    @current_player = @current_player == @player1 ? @player2 : @player1
  end

  def show_result
    if @board.none?(1..9)
      puts "\nIt\'s a Draw!"
    else
      change_player
      puts "\n#{@current_player.name} wins!"
    end
  end

  def play_again?(choice = '')
    puts "\nDo you want to play again? [y/n]"
    
    until y_or_n?(choice)
      choice = gets.chomp

      puts "\nInvalid option. Do you want to play again? [y/n]" unless y_or_n?(choice)
    end

    choice == 'y' ? true : false
  end

  def y_or_n?(input)
    /^[yn]{1}$/.match?(input)
  end
end
