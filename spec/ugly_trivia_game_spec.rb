require 'spec_helper'
require 'ugly_trivia/game'
describe UglyTrivia::Game do
  let(:game) { UglyTrivia::Game.new }
  
  it 'has 50 pop questions' do
    expected = Array.new(50) { |number| "Pop Question #{number}"}
    expect(game.pop_questions).to eq expected
  end

  it 'has 50 science questions' do
    expected = Array.new(50) { |number| "Science Question #{number}"}
    expect(game.science_questions).to eq expected
  end
end
