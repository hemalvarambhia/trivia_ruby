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

  describe '#roll' do
    before(:each) do
      game.add 'Player 1'
      game.add 'Player 2'
    end
    context 'given the player is not in the penalty box' do
      it 'moves the places the number of places as shown on the die' do
        game.roll(6)

        expect(game.position_of_player(0)).to eq 6
      end

      context 'when they answer correctly' do
        it 'awards the winning player a gold coin' do
          game.roll(6)
          
          expect { game.was_correctly_answered }.to(
            change { game.gold_coins_awarded_to_player(0) }.by 1)
        end
        
        it 'is the next players turn' do
          game.roll(6)
          game.was_correctly_answered

          expect(game.current_player).to eq 1
        end
      end
    end
  end
end
