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
end
