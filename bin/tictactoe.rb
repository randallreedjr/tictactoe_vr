class TicTacToe
       
    #Read access to some class variables
    attr_reader :winner
    attr_reader :movenum
    attr_reader :player1
    attr_reader :player2
    attr_reader :cat
		attr_reader :currentturn
		attr_reader :difficulty
    
    def initialize
        #Set starting values for class variables
        #@board = ['_','_','_','_','_','_','_','_','_']
        @board = Array.new(9,'_')
        #Keep track of current player
        @currentturn = :x
        @winner = ''
        @movenum = 0
        @lastmoveindex = -1
        @penultimatemoveindex = -1
        @difficulty = :easy
        @movesuccess = false
        @alternate = true
    end
    
    def reset
        #Reset game specific variables
        @board = Array.new(9,'_')
        @currentturn = :x
        @winner = ''
        @movenum = 0
        @lastmoveindex = -1
        @playagain = true
    end
    
    def print_instructions       
        if player1.mark == :x 
            return player1.name + ' (X) goes first'
        else
            return player2.name + ' (X) goes first'
        end
    end

    def select_players(numplayers)
        if @movenum == 0 or @winner != '' then
            if numplayers == 1
                @player1 = Player.new('human','Player',:x)
                @player2 = Player.new('computer','Computer',:o)
                @cat = Player.new('cat', 'Cat', :c)
            elsif numplayers == 2
                @player1 = Player.new('human', 'Player 1',:x)
                @player2 = Player.new('human', 'Player 2',:o)
                @cat = Player.new('cat', 'Cat', :c)
            else
                raise 'Invalid number of players: ' + numplayers
            end
        else
            raise "Cannot change players during game"
        end
    end
    
    def swap_players
        @player1.swap_mark()
        @player2.swap_mark()
    end 
    
    def update_score(winner)
        #Add a point to the winning player's score
        if @player1.mark == winner
            @player1.add_score()
        elsif @player2.mark == winner
            @player2.add_score()
        else
            @cat.add_score()
        end
    end
    
    def clear_score
        @player1.clear_score
        @player2.clear_score
        @cat.clear_score
    end
  
		def set_difficulty(difficulty)
			if @movenum == 0 or @winner != ''
				case difficulty
				when :easy, :normal, :hard
					@difficulty = difficulty
				else
					raise 'Only valid difficulties are easy, medium, and hard'
				end
			end
		end
       
    #Print outcome of game to players
    def print_winner
        if @winner == :c
            return "Sorry, cat game."
        else
            if @player1.mark == @winner
                return "Congratulations! " + @player1.name + " wins!"
            elsif @player2.mark == @winner and @player2.type == 'human'
                return "Congratulations! " + @player2.name + " wins!"
            elsif @player2.mark == @winner and @player2.type == 'computer'
                #1 player, 'O' won. Do not congratulate player on computer victory.
                return "Sorry, " + player2.name + " wins."
            end
        end
    end
   
		def swap_turn()
				#Toggle current player
				if @currentturn == :x
				    @currentturn = :o
				else
				    @currentturn = :x
				end
		end

		def space_available(move)
				if @winner == ''
						return @board[move-1] == '_'
				else
						return false
				end
		end
    
    def make_move(move)
        #store up to 2 moves for undo
        @penultimatemoveindex = @lastmoveindex
        @lastmoveindex = move-1
        #Array index is one less than move space
        if @board[@lastmoveindex] == '_'
            @board[@lastmoveindex] = @currentturn

            #Increment move counter
            @movenum += 1
            @movesuccess = true
        else
            #Do not allow player to choose space that has already been played
            @movesuccess = false
        end
    end

		def computer_move()
			if @player2.type == 'computer' and @player2.mark == :o
				return computer_move_o()
			elsif @player2.type == 'computer' and @player2.mark == :x
				return computer_move_x()
			end
		end

		def get_last_move()
			return @lastmoveindex
		end

		def get_penultimate_move()
			return @penultimatemoveindex
		end
    
    def undo_move()
        if @lastmoveindex == -1
            return "Move cannot be undone"
        else
            if @player2.type=='computer'
								if @player2.mark == :o or (@player2.mark == :x and @movenum > 1)
									#Undo computer and player move
									#Clear 2 moves from board
									@board[@lastmoveindex] = '_'
									@board[@penultimatemoveindex] = '_'
									@lastmoveindex = -1
									@penultimatemoveindex = -1
									@movenum -= 2
								else
									return "Move cannot be undone"
								end
            else
                #Undo player move only
                #Clear move
                @board[@lastmoveindex] = '_'
                @lastmoveindex = -1
                #Decrement move counter
                @movenum -= 1
                
                #Toggle current player
                if @currentturn == :x
                    @currentturn = :o
                else
                    @currentturn = :x
                end
            end
            return "Move undone"
        end
    end

 		def show_computer_move(move)
        #Need to increment index to match normal layout
        if @keyboard
            movestring = @keyboardboard[move]
        elsif @numpad
            movestring = @numpadboard[move]
        else
            movestring = (move+1).to_s
        end
        return "Computer chooses " + movestring
    end
    
    def check_winner(lastmove)
				lastmoveindex = lastmove - 1
        if @movenum < 3
            #Game cannot end in less than 5 moves
            #However, computer uses this to check for blocks on move 4
            return ''
        else
            row = lastmoveindex / 3
            #Determine row to check using integer division
            if (row == 0 and check_win_top_row()) or (row == 1 and check_win_center_row()) or (row == 2 and check_win_bottom_row())
								@winner = @currentturn
						end
            
            column = lastmoveindex % 3
            #Determine column to check
            if (column == 0 and check_win_left_column()) or (column == 1 and check_win_middle_column()) or (column == 2 and check_win_right_column())
								@winner = @currentturn
						end
            
            if lastmoveindex % 2 == 0
                #Determine diagonals to check
                if lastmoveindex % 4 == 2
                    if check_win_bottom_left_to_top_right() then @winner = @currentturn end
                elsif lastmoveindex != 4 and lastmoveindex %4 == 0
                    if check_win_top_left_to_bottom_right() then @winner = @currentturn end
                elsif lastmoveindex == 4
                    if check_win_top_left_to_bottom_right() or check_win_bottom_left_to_top_right()
											@winner = @currentturn   
										end
                end
            end
        end

        if @movenum == 9 and @winner == ''
            #Game over, no winner; cat's game
						@winner = :c
        end

				return @winner
    end


private

		def computer_move_x()

			if @difficulty == :easy
        #Easy computer moves randomly
        move = random_move()
			elsif @difficulty == :normal
				#Normal computer moves randomly early on, but looks for wins or blocks as the game progresses
				if @movenum < 3
				    move = random_move()
				else
				    #Check for winning move first
				    move = find_winning_move()
				    if move == -1
					 		#No winning move available, try block next
							move = find_blocking_move()
							if move == -1
					    	move = random_move()
							end
				    end
				end
			elsif @difficulty == :hard
				#Hard computer knows what move to make in every situation, until cat game is guaranteed
				case movenum 
				when 0
					move = 0
				when 2
					case @lastmoveindex
					when 1,3,5,7
						move = 4
					when 2,4,6
						move = 8
					else
						move = 2
					end
				when 4
					move = find_winning_move()
					if move == -1
						move = find_blocking_move()
						if move == -1
							move = 6
						end
					end
				else
					move = find_winning_move()
					if move == -1
						move = find_blocking_move()
						if move == -1
							move = random_move()
						end
					end
				end
			end
			return move + 1
		end
   
    def computer_move_o()
        if @winner == ''
            if @difficulty == :easy
                #Easy computer moves randomly
                move = random_move()
            elsif @difficulty == :normal
                #Normal computer moves randomly early on, but looks for wins or blocks as the game progresses
                if @movenum < 3
                    move = random_move()
                else
                    #Check for winning move first
                    move = find_winning_move()
                    if move == -1
                         #No winning move available, try block next
                        move = find_blocking_move()
                        if move == -1 then
                            move = random_move()
                        end
                    end
                end
            elsif @difficulty == :hard
                #Hard computer knows what move to make in every situation, until cat game is guaranteed
                move = -1
                if @movenum == 1
                    if @board[4] == '_'
                        move = 4
                    else
                        move = 0
                    end
                elsif @movenum == 3
                    if @board[4] == :x
                        if @board[0] != '_' and @board[8] != '_'
                            move = 2
                        elsif @board[2] != '_' and @board[6] != '_'
                            move = 0
                        end
                    else
                        if (@board[1] == :x and @board[5] == :x) or (@board[3] == :x and @board[7] == :x)
                            move = 0
                        elsif (@board[3] == :x and @board[8] == :x) or (@board[5] == :x and @board[6] == :x) or (@board[3] == :x and @board[5] == :x) or (@board[0] == :x and @board[8] == :x) or (@board[2] == :x and @board[6] == :x)
                            move = 1
                        elsif (@board[1] == :x and @board[3] == :x) or (@board[5] == :x and @board[7] == :x)
                            move = 2
                        elsif (@board[2] == :x and @board[7] == :x) or (@board[1] == :x and @board[8] == :x) or (@board[1] == :x and @board[7] == :x)
                            move = 3
                        elsif (@board[1] == :x and @board[6] == :x) or (@board[0] == :x and @board[7] == :x)
                            move = 5
                        elsif (@board[0] == :x and @board[5] == :x) or (@board[2] == :x and @board[3] == :x)
                            move = 7
                        end
                    end
                elsif @movenum == 5
                    if (@board[4] == :o and @board[5] == :x and @board[7] == :x and @board[1] != '_' and @board[3] != '_')
                        move = 0
                    end
                end
                if move == -1
                    #Check for winning move first
                    move = find_winning_move()
                    if move == -1
                         #No winning move available, try block next
                        move = find_blocking_move()
                        if move == -1 then
                            #puts "Select side"
                            if @board[1] == '_'
                                move = 1
                            elsif @board[3] == '_'
                                move = 3
                            elsif @board[5] == '_'
                                move = 5
                            elsif @board[7] == '_'
                                move = 7
                            end
                        end
                    end
                end
                

            end
						return (move+1)
        end
    end
    
    def find_winning_move()
        #Pretend O went in any available square and check for win
        for i in 0..8
            if @board[i] == '_'
                @board[i] = @player2.mark
                if check_winner(i+1) == @player2.mark
                    @board[i] = '_'
										@winner = ''
                    return i
                end
                @board[i] = '_'
            end
        end
        return -1
    end
    
    def find_blocking_move()
        #Pretend X went in any available square and check for win; that space necessitates a block
        for i in 0..8
            if @board[i] == '_'
                @board[i] = @player1.mark
                #CheckWinner returns currentturn, so it will still be player2
                if check_winner(i+1) == @player2.mark
                    @board[i] = '_'
										@winner = ''
                    return i
                end
                @board[i] = '_'
            end
        end
        return -1
    end
    
    def random_move()
        #Select random number 0-8 inclusive; this will match board index
        move = rand(9)
        while @board[move] != '_'
            move = rand(9)
        end
        return move
    end
       
    def check_win_left_column()
		#[0 _ _]
		#[3 _ _]
		#[6 _ _]
        return ((@board[0] == @board[3]) and (@board[0] == @board[6]))
    end
    
    def check_win_middle_column()
		#[_ 1 _]
		#[_ 4 _]
		#[_ 7 _]
        return ((@board[4] == @board[1]) and (@board[4] == @board[7]))
    end
    
    def check_win_right_column()
		#[_ _ 2]
		#[_ _ 5]
		#[_ _ 8]
        return ((@board[8] == @board[2]) and (@board[8] == @board[5]))
    end
    
    def check_win_top_row()
		#[0 1 2]
		#[_ _ _]
		#[_ _ _]
        return ((@board[0] == @board[1]) and (@board[0] == @board[2]))
    end
    
    def check_win_center_row()
		#[_ _ _]
		#[3 4 5]
		#[_ _ _]
        return ((@board[4] == @board[3]) and (@board[4] == @board[5]))
    end
    
    def check_win_bottom_row()
		#[_ _ _]
		#[_ _ _]
		#[6 7 8]
        return ((@board[8] == @board[7]) and (@board[8] == @board[6]))
    end
    
    def check_win_top_left_to_bottom_right()
		#[0 _ _]
		#[_ 4 _]
		#[_ _ 8]
        return ((@board[4] == @board[0]) and (@board[4] == @board[8]))
    end
    
    def check_win_bottom_left_to_top_right()
		#[_ _ 2]
		#[_ 4 _]
		#[6 _ _]
        return ((@board[4] == @board[2]) and (@board[4] == @board[6]))
    end
end
