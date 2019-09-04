require_relative './spec_helper.rb'

require_relative '../src/tile.rb'

RSpec.describe Tile do
  describe '.null' do
    subject { Tile.null }

    it { is_expected.to be_a Tile }

    it 'represents an empty space on the board' do
      tile = subject

      expect(tile.letter).to eq nil
    end
  end

  describe '#occupied?' do
    subject { Tile.new(letter).occupied? }

    context 'when the tile represents a letter' do
      let(:letter) { 'a' }

      it { is_expected.to be true }
    end

    context 'when the tile represents an empty space' do
      let(:letter) { nil }

      it { is_expected.to be false }
    end
  end

  describe '#to_s' do
    subject { Tile.new(letter).to_s }

    context 'when the tile represents a letter' do
      let(:letter) { 'b' }

      it 'outputs the letter' do
        expect(subject).to eq letter
      end
    end

    context 'when the tile represents an empty tile' do
      let(:letter) { nil }

      it 'outputs an empty space' do
        expect(subject).to eq ' '
      end
    end
  end
end
