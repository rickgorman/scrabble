require_relative './move.rb'

class HumanPlayer
  MAX_RACK_SIZE = 7

  def initialize(board:)
    @board = board
    @rack = []
  end

  attr_reader :rack, :board

  def get_move
    letters = rack.sample(rand(rack.size) + 1)
    row = rand(board.width)
    col = rand(board.width)
    direction = rand(2) == 1 ? :down : :across

    Move.new(row: row, col: col, direction: :down, letters: letters)
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
