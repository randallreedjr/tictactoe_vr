

class Board

	include GladeGUI


	def show()
		@path = File.dirname(__FILE__) + "/"

		load_glade(__FILE__)  #loads file, glade/MyClass.glade into @builder
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
	@images = { 'X' => "x.jpg", 'O' => "o.jpg" }
		set_glade_all() #populates glade controls with insance variables (i.e. Myclass.label1) 

		newmatch()
		show_window() 
	end	

	def newmatch()
		@tictactoe = TicTacToe.new()
		@tictactoe.SelectPlayers(2)
		@builder["label2"].text = @tictactoe.player1.name
		@builder["label6"].text = @tictactoe.player1.score.to_s

		@builder["label3"].text = @tictactoe.player2.name
		@builder["label7"].text = @tictactoe.player2.score.to_s

		@builder["label4"].text = @tictactoe.cat.name
		@builder["label8"].text = @tictactoe.cat.score.to_s

		@builder["label5"].text = 'New game - ' + @tictactoe.PrintInstructions()
	end

	def radiobutton1__clicked(*argv)
		#human opponent
		if @tictactoe.player2.type != 'human'
			if @tictactoe.movenum == 0 or @tictactoe.winner != ''
				@tictactoe.SelectPlayers(2)
				if @tictactoe.winner != '' then newgame() end
				@builder["checkbutton1"].active = false
				@builder["checkbutton2"].active = false
				@builder["checkbutton3"].active = false
				@builder["label5"].text = 'Now playing human'
			else
				#toggle back
				@builder["radiobutton2"].active = true
				@builder["label5"].text = 'Cannot change opponent during game'
			end
		end
	end

	def radiobutton2__clicked(*argv)
		#computer opponent
		if @tictactoe.player2.type != 'computer'
			if @tictactoe.movenum == 0 or @tictactoe.winner != ''
				@tictactoe.SelectPlayers(1)
				if @tictactoe.winner != '' then newgame() end
				#select easy difficulty by default
				@builder["checkbutton1"].active = true
			else
				#toggle back
				@builder["radiobutton1"].active = true
				@builder["label5"].text = 'Cannot change opponent during game'
			end
		end
	end

	#Only allow player to select difficulty if opponent is computer
	def checkbutton1__clicked(*argv)
		if @builder["radiobutton2"].active? == false
			@builder["checkbutton1"].active = false
		elsif @builder["checkbutton1"].active? == true and (@tictactoe.movenum == 0 or @tictactoe.winner != '')
			@builder["checkbutton2"].active = false
			@builder["checkbutton3"].active = false
			@tictactoe.SetDifficulty('easy')
			@builder["label5"].text = 'Now playing computer on easy'
		elsif not (@tictactoe.movenum == 0 or @tictactoe.winner != '')
			#toggle back
			@builder["checkbutton1"].active = (@tictactoe.difficulty == 'easy')
			@builder["label5"].text = 'Cannot change difficulty during game'
		end
	end

	def checkbutton2__clicked(*argv)
		if @builder["radiobutton2"].active? == false
			@builder["checkbutton2"].active = false
		elsif @builder["checkbutton2"].active? == true and (@tictactoe.movenum == 0 or @tictactoe.winner != '')
			@builder["checkbutton1"].active = false
			@builder["checkbutton3"].active = false
			@tictactoe.SetDifficulty('normal')
			@builder["label5"].text = 'Now playing computer on normal'
		elsif not (@tictactoe.movenum == 0 or @tictactoe.winner != '')
			#toggle back
			@builder["checkbutton2"].active = (@tictactoe.difficulty == 'normal')
			@builder["label5"].text = 'Cannot change difficulty during game'
		end
	end

	def checkbutton3__clicked(*argv)
		if @builder["radiobutton2"].active? == false
			@builder["checkbutton3"].active = false
		elsif @builder["checkbutton3"].active? == true and (@tictactoe.movenum == 0 or @tictactoe.winner != '')
			@builder["checkbutton1"].active = false
			@builder["checkbutton2"].active = false
			@tictactoe.SetDifficulty('hard')
			@builder["label5"].text = 'Now playing computer on hard'
		elsif not (@tictactoe.movenum == 0 or @tictactoe.winner != '')
			#toggle back
			@builder["checkbutton3"].active = (@tictactoe.difficulty == 'hard')
			@builder["label5"].text = 'Cannot change difficulty during game'
		end
	end

	def imagemenuitem1__activate(*argv)
		newgame()
	end

	def newgame()
		@tictactoe.Reset()
		@builder["label5"].text = 'New game - ' + @tictactoe.PrintInstructions()
		@builder["image1"].file = @path + "blank.jpg"
		@builder["image2"].file = @path + "blank.jpg"
		@builder["image3"].file = @path + "blank.jpg"
		@builder["image4"].file = @path + "blank.jpg"
		@builder["image5"].file = @path + "blank.jpg"
		@builder["image6"].file = @path + "blank.jpg"
		@builder["image7"].file = @path + "blank.jpg"
		@builder["image8"].file = @path + "blank.jpg"
		@builder["image9"].file = @path + "blank.jpg"
	end

	def imagemenuitem2__activate(*argv)
		@tictactoe.ClearScore()
		@builder["label6"].text = @tictactoe.player1.score.to_s
		@builder["label7"].text = @tictactoe.player2.score.to_s
		@builder["label8"].text = @tictactoe.cat.score.to_s
	end

	def imagemenuitem5__activate(*argv)
		destroy_window()
	end

	def imagemenuitem6__activate(*argv)
		#Cannot undo winning move
		if @tictactoe.winner == ''
			lastmoveindex = @tictactoe.GetLastMove()
			penultimatemoveindex = @tictactoe.GetPenultimateMove()
			status = @tictactoe.UndoMove()
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
	
	def button1__clicked(*argv)
		if makemove(1) and @tictactoe.player2.type == 'computer' then
			#computermove()
		end
	end

	def button2__clicked(*argv)
		if makemove(2) and @tictactoe.player2.type == 'computer' then
			#computermove()
		end
	end

	def button3__clicked(*argv)
		if makemove(3) and @tictactoe.player2.type == 'computer' then
			#computermove()
		end
	end

	def button4__clicked(*argv)
		if makemove(4) and @tictactoe.player2.type == 'computer' then
			#computermove()
		end
	end

	def button5__clicked(*argv)
		if makemove(5) and @tictactoe.player2.type == 'computer' then
			#computermove()
		end
	end

	def button6__clicked(*argv)
		if makemove(6) and @tictactoe.player2.type == 'computer' then
			#computermove()
		end
	end

	def button7__clicked(*argv)
		if makemove(7) and @tictactoe.player2.type == 'computer' then
			#computermove()
		end
	end

	def button8__clicked(*argv)
		if makemove(8) and @tictactoe.player2.type == 'computer' then
			#computermove()
		end
	end

	def button9__clicked(*argv)
		if makemove(9) and @tictactoe.player2.type == 'computer' then
			#computermove()
		end
	end

	def button10_clicked(*argv)
		computermove()
	end

	def makemove(space)
		if @tictactoe.SpaceAvailable(space)
			@builder["image"+space.to_s].file = @path + @images[@tictactoe.currentturn]
			@tictactoe.MakeMove(space)
			winner = @tictactoe.CheckWinner(space)
			if winner == ''
					@tictactoe.SwapTurn()
			else
					gameover(winner)
			end
			return true
		else
			@builder["label5"].text = space.to_s + ' not available: ' + @tictactoe.PrintBoard() + ' ' + @tictactoe.winner
			return false
		end
	end

	def computermove()
		space = @tictactoe.ComputerMove()
		@builder["label5"].text = 'Computer chooses ' + space.to_s
		makemove(space)
	end

	def gameover(winner)
		@tictactoe.UpdateScore(winner)

		@builder["label5"].text = @tictactoe.PrintWinner()
		@builder["label6"].text = @tictactoe.player1.score.to_s
		@builder["label7"].text = @tictactoe.player2.score.to_s
		@builder["label8"].text = @tictactoe.cat.score.to_s

		@tictactoe.SwapPlayers()
	end


end

