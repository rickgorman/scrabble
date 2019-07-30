require_relative './spec_helper'
require_relative '../src/human_player.rb'
require_relative '../src/board.rb'

RSpec.describe HumanPlayer do
  describe '#get_move' do
    let(:board) { Board.new }
    subject { HumanPlayer.new(board: board).get_move }

    it { is_expected.to be_a Move }
  end
end
