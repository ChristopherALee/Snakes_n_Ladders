require_relative 'player'
require_relative 'board'

class SnakesLadders
	attr_reader :player1, :player2, :board
	attr_accessor :current_player, :other_player, :turn, :move

	def initialize(player1, player2)
		@player1 = player1
		@player2 = player2
		@player1.mark = "1"
		@player2.mark = "2"
		@current_player = player1
		@other_player = player2
		@board = Board.new
		@turn = 1.0
		@move = nil
		@land_snake = false
		@land_ladder = false
	end

	def play
		system("clear")
		@board.display

		until game_over?
			play_turn
			display_status
			switch_players
			@turn += 0.5
			@land_snake = false
			@land_ladder = false
		end

		if winner
			p "#{winner} wins!"
		end
	end

	def play_turn
		@move = current_player.roll_dice

		# getting current position
		if @turn == 1.0
			current_pos = [9, 0]
		else
			current_pos = nil
			@board.grid.each_with_index do |row, idx|
				if row.index(@current_player.mark) != nil
					current_pos = [idx, row.index(@current_player.mark)]
				elsif row.index(:b) != nil
					current_pos = [idx, row.index(:b)]
				end

				break if row.index(@current_player.mark) != nil || row.index(:b) != nil
			end
		end

		# getting next position
		next_pos = @current_player.next_position(current_pos, @move)

		# moving to the next level
		if next_pos.last > 9 && next_pos.last < 20
			next_pos = [next_pos.first - 1, 9 - (next_pos.last - 10)]
		elsif next_pos.last >= 20
			next_pos = [next_pos.first - 2, next_pos.last - 20]
		elsif next_pos.last < 0 && next_pos.last >= -9
			if next_pos.first == 0 # checking if it goes past FINISH
				next_pos = [next_pos.first, 10 - (10 + next_pos.last)]
			else
				next_pos = [next_pos.first - 1, 9 - (next_pos.last + 10)]
			end
		elsif next_pos.last <= -10
			if next_pos.first == 0
				next_pos = [next_pos.first + 2, next_pos.last + 19]
			else
				next_pos = [next_pos.first - 2, next_pos.last + 20]
			end
		end

		# deleting piece from current position
		delete_current_position(current_pos)

		# placing the new position
		if @board.grid[next_pos.first][next_pos.last].nil?
			@board.grid[next_pos.first][next_pos.last] = @current_player.mark
		elsif @board.grid[next_pos.first][next_pos.last] == :S
			snake_pos = @board.snake(next_pos)
			if @board.grid[snake_pos.first][snake_pos.last] == @other_player.mark
				@board.grid[snake_pos.first][snake_pos.last] = :b
			else
				@board.grid[snake_pos.first][snake_pos.last] = @current_player.mark
			end
			@land_snake = true
		elsif @board.grid[next_pos.first][next_pos.last] == :L
			ladder_pos = @board.ladder(next_pos)
			if @board.grid[ladder_pos.first][ladder_pos.last] == @other_player.mark
				@board.grid[ladder_pos.first][ladder_pos.last] = :b
			else
				@board.grid[ladder_pos.first][ladder_pos.last] = @current_player.mark
			end
			@land_ladder = true
		elsif @board.grid[next_pos.first][next_pos.last] == @other_player.mark
			@board.grid[next_pos.first][next_pos.last] = :b
		end
	end

	def past_finish?(next_pos)
		if next_pos.first == 0
			if next_pos.last < 0
				return true
			else
				return false
			end
		end

		false
	end

	def delete_current_position(current_pos)
		if @board.grid[current_pos.first][current_pos.last] == :b
			@board.grid[current_pos.first][current_pos.last] = @other_player.mark
		else
			@board.grid[current_pos.first][current_pos.last] = nil
		end
	end

	def switch_players
		if @current_player == player1
			@current_player = player2
			@other_player = player1
		else
			@current_player = player1
			@other_player = player2
		end
	end

	def game_over?
		if @board.grid[0][0].nil?
			return false
		else
			return true
		end
	end

	def winner
		if @board.grid[0][0] == "1"
			return @player1.name
		elsif @board.grid[0][0] == "2"
			return @player2.name
		end

		nil
	end

	def display_status
		system("clear")
		@board.display
		puts ""
		puts "PLAYER FEED // Turn: #{@turn}"
		puts "------------------------------"
		p "#{current_player.name} rolled a #{@move}!"
		p "Oh no! #{current_player.name} landed on a snake!" if @land_snake
		p "Woohoo! #{current_player.name} climbed a ladder!" if @land_ladder
		puts ""
	end
end

if $PROGRAM_NAME == __FILE__
	system("clear")
	p "Welcome to Snakes and Ladders!"
	print "Player 1, enter your name: "
	player1 = gets.chomp.capitalize
	print "Player 2, enter your name: "
	player2 = gets.chomp.capitalize

	player_1 = Player.new(player1)
	player_2 = Player.new(player2)

	new_game = SnakesLadders.new(player_1, player_2)
	new_game.play
end
