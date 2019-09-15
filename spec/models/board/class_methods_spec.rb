require_relative '../../spec_helper.rb'
require_relative '../../../src/models/board.rb'
require_relative '../../../src/services/move_validator.rb'

RSpec.describe Board do
  describe '::clone' do
    let(:expected_width) { 5 }

    subject { Board.clone(source_board) }

    it 'creates a board with the same width as the source_board' do
      expect(subject.width).to eq source_board.width
    end

    it 'creates a board with the same preset as the source_board' do
      expect(subject.to_preset).to eq source_board.to_preset
    end
  end

  describe '::clone_and_apply_move' do
    let(:move) do
      Move.new(row: 1, col: 0, direction: :down, letters: ['a', 'b', 'c'])
    end
    let(:source_board) do
      Board.new(width: 5, preset: 'aaaaa')
    end
    let(:dictionary) { ['aabc', 'aaaaa'] }

    subject do
      Board.clone_and_apply_move(
        board: source_board,
        move: move
      )
    end

    context 'when the move is valid' do
      let(:source_board) { Board.new(width: 5) }
      let(:source_board_letters) { source_board.to_preset.split('') }

      it 'does not mutate the existing board' do
        initial_board_hash = source_board.hash

        subject

        expect(source_board.hash)
          .to eq initial_board_hash
      end

      it 'returns a board containing the prior board state' do
        next_board = subject
        next_board_letters = next_board.to_preset.split('')
        new_letters = next_board_letters - source_board_letters

        expect(
          second_array_includes_first(
            source_board_letters,
            next_board_letters
          )
        )
          .to be true
      end

      it 'returns a board containing the new move' do
        next_board = subject

        next_board_letters = next_board.to_preset.split('')
        source_board_letters = source_board.to_preset.split('')
        new_letters = additional_letters(source_board_letters, next_board_letters)

        binding.pry
        expect(new_letters).to match_array move.letters
      end

      context 'and the move is played across an existing word' do

      end
    end
  end

  def additional_letters(first_array, second_array)
    letters = []

    second_array.each_with_index do |second_array_el, idx|
      next if first_array[idx] != " "
      next if second_array_el  == " "

      letters << second_array_el
    end

    letters
  end

  def second_array_includes_first(first_array, second_array)
    first_array.each_with_index do |first_array_el, idx|
      next if first_array_el == " "

      return false unless first_array_el == second_array[idx]
    end

    true
  end
end
