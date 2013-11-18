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
		#array to store image names; this will make updating the board easier
		@images = { 'X' => "x.jpg", 'O' => "o.jpg" , 'OX' => "ox.jpg", 'XO' => "xo.jpg" }
		set_glade_all() #populates glade controls with insance variables (i.e. Myclass.label1) 

		newmatch()
		show_window() 
	end	

	#Human opponent
	def radiobutton1__clicked(*argv)

		if @randallmode
			@builder["radiobutton2"].active = true
			@builder["label5"].text = "Sorry, I can't allow that"

		elsif @tictactoe.player2.type != 'human'
			if @tictactoe.movenum == 0 or @tictactoe.winner != ''
				@tictactoe.SelectPlayers(2)

				if @tictactoe.winner != '' then newgame() end

				#clear all difficulty selectors
				@builder["checkbutton1"].active = false
				@builder["checkbutton2"].active = false
				@builder["checkbutton3"].active = false

				#update player names and status
				@builder["label4"].text = @tictactoe.player1.name
				@builder["label3"].text = @tictactoe.player2.name
				@builder["label5"].text = 'Now playing human. ' + @tictactoe.PrintInstructions()

				#clear and update scores
				ResetScore()
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
				@tictactoe.SelectPlayers(1)
				if @tictactoe.winner != '' then newgame() end

				#select easy difficulty by default
				@builder["checkbutton1"].active = true

				#update player names
				@builder["label4"].text = @tictactoe.player1.name
				@builder["label3"].text = @tictactoe.player2.name

				#clear and update scores
				ResetScore()
			else
				#toggle back
				@builder["radiobutton1"].active = true
				@builder["label5"].text = 'Cannot change opponent during game'
			end
		end
	end

	#Easy difficulty
	def checkbutton1__clicked(*argv)
		if @randallmode
			@builder["checkbutton1"].active = false
			@builder["label5"].text = "Randall only has 1 setting - win."
		elsif @builder["radiobutton2"].active? == false
			#Only allow player to select difficulty if opponent is computer
			@builder["checkbutton1"].active = false
		elsif @builder["checkbutton1"].active? == true and (@tictactoe.movenum == 0 or @tictactoe.winner != '')
			@builder["checkbutton2"].active = false
			@builder["checkbutton3"].active = false
			@tictactoe.SetDifficulty('easy')
			@builder["label5"].text = 'Now playing computer on easy. '+ @tictactoe.PrintInstructions()
		elsif not (@tictactoe.movenum == 0 or @tictactoe.winner != '')
			#toggle back
			@builder["checkbutton1"].active = (@tictactoe.difficulty == 'easy')
			@builder["label5"].text = 'Cannot change difficulty during game'
		end
	end

	#Normal difficulty
	def checkbutton2__clicked(*argv)
		if @randallmode
			@builder["checkbutton2"].active = false
			@builder["label5"].text = "Randall only has 1 setting - win."
		elsif @builder["radiobutton2"].active? == false
			#Only allow player to select difficulty if opponent is computer
			@builder["checkbutton2"].active = false
		elsif @builder["checkbutton2"].active? == true and (@tictactoe.movenum == 0 or @tictactoe.winner != '')
			@builder["checkbutton1"].active = false
			@builder["checkbutton3"].active = false
			@tictactoe.SetDifficulty('normal')
			@builder["label5"].text = 'Now playing computer on normal. '+ @tictactoe.PrintInstructions()
		elsif not (@tictactoe.movenum == 0 or @tictactoe.winner != '')
			#toggle back
			@builder["checkbutton2"].active = (@tictactoe.difficulty == 'normal')
			@builder["label5"].text = 'Cannot change difficulty during game'
		end
	end

	#Hard difficulty
	def checkbutton3__clicked(*argv)
		if @randallmode
			@builder["checkbutton3"].active = true
			@builder["label5"].text = "Nice try"
		elsif @builder["radiobutton2"].active? == false
			#Only allow player to select difficulty if opponent is computer
			@builder["checkbutton3"].active = false
		elsif @builder["checkbutton3"].active? == true and (@tictactoe.movenum == 0 or @tictactoe.winner != '')
			@builder["checkbutton1"].active = false
			@builder["checkbutton2"].active = false
			@tictactoe.SetDifficulty('hard')
			@builder["label5"].text = 'Now playing computer on hard. '+ @tictactoe.PrintInstructions()
		elsif not (@tictactoe.movenum == 0 or @tictactoe.winner != '')
			#toggle back
			@builder["checkbutton3"].active = (@tictactoe.difficulty == 'hard')
			@builder["label5"].text = 'Cannot change difficulty during game'
		end
	end

	#Menu options
	def imagemenuitem1__activate(*argv)
		#Game -> New
		newgame()
	end

	def imagemenuitem2__activate(*argv)
		#Game -> Reset score
		ResetScore()
	end

	def imagemenuitem5__activate(*argv)
		#Game -> Exit
		destroy_window()
	end

	def imagemenuitem6__activate(*argv)
		#Edit -> Undo
		if @tictactoe.winner == ''
			#Cannot undo winning move
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

	def imagemenuitem10__activate(*argv)
		#Help -> About
		modal_win = ModalWindow.new 
		modal_win.show(self)
	end
	
	#Move buttons 1 - 9
	def button1__clicked(*argv)
		checkrandallmode(1)
		if makemove(1) and @tictactoe.player2.type == 'computer' then
			computermove()
		end
	end

	def button2__clicked(*argv)
		checkrandallmode(2)
		if makemove(2) and @tictactoe.player2.type == 'computer' then
			computermove()
		end
	end

	def button3__clicked(*argv)
		checkrandallmode(3)
		if makemove(3) and @tictactoe.player2.type == 'computer' then
			computermove()
		end
	end

	def button4__clicked(*argv)
		checkrandallmode(4)
		if makemove(4) and @tictactoe.player2.type == 'computer' then
			computermove()
		end
	end

	def button5__clicked(*argv)
		if not checkrandallmode(5)
			if makemove(5) and @tictactoe.player2.type == 'computer' then
				computermove()
			end
		end
	end

	def button6__clicked(*argv)
		checkrandallmode(6)
		if makemove(6) and @tictactoe.player2.type == 'computer' then
			computermove()
		end
	end

	def button7__clicked(*argv)
		checkrandallmode(7)
		if makemove(7) and @tictactoe.player2.type == 'computer' then
			computermove()
		end
	end

	def button8__clicked(*argv)
		checkrandallmode(8)
		if makemove(8) and @tictactoe.player2.type == 'computer' then
			computermove()
		end
	end

	def button9__clicked(*argv)
		checkrandallmode(9)
		if makemove(9) and @tictactoe.player2.type == 'computer' then
			computermove()
		end
	end


private

	def newmatch()

		@buttons = ''
		@randallmode = false

		@tictactoe = TicTacToe.new()
		@tictactoe.SelectPlayers(2)
		@builder["label4"].text = @tictactoe.player1.name
		@builder["label8"].text = @tictactoe.player1.score.to_s

		@builder["label3"].text = @tictactoe.player2.name
		@builder["label7"].text = @tictactoe.player2.score.to_s

		@builder["label2"].text = @tictactoe.cat.name
		@builder["label6"].text = @tictactoe.cat.score.to_s

		@builder["label5"].text = 'New game - ' + @tictactoe.PrintInstructions()
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
		if @tictactoe.player2.type == 'computer' and @tictactoe.player2.mark == 'X' then computermove() end
	end

	def ResetScore()
		if not @randallmode
			@tictactoe.ClearScore(false)
		else
			@tictactoe.ClearScore(true)
			if @tictactoe.player2.score < 32
				@builder["label5"].text = "I will keep my points, thank you."
			elsif @tictactoe.player2.score >= 32 and @tictactoe.player2.score < 1000
				@builder["label5"].text = "Wow, I'm really on a streak here."
			elsif @tictactoe.player2.score > 1000 and @tictactoe.player2.score < 1000000
				@builder["label5"].text = "Um...what are you doing?"
			elsif @tictactoe.player2.score > 100000 and @tictactoe.player2.score < 1000000000
				@builder["label5"].text = "You should probably slow down. For your own sake."
			elsif @tictactoe.player2.score > 1000000000 and @tictactoe.player2.score < 2000000000
				@builder["label5"].text = "Oh no! Not integer overflow! Ahhh!"
			elsif @tictactoe.player2.score > 2000000000 and @tictactoe.player2.score < 8000000000
				@builder["label5"].text = "Haha, just kidding. Apparently you've never heard of BigNum. \nNow can we play another game?"
			elsif @tictactoe.player2.score > 8000000000 and @tictactoe.player2.score < 16000000000
				@builder["label5"].text = "Ok, that's enough. I'm bored playing with you."
			elsif @tictactoe.player2score > 16000000000
				@randallmode = false
				newmatch()
			end
		end
		@builder["label8"].text = @tictactoe.player1.score.to_s
		@builder["label7"].text = @tictactoe.player2.score.to_s
		@builder["label6"].text = @tictactoe.cat.score.to_s
		
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
			return false
		end
	end

	def computermove()
		if @tictactoe.winner == ''
			space = @tictactoe.ComputerMove()
			@builder["label5"].text = @tictactoe.player2.name + ' chooses ' + space.to_s
			makemove(space)
		end
	end

	def gameover(winner)
		@tictactoe.UpdateScore(winner)

		@builder["label5"].text = @tictactoe.PrintWinner()
		@builder["label8"].text = @tictactoe.player1.score.to_s
		@builder["label7"].text = @tictactoe.player2.score.to_s
		@builder["label6"].text = @tictactoe.cat.score.to_s

		#After each game, alternate who goes first
		@tictactoe.SwapPlayers()
	end

	def checkrandallmode(button)
		if not @randallmode
			case button
			when 1
				if @buttons == '425'
					@buttons += '1'
				else
					@buttons = ''
				end
			when 2
				if @buttons == '4' 
					@buttons += '2'
				else 
					@buttons = ''
				end
			when 4
				if @buttons == '' 
					@buttons += '4' 
				else
					@buttons = ''
				end
			when 5
				if @buttons == '42' 
					@buttons += '5' 
				elsif @buttons == '425198'
					@buttons += '5'
					randallmode()
					return true
				end	
			when 8
				if @buttons == '42519'
					@buttons += '8'
				else
					@buttons = ''
				end
			when 9
				if @buttons == '4251' 
					@buttons += '9' 
				else
					@buttons = ''				
				end
			else
				@buttons = ''
			end
		end
		return false
	end

	def randallmode()
		@randallmode = true
		if @tictactoe.player2.mark == 'X' then @tictactoe.SwapPlayers() end
		newgame()

		@builder["radiobutton2"].label = 'Randall'
		@builder["radiobutton2"].active = true

		@builder["checkbutton1"].active = false
		@builder["checkbutton2"].active = false
		@builder["checkbutton3"].active = true
		@builder["checkbutton3"].label = 'Impossible'
		@tictactoe.SetDifficulty('hard')

		@builder["label5"].text = "Now playing Randall. Note: Randall does not like to lose."
		@tictactoe.player2.name = 'Randall'
		@builder["label3"].text = @tictactoe.player2.name
	end


end

