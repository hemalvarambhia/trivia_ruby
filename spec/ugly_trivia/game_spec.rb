require 'spec_helper'
require 'ugly_trivia/game'
describe UglyTrivia::Game do
  let(:game) { UglyTrivia::Game.new }

  describe 'game set up' do
    it 'consists of 50 pop questions' do
      expected = Array.new(50) { |number| "Pop Question #{number}"}
      expect(game.pop_questions).to eq expected
    end

    it 'consists of 50 science questions' do
      expected = Array.new(50) { |number| "Science Question #{number}" }
      expect(game.science_questions).to eq expected
    end

    it 'consists of 50 sports questions' do
      expected = Array.new(50) { |number| "Sports Question #{number}" }
      expect(game.sports_questions).to eq expected
    end

    it 'consists of 50 rock questions' do
      expected = Array.new(50) { |number| "Rock Question #{number}" }
      expect(game.rock_questions).to eq expected
    end
  end

  describe 'Rules of the game' do
    before(:each) do
      game.add 'Player 1'
      game.add 'Player 2'
    end
    
    context 'given the player is not in the penalty box' do
      before(:each) { game.roll(6) }

      it 'moves the places the number of places as shown on the die' do
        expect(game.current_position_of(0)).to eq 6
      end

      context 'when they answer correctly' do
        it 'awards them a gold coin' do
          expect { game.was_correctly_answered }
            .to change { game.gold_coins_awarded_to(0) }.by 1
        end
        
        it 'is the next players turn' do
          expect { game.was_correctly_answered }
            .to change { game.current_player }.from(0).to 1
        end
      end

      context 'when they answer incorrectly' do
        it 'places them in the penalty box' do
          expect { game.wrong_answer }
            .to change { game.in_penalty_box?(0) }.from(nil).to eq true
        end

        it 'does not award them any gold coins' do
          expect { game.wrong_answer }
            .not_to change { game.gold_coins_awarded_to(0) }
        end
        
        it "is now the next player's turn" do
          expect { game.wrong_answer }
            .to change { game.current_player }.from(0).to 1
        end
      end
    end

    context 'when the player is in the penalty box' do
      before(:each) do
        game.roll(4)
        game.wrong_answer

        game.roll(3)
        game.was_correctly_answered

        game.roll(5)
      end
      
      context 'and they answer the question correctly' do
        it 'means they are still in the penalty box' do
          expect { game.was_correctly_answered }
            .not_to change { game.in_penalty_box?(0) }.from true
        end

        it 'awards them a gold coin' do
          expect { game.was_correctly_answered }
            .to change { game.gold_coins_awarded_to(0) }.by 1
        end
      end

      
    end
  end
end
