require_relative '../spec_helper'
require_relative '../../src/models/human_player.rb'
require_relative '../../src/models/board.rb'

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

  describe '#drop_tiles' do
    let(:player) { HumanPlayer.new(board: Board.new) }
    let(:starting_tiles) { ['a','a','b','c','c','d','e'] }

    before do
      player.receive_tiles(starting_tiles)
    end

    subject { player.drop_tiles(tiles_to_drop) }

    context "when all tiles are present in the player's rack" do
      let(:tiles_to_drop) { ['a','b','e'] }

      it "removes those tiles from the player's rack" do
        subject

        expect(player.rack).to match_array ['a','c','c','d']
      end
    end

    context "when at least one tile is not present in the player's rack" do
      let(:tiles_to_drop) { ['z'] }

      it 'raises an exception' do
        expect {
          subject
        }.to raise_exception /tiles not in rack/
      end
    end

    context "when multiple quantities of the same tile are not present in the player's rack" do
      let(:tiles_to_drop) { ['b','b'] }

      it 'raises an exception' do
        expect {
          subject
        }.to raise_exception /tiles not in rack/
      end
    end
  end
end
