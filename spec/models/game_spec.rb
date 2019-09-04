require_relative '../spec_helper.rb'
require_relative '../../src/models/game.rb'

RSpec.describe Game do
  describe '#display_board' do
    let(:board) { double('board') }
    let(:player) { double('HumanPlayer') }

    before do
      allow(board)
        .to receive(:render)
        .and_return(:awesome)

      allow(Kernel)
        .to receive(:puts)

      allow(player)
        .to receive(:receive_tiles)

      allow(player)
        .to receive(:to_s)
        .and_return('hi im a player')
    end

    subject do
      Game.new(
        board: board,
        players: [player]
      )
        .display_board(current_player: player)
    end

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
