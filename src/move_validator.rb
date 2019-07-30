require_relative './board.rb'
require_relative './move.rb'

class MoveValidator
  def initialize(board:, move:, dictionary: ['aaa', 'bbb'])
    @board = board
    @move = move
    @dictionary = dictionary
  end

  def valid_move?
    return false if move_goes_off_the_board?
    return false if move_goes_over_existing_word?

    # create a new board and apply the move

    # scan for all words on the board

    # verify that all words are in the dictionary
  end

  private

  attr_reader :move, :board, :dictionary

  def move_goes_off_the_board?
    ending_index = if move.across?
      move.col + move.letters.count - 1
    else
      move.row + move.letters.count - 1
    end

    ending_index > board.width
  end

  def move_goes_over_existing_word?
    move.letters.each_with_index do |_, offset|
      if move.across?
        potentially_overlapping_tile = \
          board.get_tile(row: move.row, col: move.col + offset)
      elsif move.down?
        potentially_overlapping_tile = \
          board.get_tile(row: move.row + offset, col: move.col)
      else
        raise "move does not go either down or across. check the move."
      end

      return true if potentially_overlapping_tile.occupied?
    end

    false
  end
end
