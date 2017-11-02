class Player
	attr_accessor :name, :mark

	def initialize(name)
		@name = name
	end

	def roll_dice
		p "#{name}, roll die? (y/n)"
		print "> "
		answer = gets.chomp.downcase

		until answer == "y"
			answer = gets.chomp.downcase
		end

		die = [(1..6).to_a.sample, (1..6).to_a.sample]
		die.inject(:+)
	end

	def next_position(current_pos, move)
		if current_pos.first.odd?
			next_pos = [current_pos.first, current_pos.last + move]
		else
			next_pos = [current_pos.first, current_pos.last - move]
		end

		next_pos
	end
end
