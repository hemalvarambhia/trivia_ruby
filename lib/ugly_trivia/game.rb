module UglyTrivia
  class Game
    attr_reader :current_player, :is_getting_out_of_penalty_box
    attr_reader :places, :categories
    
    def initialize
      @players = []
      @contestants = []
      @places = Array.new(6, 0)
      @purses = Array.new(6, 0)
      @in_penalty_box = Array.new(6, nil)
      @categories =
        {
          0 => 'Pop', 4 => 'Pop', 8 => 'Pop',
          1 => 'Science', 5 => 'Science', 9 => 'Science',
          2 => 'Sports', 6 => 'Sports', 10 => 'Sports'
        }
      @questions =
        {
          'Pop'     => Array.new(50) { |number| "Pop Question #{number}" },
          'Science' => Array.new(50) { |number| "Science Question #{number}" },
          'Sports'  => Array.new(50) { |number| "Sports Question #{number}" },
          'Rock'    => Array.new(50) { |number| "Rock Question #{number}" }
        }
      @current_player = 0
      @is_getting_out_of_penalty_box = false
    end

    def pop_questions
      @questions['Pop']
    end

    def science_questions
      @questions['Science']
    end

    def sports_questions
      @questions['Sports']
    end

    def rock_questions
      @questions['Rock']
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
      @contestants.push Contestant.new(name: player_name)
      puts "#{player_name} was added"
      puts "They are player number #{@players.length}"

      true
    end

    def how_many_players
      @players.length
    end

    def roll(roll)
      puts "#{current_player_name} is the current player"
      puts "They have rolled a #{roll}"

      if in_penalty_box?(@current_player)
        if roll.even?
          puts "#{current_player_name} is not getting out of the penalty box"
          @is_getting_out_of_penalty_box = false
          return
        else
          @is_getting_out_of_penalty_box = true
          puts "#{current_player_name} is getting out of the penalty box"
        end
      end

      move(player: @current_player, roll: roll)
      puts "The category is #{current_category}"
      ask_question
    end

    private

    def ask_question
      puts @questions[current_category].shift
    end

    def current_category
      @categories.fetch(@places[@current_player], 'Rock')
    end

  public

    def was_correctly_answered
      if in_penalty_box?(@current_player)
        if @is_getting_out_of_penalty_box
          puts 'Answer was correct!!!!'
          award_gold_coin_to(@current_player)
        end
      else
        puts "Answer was corrent!!!!"
        award_gold_coin_to(@current_player)
      end

      winner = did_player_win
      next_players_turn          
      winner
    end

    def wrong_answer
      puts 'Question was incorrectly answered'
      puts "#{current_player_name} was sent to the penalty box"
      place_in_penalty_box(@current_player)

      next_players_turn
      return true
    end

    private

    def place_in_penalty_box(player)
      @in_penalty_box[player] = true
    end

    def did_player_win
      @purses[@current_player] < 6
    end

    def next_players_turn
      @current_player += 1
      @current_player = 0 if @current_player == how_many_players
    end

    def award_gold_coin_to(player)
      @purses[player] += 1
      puts "#{@players[player]} now has #{@purses[player]} Gold Coins."
    end

    def move(player:, roll:)
      @places[player] = @places[player] + roll
      @places[player] = @places[player] - 12 if @places[player] > 11
      puts "#{@players[player]}'s new location is #{@places[player]}"
    end

    def current_player_name
      @players[@current_player]
    end

    class Contestant
      attr_reader :place
      
      def initialize(name:)
        @name = name
        @place = 0
        @purse = 0
        @in_penalty_box = false
      end

      def place_in_penalty_box
        @in_penalty_box = true
      end

      def in_penalty_box?
        @in_penalty_box
      end
      
      def gold_coins
        @purse
      end

      def award_gold_coin
        @purse += 1
      end

      def move(places)
        @place += places
        @place =- 12 if @place > 11
      end

      def to_s
        @name
      end
    end
  end
end
