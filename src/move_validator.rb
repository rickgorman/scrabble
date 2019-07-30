require_relative './board.rb'
require_relative './move.rb'

class MoveValidator
  MIN_WORD_LENGTH = 2

  def initialize(board:, move:, dictionary: ['aaa', 'bbb'])
    @board = board
    @move = move
    @dictionary = dictionary
  end

  def valid_move?
    return false if move_goes_off_the_board?
    return false if move_overlaps_existing_word?

    dictionary_contains_all_words?(words_visible_on(next_board))
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

  def move_overlaps_existing_word?
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

  def next_board
    @next_board ||= Board.clone(board)

    # TODO: simplify shared code
    if move.across?
      move.letters.each_with_index do |letter, offset|
        @next_board.set_tile(
          row: move.row,
          col: move.col + offset,
          letter: letter
        )
      end
    elsif move.down?
      move.letters.each_with_index do |letter, offset|
        @next_board.set_tile(
          row: move.row + offset,
          col: move.col,
          letter: letter
        )
      end
    end

    @next_board
  end

  def dictionary_contains_all_words?(words)
    # TODO: speed this up using a hashmap for the dictionary
    words.all? { |word| dictionary.include?(word) }
  end

  def words_visible_on(some_board)
    # TODO: replace with a better word that describes an abstraction that can be
    #  either a row or a column.
    gridlines = []

    # store string representations of all rows and columns
    some_board.width.times do |idx|
      gridlines << some_board.get_row(idx).map { |tile| tile.to_s }.join('')
      gridlines << some_board.get_col(idx).map { |tile| tile.to_s }.join('')
    end

    # return all words that can be made from these gridlines
    gridlines
      .map(&:split)
      .flatten
      .select { |word| word.length >= MIN_WORD_LENGTH }
  end
end
