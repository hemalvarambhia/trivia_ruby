module UglyTrivia
  class Game
    attr_reader :pop_questions, :science_questions,
                :sports_questions, :rock_questions,
                :current_player, :is_getting_out_of_penalty_box

    attr_reader :places
    def  initialize
      @players = []
      @places = Array.new(6, 0)
      @purses = Array.new(6, 0)
      @in_penalty_box = Array.new(6, nil)

      @pop_questions = Array.new(50) { |number| "Pop Question #{number}" }
      @science_questions = Array.new(50) { |number| "Science Question #{number}" }
      @sports_questions = Array.new(50) { |number| "Sports Question #{number}" }
      @rock_questions = Array.new(50) { |number| "Rock Question #{number}" }

      @current_player = 0
      @is_getting_out_of_penalty_box = false
    end

    def is_playable?
      how_many_players >= 2
    end

    def current_position_of(player)
      @places[player]
    end

    def gold_coins_awarded_to(player)
      @purses[player]
    end

    def in_penalty_box?(player)
      @in_penalty_box[player]
    end

    def add(player_name)
      @players.push player_name
      @places[how_many_players] = 0
      @purses[how_many_players] = 0
      @in_penalty_box[how_many_players] = false

      puts "#{player_name} was added"
      puts "They are player number #{@players.length}"

      true
    end

    def how_many_players
      @players.length
    end

    def roll(roll)
      puts "#{@players[@current_player]} is the current player"
      puts "They have rolled a #{roll}"

      if @in_penalty_box[@current_player]
        if roll.even?
          puts "#{@players[@current_player]} is not getting out of the penalty box"
          @is_getting_out_of_penalty_box = false
        else
          @is_getting_out_of_penalty_box = true

          puts "#{@players[@current_player]} is getting out of the penalty box"
          @places[@current_player] = @places[@current_player] + roll
          @places[@current_player] = @places[@current_player] - 12 if @places[@current_player] > 11

          puts "#{@players[@current_player]}'s new location is #{@places[@current_player]}"
          puts "The category is #{current_category}"
          ask_question
        end
      else

        @places[@current_player] = @places[@current_player] + roll
        @places[@current_player] = @places[@current_player] - 12 if @places[@current_player] > 11

        puts "#{@players[@current_player]}'s new location is #{@places[@current_player]}"
        puts "The category is #{current_category}"
        ask_question
      end
    end

  private

    def ask_question
      puts @pop_questions.shift if current_category == 'Pop'
      puts @science_questions.shift if current_category == 'Science'
      puts @sports_questions.shift if current_category == 'Sports'
      puts @rock_questions.shift if current_category == 'Rock'
    end

    def current_category
      categories =
        {
          0 => 'Pop', 4 => 'Pop', 8 => 'Pop',
          1 => 'Science', 5 => 'Science', 9 => 'Science',
          2 => 'Sports', 6 => 'Sports', 10 => 'Sports'
        }

      categories.fetch(@places[@current_player], 'Rock')
    end

  public

    def was_correctly_answered
      if @in_penalty_box[@current_player]
        if @is_getting_out_of_penalty_box
          puts 'Answer was correct!!!!'
          @purses[@current_player] += 1
          puts "#{@players[@current_player]} now has #{@purses[@current_player]} Gold Coins."

          winner = did_player_win()
          @current_player += 1
          @current_player = 0 if @current_player == @players.length

          winner
        else
          @current_player += 1
          @current_player = 0 if @current_player == @players.length
          true
        end



      else

        puts "Answer was corrent!!!!"
        @purses[@current_player] += 1
        puts "#{@players[@current_player]} now has #{@purses[@current_player]} Gold Coins."

        winner = did_player_win
        @current_player += 1
        @current_player = 0 if @current_player == @players.length

        return winner
      end
    end

    def wrong_answer
  		puts 'Question was incorrectly answered'
  		puts "#{@players[@current_player]} was sent to the penalty box"
  		@in_penalty_box[@current_player] = true

      @current_player += 1
      @current_player = 0 if @current_player == @players.length
  		return true
    end

  private

    def did_player_win
      !(@purses[@current_player] == 6)
    end
  end
end
