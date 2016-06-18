class Board

	include GladeGUI

	def initialize()
		@path = File.dirname(__FILE__) + "/"
		@image1 = @path + "blank.jpg"
		@image2 = @path + "blank.jpg"
		@image3 = @path + "blank.jpg"
		@image4 = @path + "blank.jpg"
		@image5 = @path + "blank.jpg"
		@image6 = @path + "blank.jpg"
		@image7 = @path + "blank.jpg"
		@image8 = @path + "blank.jpg"
		@image9 = @path + "blank.jpg"
		@label1 = "Welcome to Tic Tac Toe"
		#array to store image names; this will make updating the board easier
		@images = { :x => "x.jpg", :o => "o.jpg" }
	end	
  
  # Called after init and before window1.show
  def before_show()
		new_match()
  end


	#Human opponent
	def radiobutton1__clicked(*argv)
		if @tictactoe.player2.type != 'human'
			if @tictactoe.movenum == 0 or @tictactoe.winner != ''
				@tictactoe.select_players(2)

				if @tictactoe.winner != '' then newgame() end

				#clear all difficulty selectors
				@builder["checkbutton1"].active = false
				@builder["checkbutton2"].active = false
				@builder["checkbutton3"].active = false

				#update player names and status
				@builder["label4"].text = @tictactoe.player1.name
				@builder["label3"].text = @tictactoe.player2.name
				@builder["label5"].text = 'Now playing human. ' + @tictactoe.print_instructions()

				#clear and update scores
				reset_score()
			else
				#toggle back
				@builder["radiobutton2"].active = true
				@builder["label5"].text = 'Cannot change opponent during game'
			end
		end
	end

	#Computer opponent
	def radiobutton2__clicked(*argv)
		if @tictactoe.player2.type != 'computer'
			if @tictactoe.movenum == 0 or @tictactoe.winner != ''
				@tictactoe.select_players(1)
				if @tictactoe.winner != '' then new_match() end

				#select easy difficulty by default
				@builder["checkbutton1"].active = true

				#update player names
				@builder["label4"].text = @tictactoe.player1.name
				@builder["label3"].text = @tictactoe.player2.name

				#clear and update scores
				reset_score()
			else
				#toggle back
				@builder["radiobutton1"].active = true
				@builder["label5"].text = 'Cannot change opponent during game'
			end
		end
	end

	#Easy difficulty
	def checkbutton1__clicked(*argv)
		if @builder["radiobutton2"].active? == false
			#Only allow player to select difficulty if opponent is computer
			@builder["checkbutton1"].active = false
		elsif @builder["checkbutton1"].active? == true and (@tictactoe.movenum == 0 or @tictactoe.winner != '')
			@builder["checkbutton2"].active = false
			@builder["checkbutton3"].active = false
			@tictactoe.set_difficulty(:easy)
			@builder["label5"].text = 'Now playing computer on easy. '+ @tictactoe.print_instructions()
		elsif not (@tictactoe.movenum == 0 or @tictactoe.winner != '')
			#toggle back
			@builder["checkbutton1"].active = (@tictactoe.difficulty == :easy)
			@builder["label5"].text = 'Cannot change difficulty during game'
		end
	end

	#Normal difficulty
	def checkbutton2__clicked(*argv)
		if @builder["radiobutton2"].active? == false
			#Only allow player to select difficulty if opponent is computer
			@builder["checkbutton2"].active = false
		elsif @builder["checkbutton2"].active? == true and (@tictactoe.movenum == 0 or @tictactoe.winner != '')
			@builder["checkbutton1"].active = false
			@builder["checkbutton3"].active = false
			@tictactoe.set_difficulty(:normal)
			@builder["label5"].text = 'Now playing computer on normal. '+ @tictactoe.print_instructions()
		elsif not (@tictactoe.movenum == 0 or @tictactoe.winner != '')
			#toggle back
			@builder["checkbutton2"].active = (@tictactoe.difficulty == :normal)
			@builder["label5"].text = 'Cannot change difficulty during game'
		end
	end

	#Hard difficulty
	def checkbutton3__clicked(*argv)
		if @builder["radiobutton2"].active? == false
			#Only allow player to select difficulty if opponent is computer
			@builder["checkbutton3"].active = false
		elsif @builder["checkbutton3"].active? == true and (@tictactoe.movenum == 0 or @tictactoe.winner != '')
			@builder["checkbutton1"].active = false
			@builder["checkbutton2"].active = false
			@tictactoe.set_difficulty(:hard)
			@builder["label5"].text = 'Now playing computer on hard. '+ @tictactoe.print_instructions()
		elsif not (@tictactoe.movenum == 0 or @tictactoe.winner != '')
			#toggle back
			@builder["checkbutton3"].active = (@tictactoe.difficulty == :hard)
			@builder["label5"].text = 'Cannot change difficulty during game'
		end
	end

	#Menu options
	def imagemenuitem1__activate(*argv)
		#Game -> New
		new_game()
	end

	def imagemenuitem2__activate(*argv)
		#Game -> Reset score
		reset_score()
	end

	def imagemenuitem5__activate(*argv)
		#Game -> Exit
		@builder[:window1].destroy
	end

	def imagemenuitem6__activate(*argv)
		#Edit -> Undo
		if @tictactoe.winner == ''
			#Cannot undo winning move
			lastmoveindex = @tictactoe.get_last_move()
			penultimatemoveindex = @tictactoe.get_penultimate_move()
			status = @tictactoe.undo_move()
			@builder["label5"].text = status
			if status == 'Move undone'
				@builder["image" + (lastmoveindex+1).to_s].file = @path + "blank.jpg"
				if @tictactoe.player2.type == 'computer'
					@builder["image" + (penultimatemoveindex+1).to_s].file = @path + "blank.jpg"
				end
			end
		else
			@builder["label5"].text = 'Cannot undo winning move'
		end
	end

	def imagemenuitem10__activate(*argv)
		#Help -> About
		modal_win = ModalWindow.new.show_glade(self) 
	end
	
	#Move buttons 1 - 9
	def button1__clicked(*argv)
		if make_move(1) and @tictactoe.player2.type == 'computer' then
			computer_move()
		end
	end

	def button2__clicked(*argv)
		if make_move(2) and @tictactoe.player2.type == 'computer' then
			computer_move()
		end
	end

	def button3__clicked(*argv)
		if make_move(3) and @tictactoe.player2.type == 'computer' then
			computer_move()
		end
	end

	def button4__clicked(*argv)
		if make_move(4) and @tictactoe.player2.type == 'computer' then
			computer_move()
		end
	end

	def button5__clicked(*argv)
		if make_move(5) and @tictactoe.player2.type == 'computer' then
			computer_move()
		end
	end

	def button6__clicked(*argv)
		if make_move(6) and @tictactoe.player2.type == 'computer' then
			computer_move()
		end
	end

	def button7__clicked(*argv)
		if make_move(7) and @tictactoe.player2.type == 'computer' then
			computer_move()
		end
	end

	def button8__clicked(*argv)
		if make_move(8) and @tictactoe.player2.type == 'computer' then
			computer_move()
		end
	end

	def button9__clicked(*argv)
		if make_move(9) and @tictactoe.player2.type == 'computer' then
			computer_move()
		end
	end


private

	def new_match()
		@tictactoe = TicTacToe.new()
		@tictactoe.select_players(2)
		@builder["label4"].text = @tictactoe.player1.name
		@builder["label8"].text = @tictactoe.player1.score.to_s

		@builder["label3"].text = @tictactoe.player2.name
		@builder["label7"].text = @tictactoe.player2.score.to_s

		@builder["label2"].text = @tictactoe.cat.name
		@builder["label6"].text = @tictactoe.cat.score.to_s

		@builder["label5"].text = 'New game - ' + @tictactoe.print_instructions()
	end

	def new_game()
		@tictactoe.reset()
		@builder["label5"].text = 'New game - ' + @tictactoe.print_instructions()
		@builder["image1"].file = @path + "blank.jpg"
		@builder["image2"].file = @path + "blank.jpg"
		@builder["image3"].file = @path + "blank.jpg"
		@builder["image4"].file = @path + "blank.jpg"
		@builder["image5"].file = @path + "blank.jpg"
		@builder["image6"].file = @path + "blank.jpg"
		@builder["image7"].file = @path + "blank.jpg"
		@builder["image8"].file = @path + "blank.jpg"
		@builder["image9"].file = @path + "blank.jpg"
		if @tictactoe.player2.type == 'computer' and @tictactoe.player2.mark == :x then computer_move() end
	end

	def reset_score()
		@tictactoe.clear_score()
		@builder["label8"].text = @tictactoe.player1.score.to_s
		@builder["label7"].text = @tictactoe.player2.score.to_s
		@builder["label6"].text = @tictactoe.cat.score.to_s
	end

	def make_move(space)
		if @tictactoe.space_available(space)
			@builder["image"+space.to_s].file = @path + @images[@tictactoe.currentturn]
			@tictactoe.make_move(space)
			winner = @tictactoe.check_winner(space)
			if winner == ''
					@tictactoe.swap_turn()
			else
					game_over(winner)
			end
			return true
		else
			return false
		end
	end

	def computer_move()
		if @tictactoe.winner == ''
			space = @tictactoe.computer_move()
			@builder["label5"].text = 'Computer chooses ' + space.to_s
			make_move(space)
		end
	end

	def game_over(winner)
		@tictactoe.update_score(winner)

		@builder["label5"].text = @tictactoe.print_winner()
		@builder["label8"].text = @tictactoe.player1.score.to_s
		@builder["label7"].text = @tictactoe.player2.score.to_s
		@builder["label6"].text = @tictactoe.cat.score.to_s
		#After each game, alternate who goes first
		@tictactoe.swap_players()

	end


end

