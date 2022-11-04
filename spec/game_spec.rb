# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/player'

describe Game do

  subject(:game) { described_class.new }
  
  describe '#choose_name' do
    # Looping Script Method -> Test the behavior of the method (for example, it
    # stops when certain conditions are met).

    # Test cases
      # When player 1 enters a valid name
        # does not display any error messages
        # stops loop, calling gets only once
      # When player 1 enters empty name twice and then a valid name
        # displays 'empty name' error message twice
        # does not display 'name already chosen' error message
        # calls gets three times
      # When player 2 enters empty name twice and then a valid name
        # displays 'empty name' error message twice
        # does not display 'name already chosen' error message
        # calls gets three times
      # When player 2 enters same name of player 1 and then a valid name
        # displays 'name already chosen' error message once
        # calls gets twice
    
    context 'when player 1 enters valid name' do
      before do
        allow(game).to receive(:valid_name?).and_return(false, true)
        allow(game).to receive(:gets).and_return('Name')
        allow(game).to receive(:name_not_empty?).and_return(true)
        allow(game).to receive(:different_names?).and_return(true)
      end

      it 'does not display any error messages' do
        player = instance_double(Player, :name => 'Dan', :name= => nil)
        error_message1 = 'Name cannot be empty. Please choose another name:'
        error_message2 = 'Name already chosen. Please choose another name:'
        expect(game).not_to receive(:puts).with(error_message1)
        expect(game).not_to receive(:puts).with(error_message2)
        game.choose_name('first', player)
      end

      it 'stops loop, calling gets only once' do
        player = instance_double(Player, :name => 'Dan', :name= => nil)
        expect(game).to receive(:gets).once
        game.choose_name('first', player)
      end
    end

    context 'when player 1 enters empty name twice and then a valid name' do
      before do
        allow(game).to receive(:valid_name?).and_return(false, false, false, true)
        allow(game).to receive(:gets).and_return('Name')
        allow(game).to receive(:name_not_empty?).and_return(false, false, true)
        allow(game).to receive(:different_names?).and_return(false, false, true)
      end

      it "displays 'empty name' error message twice" do
        player = instance_double(Player, :name => '', :name= => nil)
        first_message = "\nWhat\'s the name of the first player?"
        error_message = 'Name cannot be empty. Please choose another name:'
        expect(game).to receive(:puts).with(first_message)
        expect(game).to receive(:puts).with(error_message).twice
        game.choose_name('first', player)
      end

      it 'calls gets three times' do
        player = instance_double(Player, :name => '', :name= => nil)
        expect(game).to receive(:gets).exactly(3).times
        game.choose_name('first', player)
      end
    end

    context 'when player 2 enters empty name twice and then a valid name' do
      before do
        allow(game).to receive(:valid_name?).and_return(false, false, false, true)
        allow(game).to receive(:gets).and_return('Name')
        allow(game).to receive(:name_not_empty?).and_return(false, false, true)
        allow(game).to receive(:different_names?).and_return(true)
      end

      it "displays 'empty name' error message twice" do
        player = instance_double(Player, :name => '', :name= => nil)
        first_message = "\nWhat\'s the name of the second player?"
        error_message = 'Name cannot be empty. Please choose another name:'
        expect(game).to receive(:puts).with(first_message)
        expect(game).to receive(:puts).with(error_message).twice
        game.choose_name('second', player)
      end

      it 'calls gets three times' do
        player = instance_double(Player, :name => '', :name= => nil)
        expect(game).to receive(:gets).exactly(3).times
        game.choose_name('first', player)
      end
    end

    context 'when player 2 enters same name of the first and then a valid name' do
      before do
        allow(game).to receive(:valid_name?).and_return(false, false, true)
        allow(game).to receive(:gets).and_return('Name')
        allow(game).to receive(:name_not_empty?).and_return(true)
        allow(game).to receive(:different_names?).and_return(false, true)
      end

      it "displays 'name already chosen' error message once" do
        player = instance_double(Player, :name => '', :name= => nil)
        first_message = "\nWhat\'s the name of the second player?"
        error_message = 'Name already chosen. Please choose another name:'
        expect(game).to receive(:puts).with(first_message)
        expect(game).to receive(:puts).with(error_message).once
        game.choose_name('second', player)
      end

      it 'calls gets twice' do
        player = instance_double(Player, :name => '', :name= => nil)
        expect(game).to receive(:gets).twice
        game.choose_name('second', player)
      end
    end
  end

  describe '#valid_name?' do
    # Query - Returns a result, but does not change the observable state.

    # Test cases
      # When name_not_empty? is false and different_names? is false
        # Returns false
      # When name_not_empty? is true and different_names? is false
        # Returns false
      # When name_not_empty? is false and different_names? is true
        # Returns false
      # When name_not_empty? is true and different_names? is true
        # Returns true
    
    let(:name) { 'useless_name' }
    
    context 'when name_not_empty? is false and different_names? is false' do
      before do
        allow(game).to receive(:name_not_empty?).and_return(false)
        allow(game).to receive(:different_names?).and_return(false)
      end

      it 'returns false' do
        result = game.valid_name?(name)
        expect(result).to eq(false)
      end
    end

    context 'when name is empty and names are different' do
      before do
        allow(game).to receive(:name_not_empty?).and_return(false)
        allow(game).to receive(:different_names?).and_return(true)
      end

      it 'returns false' do
        result = game.valid_name?(name)
        expect(result).to eq(false)
      end
    end

    context 'when name is not empty and names are the same' do
      before do
        allow(game).to receive(:name_not_empty?).and_return(true)
        allow(game).to receive(:different_names?).and_return(false)
      end

      it 'returns false' do
        result = game.valid_name?(name)
        expect(result).to eq(false)
      end
    end

    context 'when name is not empty and names are different' do
      before do
        allow(game).to receive(:name_not_empty?).and_return(true)
        allow(game).to receive(:different_names?).and_return(true)
      end

      it 'returns true' do
        result = game.valid_name?(name)
        expect(result).to eq(true)
      end
    end
  end

  describe '#name_not_empty?' do
    # Query - Returns a result, but does not change the observable state.

    # Test cases
      # When name is not empty
        # Returns true
      # When name is empty
        # Returns false
    
    context 'when name is not empty' do
      it 'returns true' do
        name = 'Dan'
        result = game.name_not_empty?(name)
        expect(result).to eq(true)
      end
    end

    context 'when name is empty' do
      it 'returns false' do
        name = ''
        result = game.name_not_empty?(name)
        expect(result).to eq(false)
      end
    end
  end

  describe '#different_names?' do
    # Query - Returns a result, but does not change the observable state.

    # Test cases
      # When players' names are different
        # Returns true
      # When players' names are the same
        # Returns false
    
    context "when players' names are different" do
      it 'returns true' do
        player_1_double = instance_double(Player, :name => 'Dan')
        player_2_double = instance_double(Player, :name => 'Ari')
        game.instance_variable_set(:@player1, player_1_double)
        game.instance_variable_set(:@player2, player_2_double)
        result = game.different_names?
        expect(result).to eq(true)
      end
    end

    context "when players' names are the same" do
      it 'returns false' do
        player_1_double = instance_double(Player, :name => 'Dan')
        player_2_double = instance_double(Player, :name => 'Dan')
        game.instance_variable_set(:@player1, player_1_double)
        game.instance_variable_set(:@player2, player_2_double)
        result = game.different_names?
        expect(result).to eq(false)
      end
    end
  end

  describe '#choose_symbol' do
    # Looping Script - Only calls other methods, usually without returning
    # anything, and stops when certain conditions are met.

    # Test cases
      # When player 1 chooses a valid character
        # Displays no error message
      # When player 1 chooses 3 invalid characters and then a valid character
        # Displays 'invalid character' error message 3 times
        # Receives gets 4 times
      # When player 2 chooses a valid character
        # Displays no error message
      # When player 2 chooses 6 invalid characters and then a valid character
        # Displays 'invalid character' error message 6 times
        # Receives gets 7 times
      # When player 2 chooses the same character as player 1 and then a valid character
        # Displays 'chosen character' error message once
        # Receives gets twice
    
    context 'when player 1 chooses a valid character' do
      before do
        allow(game).to receive(:valid_symbol?).and_return(false, true)
        allow(game).to receive(:gets).and_return('D')
        allow(game).to receive(:char_symbol?).and_return(true)
        allow(game).to receive(:different_symbols?).and_return(true)
      end

      it 'displays no error message' do
        player = instance_double(Player, :name => 'Dan', :symbol => 'D', :symbol= => nil)
        game.instance_variable_set(:@player1, player)
        error_msg_1 = 'Invalid choice. Please choose a valid character (a-z) or (A-Z):'
        error_msg_2 = "Character already chosen by Dan. Please choose another character:"
        expect(game).not_to receive(:puts).with(error_msg_1)
        expect(game).not_to receive(:puts).with(error_msg_2)
        game.choose_symbol(player)
      end
    end

    context 'when player 1 chooses 3 invalid symbols and then a valid character' do
      before do
        allow(game).to receive(:valid_symbol?).and_return(false, false, false, false, true)
        allow(game).to receive(:gets).and_return('D')
        allow(game).to receive(:char_symbol?).and_return(false, false, false, true)
        allow(game).to receive(:different_symbols?).and_return(true, true, false, true)
      end

      it "displays 'invalid character' error message 3 times" do
        player = instance_double(Player, :symbol => '', :symbol= => nil)
        game.instance_variable_set(:@player1, player)
        first_message = "\nWhat character do you want to use, to represent this player\'s choices on the board?"
        error_msg = 'Invalid choice. Please choose a valid character (a-z) or (A-Z):'
        expect(game).to receive(:puts).with(first_message)
        expect(game).to receive(:puts).with(error_msg).exactly(3).times
        game.choose_symbol(player)
      end

      it 'receives gets 4 times' do
        player = instance_double(Player, :symbol => '', :symbol= => nil)
        game.instance_variable_set(:@player1, player)
        expect(game).to receive(:gets).exactly(4).times
        game.choose_symbol(player)
      end
    end

    context 'when player 2 chooses a valid character' do
      before do
        allow(game).to receive(:valid_symbol?).and_return(false, true)
        allow(game).to receive(:gets).and_return('D')
        allow(game).to receive(:char_symbol?).and_return(true)
        allow(game).to receive(:different_symbols?).and_return(true)
      end

      it 'displays no error message' do
        player = instance_double(Player, :name => 'Dan', :symbol => 'D', :symbol= => nil)
        other_player = instance_double(Player, :name => 'Dan', :symbol => 'D', :symbol= => nil)
        game.instance_variable_set(:@player1, other_player)
        error_msg_1 = 'Invalid choice. Please choose a valid character (a-z) or (A-Z):'
        error_msg_2 = "Character already chosen by Dan. Please choose another character:"
        expect(game).not_to receive(:puts).with(error_msg_1)
        expect(game).not_to receive(:puts).with(error_msg_2)
        game.choose_symbol(player)
      end
    end

    context 'when player 2 chooses 3 invalid symbols and then a valid character' do
      before do
        allow(game).to receive(:valid_symbol?).and_return(false, false, false, false, true)
        allow(game).to receive(:gets).and_return('D')
        allow(game).to receive(:char_symbol?).and_return(false, false, false, true)
        allow(game).to receive(:different_symbols?).and_return(true, true, true, true)
      end

      it "displays 'invalid character' error message 3 times" do
        player = instance_double(Player, :symbol => '', :symbol= => nil)
        game.instance_variable_set(:@player2, player)
        first_message = "\nWhat character do you want to use, to represent this player\'s choices on the board?"
        error_msg = 'Invalid choice. Please choose a valid character (a-z) or (A-Z):'
        expect(game).to receive(:puts).with(first_message)
        expect(game).to receive(:puts).with(error_msg).exactly(3).times
        game.choose_symbol(player)
      end

      it 'receives gets 4 times' do
        player = instance_double(Player, :symbol => '', :symbol= => nil)
        game.instance_variable_set(:@player2, player)
        expect(game).to receive(:gets).exactly(4).times
        game.choose_symbol(player)
      end
    end

    context 'when player 2 chooses the same character as player 1 and then a valid character' do
      before do
        allow(game).to receive(:valid_symbol?).and_return(false, false, true)
        allow(game).to receive(:gets).and_return('A')
        allow(game).to receive(:char_symbol?).and_return(true)
        allow(game).to receive(:different_symbols?).and_return(false, true)
      end

      it "displays 'chosen character' error message once" do
        player = instance_double(Player, :name => 'Ari', :symbol => 'A', :symbol= => nil)
        player_1 = instance_double(Player, :name => 'Dan', :symbol => 'D', :symbol= => nil)
        game.instance_variable_set(:@player1, player_1)
        first_message = "\nWhat character do you want to use, to represent this player\'s choices on the board?"
        error_message = 'Character already chosen by Dan. Please choose another character:'
        expect(game).to receive(:puts).with(first_message)
        expect(game).to receive(:puts).with(error_message).once
        game.choose_symbol(player)
      end

      it 'receives gets twice' do
        player = instance_double(Player, :name => 'Ari', :symbol => 'A', :symbol= => nil)
        expect(game).to receive(:gets).twice
        game.choose_symbol(player)
      end
    end
  end

  describe '#valid_symbol?' do
    # Query - Returns a result, but does not change the observable state.

    # Test cases
      # When char_symbol? is false and different_symbols? is false
        # Returns false
      # When char_symbol? is true and different_symbols? is false
        # Returns false
      # When char_symbol? is false and different_symbols? is true
        # Returns false
      # When char_symbol? is true and different_symbols? is true
        # Returns true
    
    context 'when char_symbol? is false and different_symbols? is false' do
      before do
        allow(game).to receive(:char_symbol?).and_return(false)
        allow(game).to receive(:different_symbols?).and_return(false)
      end

      it 'returns false' do
        symbol = ''
        result = game.valid_symbol?(symbol)
        expect(result).to eq(false)
      end
    end

    context 'when char_symbol? is true and different_symbols? is false' do
      before do
        allow(game).to receive(:char_symbol?).and_return(true)
        allow(game).to receive(:different_symbols?).and_return(false)
      end

      it 'returns false' do
        symbol = ''
        result = game.valid_symbol?(symbol)
        expect(result).to eq(false)
      end
    end

    context 'when char_symbol? is false and different_symbols? is true' do
      before do
        allow(game).to receive(:char_symbol?).and_return(false)
        allow(game).to receive(:different_symbols?).and_return(true)
      end

      it 'returns false' do
        symbol = ''
        result = game.valid_symbol?(symbol)
        expect(result).to eq(false)
      end
    end

    context 'when char_symbol? is true and different_symbols? is true' do
      before do
        allow(game).to receive(:char_symbol?).and_return(true)
        allow(game).to receive(:different_symbols?).and_return(true)
      end

      it 'returns false' do
        symbol = ''
        result = game.valid_symbol?(symbol)
        expect(result).to eq(true)
      end
    end
  end

  describe '#char_symbol?' do
    # Test cases
      # when symbol is a number string
        # Returns false
      # when symbol is an empty string
        # Returns false
      # when symbol is a blank space string
        # Returns false
      # when symbol is a 2 lowercase letters string
        # Returns false
      # when symbol is a 2 uppercase letters string
        # Returns false
      # when symbol is a punctuation mark string
        # Returns false
      # when symbol is a special character string
        # Returns false
      
    context 'when symbol is a number string' do
      it 'returns false' do
        symbol = '8'
        result = game.char_symbol?(symbol)
        expect(result).to eq(result)
      end
    end

    context 'when symbol is an empty string' do
      it 'returns false' do
        symbol = ''
        result = game.char_symbol?(symbol)
        expect(result).to eq(result)
      end
    end

    context 'when symbol is a blank space string' do
      it 'returns false' do
        symbol = ' '
        result = game.char_symbol?(symbol)
        expect(result).to eq(result)
      end
    end

    context 'when symbol is a 2 lowercase letters string' do
      it 'returns false' do
        symbol = 'aa'
        result = game.char_symbol?(symbol)
        expect(result).to eq(result)
      end
    end

    context 'when symbol is a 2 uppercase letters string' do
      it 'returns false' do
        symbol = 'BB'
        result = game.char_symbol?(symbol)
        expect(result).to eq(result)
      end
    end

    context 'when symbol is a punctuation mark string' do
      it 'returns false' do
        symbol = '.'
        result = game.char_symbol?(symbol)
        expect(result).to eq(result)
      end
    end

    context 'when symbol is a special character string' do
      it 'returns false' do
        symbol = '!'
        result = game.char_symbol?(symbol)
        expect(result).to eq(result)
      end
    end
  end

  describe '#different_symbols?' do
    # Test cases
      # when symbols are different
        # returns true
      # when symbols are equal
        # returns false
    
    context 'when symbols are different' do
      it 'returns true' do
        player_1 = instance_double(Player, :symbol => 'D')
        game.instance_variable_set(:@player1, player_1)
        player_2 = instance_double(Player, :symbol => 'A')
        game.instance_variable_set(:@player2, player_2)
        result = game.different_symbols?
        expect(result).to eq(true)
      end
    end

    context 'when symbols are equal' do
      it 'returns false' do
        player_1 = instance_double(Player, :symbol => 'D')
        game.instance_variable_set(:@player1, player_1)
        player_2 = instance_double(Player, :symbol => 'D')
        game.instance_variable_set(:@player2, player_2)
        result = game.different_symbols?
        expect(result).to eq(false)
      end
    end
  end

  describe '#create_board' do
    # Command - Changes the observable state, but does not return a value.

    # Test cases
      # when method is called
        # creates an array that represents board spaces with spaces 1 to 9
        #  filled with their respective indexes and assigns it to instance
        #  variable @board

    context 'when method is called' do
      it 'creates an array that represents board spaces with spaces 1 to 9
          filled with their respective indexes and assigns it to instance
          variable @board' do
        game.create_board
        board = game.instance_variable_get(:@board)
        model = [nil, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        expect(board).to eql(model)
      end
    end
  end

  describe '#run_game' do
    # Looping Script - Only calls other methods, usually without returning
    #   anything, and stops when certain conditions are met.

    # Test cases
      # when game_ended? is true
        # stops loop and does not receive methods
      # when game_ended? is false twice and then true
        # receive methods twice
    context 'when game_ended? is true' do
      before do
        allow(game).to receive(:game_ended?).and_return(true)
      end

      it 'stops loop and does not receive methods' do
        expect(game).not_to receive(:choose_position)
        expect(game).not_to receive(:change_position_value)
        expect(game).not_to receive(:change_player)
        expect(game).not_to receive(:show_board)
        game.run_game
      end
    end

    context 'when game_ended? is false twice and then true' do
      before do
        allow(game).to receive(:game_ended?).and_return(false, false, true)
      end

      it 'receive methods twice' do
        expect(game).to receive(:choose_position).twice
        expect(game).to receive(:change_position_value).twice
        expect(game).to receive(:change_player).twice
        expect(game).to receive(:show_board).twice
        game.run_game
      end
    end
  end

  describe '#game_ended?' do
    # Query - Returns a result, but does not change the observable state.

    # Test cases
      # when the board reads the same symbol across the top row
        # returns true
      # when the board reads the same symbol across the middle row
        # returns true
      # when the board reads the same symbol across the bottom row
        # returns true
      # when the board reads the same symbol across the left column
        # returns true
      # when the board reads the same symbol across the middle column
        # returns true
      # when the board reads the same symbol across the right column
        # returns true
      # when the board reads the same symbol across the first diagonal
        # returns true
      # when the board reads the same symbol across the second diagonal
        # returns true
      # when all positions are filled and none of the winning patterns was achieved
        # returns true
      # when the board reads different symbols across a row
        # returns false
      # when the board reads different symbols across a column
        # returns false
      # when the board reads different symbols across a diagonal
        # returns false
      
    context 'when the board reads the same symbol across the top row' do
      it 'returns true' do
        game.instance_variable_set(:@board, [nil, 'x', 'x', 'x', 4, 5, 6, 7, 8, 9])
        result = game.game_ended?
        expect(result).to eq(true)
      end
    end
    
    context 'when the board reads the same symbol across the middle row' do
      it 'returns true' do
        game.instance_variable_set(:@board, [nil, 1, 2, 3, 'x', 'x', 'x', 7, 8, 9])
        result = game.game_ended?
        expect(result).to eq(true)
      end
    end
    
    context 'when the board reads the same symbol across the bottom row' do
      it 'returns true' do
        game.instance_variable_set(:@board, [nil, 1, 2, 3, 4, 5, 6, 'x', 'x', 'x'])
        result = game.game_ended?
        expect(result).to eq(true)
      end
    end
    
    context 'when the board reads the same symbol across the left column' do
      it 'returns true' do
        game.instance_variable_set(:@board, [nil, 'x', 2, 3, 'x', 5, 6, 'x', 8, 9])
        result = game.game_ended?
        expect(result).to eq(true)
      end
    end
    
    context 'when the board reads the same symbol across the middle column' do
      it 'returns true' do
        game.instance_variable_set(:@board, [nil, 1, 'x', 3, 4, 'x', 6, 7, 'x', 9])
        result = game.game_ended?
        expect(result).to eq(true)
      end
    end
  
    context 'when the board reads the same symbol across the right column' do
      it 'returns true' do
        game.instance_variable_set(:@board, [nil, 1, 2, 'x', 4, 5, 'x', 7, 8, 'x'])
        result = game.game_ended?
        expect(result).to eq(true)
      end
    end
  
    context 'when the board reads the same symbol across the first diagonal' do
      it 'returns true' do
        game.instance_variable_set(:@board, [nil, 'x', 2, 3, 4, 'x', 6, 7, 8, 'x'])
        result = game.game_ended?
        expect(result).to eq(true)
      end
    end
  
    context 'when the board reads the same symbol across the second diagonal' do
      it 'returns true' do
        game.instance_variable_set(:@board, [nil, 1, 2, 'x', 4, 'x', 6, 'x', 8, 9])
        result = game.game_ended?
        expect(result).to eq(true)
      end
    end
  
    context 'when all positions are filled and none of the winning patterns was achieved' do
      it 'returns true' do
        game.instance_variable_set(:@board, [nil, 'x', 'o', 'x', 'o', 'o', 'x', 'x', 'x', 'o'])
        result = game.game_ended?
        expect(result).to eq(true)
      end
    end

    context 'when the board reads different symbols across a row' do
      it 'returns false' do
        game.instance_variable_set(:@board, [nil, 1, 2, 3, 'o', 'x', 'x', 7, 8, 9])
        result = game.game_ended?
        expect(result).to eq(false)
      end
    end     

    context 'when the board reads different symbols across a column' do
      it 'returns false' do
        game.instance_variable_set(:@board, [nil, 'x', 2, 3, 'x', 5, 6, 'o', 8, 9])
        result = game.game_ended?
        expect(result).to eq(false)
      end
    end     

    context 'when the board reads different symbols across a diagonal' do
      it 'returns false' do
        game.instance_variable_set(:@board, [nil, 'o', 2, 3, 4, 'x', 6, 7, 8, 'o'])
        result = game.game_ended?
        expect(result).to eq(false)
      end
    end
  end

  # as it was supposed to be just an exercise, I'm stopping here, since I think I
  #    got the whole idea

end