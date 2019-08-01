require_relative './move.rb'

class HumanPlayer
  MAX_RACK_SIZE = 7

  def initialize(board:)
    @board = board
    @rack = []
  end

  attr_reader :rack

  def get_move
    Move.new(row: 0, col: 0, direction: :down, letters: ['z'])
  end

  def receive_tiles(tiles)
    raise "too many tiles in rack" if rack.length + tiles.length > MAX_RACK_SIZE

    rack.concat(tiles)
  end
end
