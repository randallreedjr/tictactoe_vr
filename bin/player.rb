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
        
        def add_score()
            @score += 1
        end
        
        def clear_score()
            @score = 0
        end
        
        def swap_mark()
            if @mark == :x
                @mark = :o
            else
                @mark = :x
            end
        end
        
        def print()
            print "#{@name}, type: #{@type}, score: #{@score}"
        end
    end
