require_relative '../spec_helper.rb'
require_relative '../../src/controllers/board_controller.rb'
require_relative '../../src/services/move_validator.rb'
require_relative '../../src/models/move.rb'

RSpec.describe BoardController do
  # TODO: convert this spec into a delegation test
  describe '#update' do
    let(:move) do
      Move.new(row: 1, col: 0, direction: :down, letters: ['a', 'b', 'c'])
    end
    let(:existing_board) do
      Board.new(width: 5, preset: 'aaaaa')
    end
    let(:dictionary) { ['aabc', 'aaaaa'] }
    let(:move_validator) do
      double('move_validator', "valid_move?" => validity_of_move)
    end

    before do
      allow(MoveValidator)
        .to receive(:new)
        .and_return(move_validator)
    end

    subject do
      BoardController.new.update(
        board: existing_board,
        move: move,
        dictionary: dictionary
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
      let(:existing_board_letters) { existing_board.to_preset.split('') }

      it 'returns a board containing the prior board state' do
        next_board = subject
        next_board_letters = next_board.to_preset.split('')
        new_letters = next_board_letters - existing_board_letters

        expect(
          second_array_includes_first?(
            existing_board_letters,
            next_board_letters))
        .to be true
      end

      it 'returns a board containing the new move' do
        next_board = subject

        next_board_letters = next_board.to_preset.split('')
        existing_board_letters = existing_board.to_preset.split('')
        new_letters = additional_letters(existing_board_letters, next_board_letters)

        expect(new_letters).to match_array move.letters
      end
    end
  end

  private

  def second_array_includes_first?(array1, array2)
    array1_freq = key_frequencies(array1)

    array2_freq = key_frequencies(array2)

    # ensure that all the distinct elements from array1 are included in array2
    return false unless array2_freq.keys - array1_freq.keys == []

    # ensure that the count of each element in array2 is >= the count in array1
    array1_freq.keys.each do |key|
      return false unless array1_freq[key] <= array2_freq[key]
    end

    true
  end

  def additional_letters(existing_letters, incoming_letters)
    incoming_letter_freq = key_frequencies(incoming_letters)
    existing_letter_freq = key_frequencies(existing_letters)

    result = []

    incoming_letter_freq.keys.each do |letter|
      next if letter == " "
      new_count = incoming_letter_freq[letter] - existing_letter_freq[letter]
      next if new_count < 1
      new_count.times { result << letter }
    end

    result
  end

  def key_frequencies(array)
    array_freq = Hash.new(0)
    array.each do |el|
      next if el == " "
      array_freq[el] += 1
    end
    array_freq
  end
end
