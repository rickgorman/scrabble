require_relative './spec_helper.rb'
require_relative '../src/move.rb'

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
end
