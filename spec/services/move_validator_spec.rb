require_relative '../spec_helper.rb'
require_relative '../../src/services/move_validator.rb'
require_relative '../../src/models/board.rb'

RSpec.describe MoveValidator do
  describe '#valid_move?' do
    let(:board) { Board.new(width: 5, preset: preset) }

    subject do
      MoveValidator
        .new(board: board, move: move, dictionary: dictionary)
        .valid_move?
    end

    context 'when playing the very first word' do
      let(:dictionary) { ['aaa'] }

      let(:preset) {
        '     ' +
        '     ' +
        '     ' +
        '     ' +
        '     '
      }

      context 'and the Move represents a word in the dictionary' do
        let(:move) do
          Move.new(row: 0, col: 0, direction: :down, letters: ['a','a','a'])
        end

        it { is_expected.to be true }
      end
    end

    context 'when playing a word that builds on another word' do
      let(:preset) {
        'aaa  ' +
        '     ' +
        '     ' +
        '     ' +
        '     '
      }

      context 'and the Move would create a word in the dictionary' do
        let(:dictionary) { ['aaa', 'abb'] }

        let(:move) do
          Move.new(row: 1, col: 0, direction: :down, letters: ['b','b'])
        end

        it { is_expected.to be true }
      end

      context 'and the Move would create a word NOT in the dictionary' do
        let(:dictionary) { ['aaa'] }

        let(:move) do
          Move.new(row: 1, col: 0, direction: :down, letters: ['b','b'])
        end

        it { is_expected.to be false }
      end
    end

    context 'when playing a word that would create multiple words' do
      let(:preset) {
        'aaa  ' +
        '     ' +
        '     ' +
        '     ' +
        '     '
      }

      context 'and all created words are in the dictionary' do
        let(:dictionary) { ['aaa', 'bbb', 'abb', 'aa'] }

        let(:move) do
          Move.new(row: 1, col: 1, direction: :across, letters: ['a','a','a'])
        end

        it { is_expected.to be true }
      end

      context 'and one word is not in the dictionary (ab)' do
        let(:dictionary) { ['aaa', 'bbb', 'abb', 'aa'] }

        let(:move) do
          Move.new(row: 1, col: 1, direction: :across, letters: ['a','b','a'])
        end

        it { is_expected.to be false }
      end
    end

    context 'when the word goes off the board vertically' do
      let(:dictionary) { ['aaa'] }

      let(:preset) {
        '     ' +
        '     ' +
        '     ' +
        '     ' +
        '     '
      }

      let(:move) do
        Move.new(row: 4, col: 4, direction: :down, letters: ['a','a','a'])
      end

      it { is_expected.to be false }
    end

    context 'when the word goes off the board horizontally' do
      let(:dictionary) { ['aaa'] }

      let(:preset) {
        '     ' +
        '     ' +
        '     ' +
        '     ' +
        '     '
      }

      let(:move) do
        Move.new(row: 4, col: 4, direction: :across, letters: ['a','a','a'])
      end

      it { is_expected.to be false }
    end

    context 'when playing over an existing word, illegally' do
      let(:dictionary) { ['aaa', 'aba', 'bbb'] }

      let(:preset) {
        'aaa  ' +
        '     ' +
        '     ' +
        '     ' +
        '     '
      }

      let(:move) do
        Move.new(row: 0, col: 1, direction: :across, letters: ['b', 'b', 'b'])
      end

      it { is_expected.to be false }
    end

    context 'when a play crosses over an existing word, legally' do
      let(:dictionary) { ['aaa', 'bab'] }

      let(:preset) {
        '     ' +
        '  a  ' + #                     '  a  '
        '  a  ' + # move will create => ' bab '
        '  a  ' + #                     '  a  '
        '     '
      }

      let(:move) do
        Move.new(row: 2, col: 1, direction: :across, letters: ['b', '', 'b'])
      end

      it { is_expected.to be true }
    end
    
    context 'when a play would be unattached to the starter word' do
      let(:dictionary) { ['aaa', 'bb'] }

      let(:preset) {
        'aaa  ' + #                     'aaa  '
        '     ' + #                     '     '
        '     ' + # move will create => '  bb '
        '     ' + #                     '     '
        '     '   #                     '     '
      }

      let(:move) do
        Move.new(row: 2, col: 2, direction: :across, letters: ['b', 'b'])
      end

      it { is_expected.to be false }
    end
  end

  describe '#words_visible_on (private method)' do
    let(:dictionary) { ['aaa', 'bbb', 'abb'] }

    subject do
      MoveValidator
        .new(board: board, move: move, dictionary: dictionary)
        .send(:words_visible_on, board)
    end

    context 'when looking at an empty board' do
      let(:board) { Board.new }
      let(:move) { Move.new(row: 0, col: 0, direction: :across, letters: ['a']) }

      it { is_expected.to eq [] }
    end

    context 'when looking at a board with some words on it' do
      let(:preset) {
        'aaa  ' +
        'bb   ' +
        ' cccc' +
        '    d' +
        '  abe'
      }
      let(:board) { Board.new(width: 5, preset: preset) }
      let(:move) { Move.new(row: 0, col: 0, direction: :across, letters: ['a']) }

      let(:expected_words) do
        ['aaa', 'bb', 'cccc', 'abe', 'ab', 'abc', 'cde']
      end

      it { is_expected.to match_array expected_words }
    end
  end
end
