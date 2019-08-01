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

  def drop_tiles(incoming_tiles)
    begin
      incoming_tiles.each { |tile| rack.delete_at(rack.find_index(tile)) }
    rescue
      raise "tiles not in hand"
    end
  end
end
