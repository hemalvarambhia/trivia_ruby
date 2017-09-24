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

  describe 'adding a player' do
    it 'places the player at the first square' do
      game.add('Player 1')

      expect(game.places[0]).to eq 0
    end
  end
end
