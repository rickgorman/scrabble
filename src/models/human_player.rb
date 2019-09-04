require_relative './move.rb'

class HumanPlayer
  MAX_RACK_SIZE = 7

  def initialize(board:)
    @board = board
    @rack = []
  end

  attr_reader :rack

  def get_move
    letters = rack.sample(rand(rack.size) + 1)

    Move.new(row: 0, col: 0, direction: :down, letters: letters)
  end

  def receive_tiles(tiles)
    raise "too many tiles in rack" if rack.length + tiles.length > MAX_RACK_SIZE

    rack.concat(tiles)
  end

  def drop_tiles(incoming_tiles)
    begin
      incoming_tiles.each { |tile| rack.delete_at(rack.find_index(tile)) }
    rescue
      raise "some of these tiles not in rack: #{incoming_tiles} | rack: #{rack}"
    end
  end
end
