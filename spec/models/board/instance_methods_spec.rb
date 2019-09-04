require_relative '../../spec_helper.rb'
require_relative '../../../src/models/board.rb'

RSpec.describe Board do
  describe '#initialize' do
    context 'when given a preset' do
      it 'loads the preset into the board'
    end
  end

  describe '#width' do
    let(:expected_width) { 5 }

    subject { Board.new(width: expected_width).width }

    it 'returns the width of the board' do
      expect(subject).to eq expected_width
    end
  end

  describe '#set_tile' do
    let(:board) { Board.new }
    let(:letter) { 'a' }

    subject { board.set_tile(row: 0, col: 0, letter: letter) }

    it 'creates a new tile at that location' do
      subject

      expect(board.send(:grid)[0][0].to_s).to eq letter
    end

    it 'returns the letter' do
      expect(subject).to eq letter
    end
  end

  describe '#get_tile' do
    let(:board) { Board.new(preset: 'abc') }

    subject { board.get_tile(row: 0, col: 0) }

    it 'is a Tile that represents the letter a' do
      expect(subject.to_s).to eq 'a'
    end
  end

  describe '#get_row' do
    let(:board) { Board.new(width: 3, preset: 'abcabc') }

    subject { board.get_row(0) }

    it "contains tiles representing 'abc' " do
      tiles = subject

      expect(tiles.map { |tile| tile.to_s }.join('')).to eq 'abc'
    end
  end

  describe '#get_col' do
    let(:board) { Board.new(width: 3, preset: 'abcabc') }

    subject { board.get_col(0) }

    it "contains tiles representing 'aa' " do
      tiles = subject

      expect(tiles.map { |tile| tile.to_s }.join('')).to eq 'aa '
    end
  end

  describe '#to_preset' do
    subject { Board.new(preset: preset).to_preset }

    it { is_expected.to eq preset }
  end

  describe '#render' do
    context 'when using a fresh board' do
      subject { Board.new(width: 3).render }

      it 'renders an empty board' do
        expected  = "+-------+\n"
        expected += "|       |\n"
        expected += "|       |\n"
        expected += "|       |\n"
        expected += "+-------+"

        expect(subject).to eq expected
      end
    end

    context 'when using a preset board' do
      subject { Board.new(width: 3, preset: 'abcde g i').render }

      it 'renders an appropriate board' do
        expected  = "+-------+\n"
        expected += "| a b c |\n"
        expected += "| d e   |\n"
        expected += "| g   i |\n"
        expected += "+-------+"

        expect(subject).to eq expected
      end
    end
  end
end
