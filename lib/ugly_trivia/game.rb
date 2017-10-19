module UglyTrivia
  class Game
    attr_reader :current_player, :is_getting_out_of_penalty_box
    attr_reader :places, :categories
    
    def initialize
      @contestants = []
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
      @contestants[player].place
    end

    def gold_coins_awarded_to(player)
      @contestants[player].gold_coins
    end

    def in_penalty_box?(player)
      @contestants[player].in_penalty_box?
    end

    def add(player_name)
      @contestants.push Contestant.new(name: player_name)
      puts "#{player_name} was added"
      puts "They are player number #{how_many_players}"

      true
    end

    def how_many_players
      @contestants.count
    end

    def roll(roll)
      puts "#{current_player_name} is the current player"
      puts "They have rolled a #{roll}"

      if in_penalty_box?(current_player)
        if roll.even?
          puts "#{current_player_name} is not getting out of the penalty box"
          @is_getting_out_of_penalty_box = false
          return
        else
          @is_getting_out_of_penalty_box = true
          puts "#{current_player_name} is getting out of the penalty box"
        end
      end

      move(player: current_player, roll: roll)
      puts "The category is #{current_category}"
      ask_question
    end

    private

    def ask_question
      puts @questions[current_category].shift
    end

    def current_category
      current_position = @contestants[current_player].place
      @categories.fetch(current_position, 'Rock')
    end

  public

    def was_correctly_answered
      if in_penalty_box?(current_player)
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
      place_in_penalty_box(current_player)

      next_players_turn
      return true
    end

    private

    def place_in_penalty_box(player)
      @contestants[player].place_in_penalty_box
    end

    def did_player_win
      gold_coins_awarded_to(current_player) < 6
    end

    def next_players_turn
      @current_player += 1
      @current_player = 0 if current_player == how_many_players
    end

    def award_gold_coin_to(player)
      @contestants[player].award_gold_coin
      puts "#{name_of(player)} now has #{gold_coins_awarded_to(player)} Gold Coins."
    end

    def move(player:, roll:)
      @contestants[player].move(roll)

    end

    def current_player_name
      @contestants[current_player].to_s
    end

    def name_of(player)
      @contestants[player].to_s
    end

    class Contestant
      attr_reader :place
      
      def initialize(name:)
        @name = name
        @place = 0
        @purse = 0
        @in_penalty_box = nil
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
        @place -= 12 if @place > 11
      end

      def to_s
        @name
      end
    end
  end
end
