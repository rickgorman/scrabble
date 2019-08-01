require_relative './spec_helper'
require_relative '../src/human_player.rb'
require_relative '../src/board.rb'

RSpec.describe HumanPlayer do
  describe '#get_move' do
    let(:board) { Board.new }
    subject { HumanPlayer.new(board: board).get_move }

    it { is_expected.to be_a Move }
  end

  describe '#receive_tiles' do
    let(:player) { HumanPlayer.new(board: Board.new) }

    subject do
      player.receive_tiles(tiles_to_receive)
    end

    context 'when the player HAS space in his rack' do
      let(:tiles_to_receive) { ['a','b','c'] }
      let(:starting_tiles) { ['x','y','z'] }

      before do
        player.rack.concat(starting_tiles)
      end

      it "adds the given tiles to the player's rack" do
        subject

        expect(player.rack).to match_array (tiles_to_receive + starting_tiles)
      end
    end

    context 'when the player DOES NOT have space in his rack' do
      let(:tiles_to_receive) { ['a','b','c'] }
      let(:starting_tiles) { ['v','w','x','y','z'] }

      before do
        player.rack.concat(starting_tiles)
      end

      it "raises an exception" do
        expect { subject }.to raise_exception /too many tiles/
      end
    end
  end

end
