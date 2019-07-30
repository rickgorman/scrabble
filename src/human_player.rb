require_relative './move.rb'

class HumanPlayer
  def initialize(board:)
    @board = board
  end

  def get_move
    Move.new(row: 0, col: 0, direction: :down, letters: ['z'])
  end
end
