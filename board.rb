class Board
	SPECIAL = {
		"ladder" => :L,
		"snake" => :S,
		"start" => :E,
		"finish" => :F,
	}

	SNAKES = {
		[0, 1] => [2, 0],
		[0, 5] => [2, 5],
		[0, 8] => [1, 7],
		[1, 8] => [3, 7],
		[2, 6] => [4, 7],
		[3, 1] => [8, 1],
		[3, 3] => [4, 0],
		[5, 5] => [7, 4],
		[5, 8] => [8, 9],
		[8, 4] => [9, 5]
	}

	LADDERS = {
		[9, 1] => [6, 2],
		[9, 6] => [8, 6],
		[9, 7] => [6, 9],
		[8, 5] => [7, 5],
		[7, 0] => [5, 1],
		[7, 7] => [1, 3],
		[6, 4] => [5, 3],
		[4, 9] => [3, 6],
		[2, 2] => [0, 2],
		[2, 9] => [0, 9],
		[1, 6] => [0, 6]
	}

	def default_grid
		d_grid = Array.new(10) { Array.new(10) }
		d_grid.each_with_index do |row, idx|
			row.each_with_index do |el, idx2|
				if idx == 0
					if idx2 == 1 || idx2 == 5 || idx2 == 8
						row[idx2] = :S
					end
				elsif idx == 1
					if idx2 == 8
						row[idx2] = :S
					elsif idx2 == 6
						row[idx2] = :L
					end
				elsif idx == 2
					if idx2 == 6
						row[idx2] = :S
					elsif idx2 == 2 || idx2 == 9
						row[idx2] = :L
					end
				elsif idx == 3
					if idx2 == 1 || idx2 == 3
						row[idx2] = :S
					end
				elsif idx == 4
					if idx2 == 9
						row[idx2] = :L
					end
				elsif idx == 5
					if idx2 == 5 || idx2 == 8
						row[idx2] = :S
					end
				elsif idx == 6
					if idx2 == 4
						row[idx2] = :L
					end
				elsif idx == 7
					if idx2 == 0 || idx2 == 7
						row[idx2] = :L
					end
				elsif idx == 8
					if idx2 == 4
						row[idx2] = :S
					elsif idx2 == 5
						row[idx2] = :L
					end
				elsif idx == 9
					if idx2 == 0
						row[idx2] = :b
					elsif idx2 == 1 || idx2 == 6 || idx2 == 7
						row[idx2] = :L
					end
				end
			end
		end
	end

	attr_accessor :grid

	def initialize(grid = self.default_grid)
		@grid = grid
	end

	def snake(pos)
		if SNAKES.include?(pos)
			return SNAKES[pos]
		end
	end

	def ladder(pos)
		if LADDERS.include?(pos)
			return LADDERS[pos]
		end
	end

	def display
		puts "             ========================================="
		@grid.each_with_index do |row, idx|
			puts display_row(row, idx)
			if idx == @grid.length - 1
				puts "             ========================================="
			else
				puts "             -----------------------------------------"
			end
		end
	end

	def display_row(row, idx)
		start_row = "START   ---> |"
		end_row = "FINISH  <--- |"
		even_row = "        <--- |"
		odd_row = "        ---> |"

		if idx == 0
			row.each do |el|
				el.nil? ? end_row << "   |" : end_row << " #{el} |"
			end
		elsif idx == @grid.length - 1
			row.each do |el|
				el.nil? ? start_row << "   |" : start_row << " #{el} |"
			end
		elsif idx.even?
			row.each do |el|
				el.nil? ? even_row << "   |" : even_row << " #{el} |"
			end
		elsif idx.odd?
			row.each do |el|
				el.nil? ? odd_row << "   |" : odd_row << " #{el} |"
			end
		end

		if idx == 0
			print end_row
		elsif idx == @grid.length - 1
			print start_row
		elsif idx.even?
			print even_row
		elsif idx.odd?
			print odd_row
		end
	end
end
