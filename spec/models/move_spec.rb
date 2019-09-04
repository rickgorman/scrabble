require_relative '../spec_helper.rb'
require_relative '../../src/models/move.rb'

RSpec.describe Move do
  let(:move_across) { Move.new(row: 0, col: 0, direction: :across, letters: ['a']) }
  let(:move_down) { Move.new(row: 0, col: 0, direction: :down, letters: ['a']) }

  describe '#across?' do
    context 'when the move is across' do
      subject { move_across.across? }

      it { is_expected.to be true }
    end

    context 'when the move is down' do
      subject { move_down.across? }

      it { is_expected.to be false }
    end
  end

  describe '#down?' do
    context 'when the move is across' do
      subject { move_across.down? }

      it { is_expected.to be false }
    end

    context 'when the move is down' do
      subject { move_down.down? }

      it { is_expected.to be true }
    end
  end

  describe '#length' do
    let(:letters) { ['a', 'b', 'c'] }

    subject do
      Move.new(row: 0, col: 0, direction: :down, letters: letters).length
    end

    it 'returns the length of the letters array' do
      expect(subject).to eq letters.count
    end
  end

  describe '#to_s' do
    let(:letters) { ['a', 'b', 'c'] }
    let(:starting_row) { 4 }
    let(:starting_col) { 5 }

    subject do
      Move.new(row: starting_row, col: starting_col, direction: :down, letters: letters).to_s
    end

    it 'explains the letters being played' do
      expect(subject).to match /#{letters.join('')}/
      expect(subject).to match /\Wdown/
      expect(subject).to match /#{starting_row}/
      expect(subject).to match /#{starting_col}/
    end
  end
end
