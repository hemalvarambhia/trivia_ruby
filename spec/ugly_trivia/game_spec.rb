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

    context "when the player rolls more than 11" do
      it 'moves them back 12 places' do
        game.roll 12

        expect(game.current_position_of(0)).to eq 0
      end

      context 'and they are in the penalty box' do
        before(:each) do
          game.roll 6
          game.wrong_answer
          game.roll 4
          game.was_correctly_answered
          game.roll 7
        end

        it 'moves them back 12 places' do
          expect(game.current_position_of(0)).to eq 1
        end
      end
    end
    
    context 'when the player is not in the penalty box' do
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
      end

      context 'and they roll an odd number' do
        it 'asks them a question' do
          expect { game.roll(5) }.to output(/The category is.*/).to_stdout 
        end

        it 'allows them to get out of the penalty box' do
          expect { game.roll(3) }
            .to change { game.is_getting_out_of_penalty_box }
            .from(false).to(true)
        end
        
        context 'and they answer the question correctly' do
          before(:each) { game.roll(5) }
          
          it 'means they are still in the penalty box' do
            expect { game.was_correctly_answered }
              .not_to change { game.in_penalty_box?(0) }.from true
          end

          it 'awards them a gold coin' do
            expect { game.was_correctly_answered }
              .to change { game.gold_coins_awarded_to(0) }.by 1
          end
        end

        context 'and they still answer incorrectly' do
          before(:each) { game.roll(5) }
          
          it 'does not award them any gold coins' do
            expect { game.wrong_answer }
              .not_to change { game.gold_coins_awarded_to(0) }
          end

          it 'keeps them in the penalty box' do
            expect { game.wrong_answer }
              .not_to change { game.in_penalty_box?(0) }.from true
          end
        end
      end

      context 'and they roll an even number' do
        it 'does not ask them a question' do
          expect { game.roll(6) }.not_to output(/The category is.*/).to_stdout 
        end

        it 'does not allow them to leave the penalty box' do
          expect { game.roll(6) }
            .not_to change { game.is_getting_out_of_penalty_box }
            .from(false)
        end

        it 'does not change their current place in the game' do
          expect { game.roll(6) }
            .not_to change { game.current_position_of(0) }
        end
      end
    end

    context 'questions' do
      context 'when a player is at the start' do
        it 'asks them a pop question' do
          expect { game.roll 0 }.to result_in_a_question_on('Pop')
        end
      end

      context 'when a player is on the 4th place' do
        it 'asks them a Pop question' do
          expect { game.roll 4 }.to result_in_a_question_on('Pop')
        end
      end

      context 'when a player is on the 8th place' do
        it 'asks them a Pop question' do
          expect { game.roll 4 }.to result_in_a_question_on('Pop')
        end
      end

      context 'when the player is on the 1st place' do
        it 'asks them a Science question' do
          expect { game.roll 1 }.to result_in_a_question_on('Science')
        end
      end

      context 'when the player is on the 5th place' do
        it 'asks them a Science question' do
          expect { game.roll 5 }.to result_in_a_question_on('Science')
        end
      end

      context 'when the player is on the 9th place' do
        it 'asks them a Science question' do
          expect { game.roll 9 }.to result_in_a_question_on('Science')
        end
      end

      context 'when the player is on the 2nd place' do
        it 'asks them a Sports question' do
          expect { game.roll 2 }.to result_in_a_question_on('Sports')
        end
      end

      context 'when the player is on the 6th place' do
        it 'asks them a Sports question' do
          expect { game.roll 6 }.to result_in_a_question_on('Sports')
        end
      end

      context 'when the player is on the 10th place' do
        it 'asks them a Sports question' do
          expect { game.roll 10 }.to result_in_a_question_on('Sports')
        end
      end

      context 'when the player is on the 3rd place' do
        it 'asks them a Rock question' do
          expect { game.roll 3 }.to result_in_a_question_on('Rock')
        end
      end

      context 'when the player is on the 7th place' do
        it 'asks them a Rock question' do
          expect { game.roll 7 }.to result_in_a_question_on('Rock')
        end
      end

      context 'when the player is on the 11th place' do
        it 'asks them a Rock question' do
          expect { game.roll 11 }.to result_in_a_question_on('Rock')
        end
      end
    end

    def result_in_a_question_on(category)
      output(/The category is #{category}/).to_stdout
    end
  end
end
