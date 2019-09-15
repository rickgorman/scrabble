require_relative '../models/board.rb'
require_relative '../models/move.rb'

class MoveValidator
  MIN_WORD_LENGTH = 2

  def initialize(board:, move:, dictionary: ['aaa', 'bbb'])
    @board = board
    @move = move
    @dictionary = dictionary
  end

  def valid_move?
    return false if move_goes_off_the_board?
    return false if move_is_disconnected_from_existing_words?

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

  # TODO: Remove tight coupling due to knowing implementation details of Tile.
  #  In other words, a better method than #to_preset needs to be created.
  #  Probably an accessor on Board#grid

  # at least one tile in the move must land directly below or right of an
  # existing tile (not both below/right)
  def move_is_disconnected_from_existing_words?
    return false if board.empty?

    new_tile_positions.each do |new_tile_position|
      new_tile_row = new_tile_position[0]
      new_tile_col = new_tile_position[1]

      existing_tile_positions.each do |existing_tile_position|
        existing_tile_row = existing_tile_position[0]
        existing_tile_col = existing_tile_position[1]

        return false if (new_tile_row == existing_tile_row) && (
          new_tile_col == existing_tile_col - 1 ||
          new_tile_col == existing_tile_col + 1
        )

        return false if (new_tile_col == existing_tile_col) && (
          new_tile_row == existing_tile_row + 1 ||
          new_tile_row == existing_tile_row - 1
        )
      end
    end

    true
  end

  def dictionary_contains_all_words?(words)
    # TODO: speed this up using a hashmap for the dictionary
    words.all? { |word| dictionary.include?(word) }
  end

  def next_board
    Board.clone_and_apply_move(board: board, move: move)
  end

  def words_visible_on(some_board)
    all_rows_and_columns_on(some_board)
      .flat_map(&:split)
      .select { |word| word.length >= MIN_WORD_LENGTH }
  end

  def all_rows_and_columns_on(some_board)
    gridlines = []

    # store string representations of all rows and columns
    some_board.width.times do |idx|
      gridlines << some_board.get_row(idx).map { |tile| tile.to_s }.join('')
      gridlines << some_board.get_col(idx).map { |tile| tile.to_s }.join('')
    end

    gridlines
  end

  def existing_tile_positions
    existing_tile_positions = []

    board.to_preset.split('').each_with_index do |letter, idx|
      next if letter == ' '

      row = idx / board.width
      col = idx % board.width

      existing_tile_positions << [row, col]
    end

    existing_tile_positions
  end

  def new_tile_positions
    new_tile_positions = []

    existing_letters_in_row_count = 0
    existing_letters_in_col_count = 0

    move.letters.each_with_index do |letter, offset|
      if move.down?
        row = move.row + offset + existing_letters_in_row_count
      else
        row = move.row
      end

      if move.across?
        col = move.col + offset + existing_letters_in_col_count
      else
        col = move.col
      end

      # find the next open space on the board
      binding.pry
      until board.get_tile(row: row, col: col).empty?
        binding.pry
        if move.down?
          row += 1
          existing_letters_in_row_count += 1
        else
          col += 1
          existing_letters_in_col_count += 1
        end
      end
      binding.pry

      new_tile_positions << [row, col]
    end

    new_tile_positions
  end
end
