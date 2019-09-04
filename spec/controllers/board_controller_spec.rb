require_relative '../spec_helper.rb'
require_relative '../../src/controllers/board_controller.rb'
require_relative '../../src/services/move_validator.rb'
require_relative '../../src/models/move.rb'

RSpec.describe BoardController do
  describe '::update' do
    let(:move) { double('move') }
    let(:existing_board) { double('board') }
    let(:dictionary) { ['aabc', 'aaaaa'] }
    let(:move_validator) do
      double('move_validator', "valid_move?" => validity_of_move)
    end

    before do
      allow(Board)
        .to receive(:clone_and_apply_move)
    end

    subject do
      BoardController.update(
        board: existing_board,
        move: move,
        dictionary: dictionary,
        move_validator: move_validator
      )
    end

    context 'when the move is invalid' do
      let(:validity_of_move) { false }

      it 'raises an exception' do
        expect { subject }
          .to raise_exception InvalidMoveException
      end
    end

    context 'when the move is valid' do
      let(:validity_of_move) { true }
      let(:expected_next_board) { double('expected_next_board') }

      before do
        allow(Board)
          .to receive(:clone_and_apply_move)
          .and_return(expected_next_board)
      end

      it 'returns a board containing the new move' do
        next_board = subject

        expect(Board)
          .to have_received(:clone_and_apply_move)
          .with(board: existing_board, move: move)

        expect(next_board).to eq expected_next_board
      end
    end
  end
end
