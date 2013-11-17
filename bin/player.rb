    class Player
        attr_reader :score
        attr_reader :type
        attr_reader :name
        attr_reader :mark
        def initialize(type, name, mark)
            @name = name
            @type = type
            @score = 0
            @mark = mark
        end
        
        def AddScore()
            @score += 1
        end
        
        def ClearScore()
            @score = 0
        end
        
        def SwapMark()
            if @mark == 'X' 
                @mark = 'O'
            else
                @mark = 'X'
            end
        end
        
        def Print()
            print name + ", type: " + type + ", score: " + score.to_s
        end
    end
