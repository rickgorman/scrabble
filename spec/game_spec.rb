require_relative './spec_helper.rb'
require_relative '../src/game.rb'

RSpec.describe Game do
  describe '#display_board' do
    let(:board) { double('board') }

    before do
      allow(board)
        .to receive(:render)
        .and_return(:awesome)

      allow(Kernel)
        .to receive(:puts)
    end

    subject { Game.new(board: board).display_board }

    it 'delegates to Board#render' do
      subject

      expect(board)
        .to have_received(:render)
    end

    it 'puts the rendered board' do
      # subject
      #
      # expect(Kernel)
      #   .to have_received(:puts)
      #   .with(:awesome)
    end
  end
end
