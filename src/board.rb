require_relative './tile.rb'

class Board
  def self.clone(board)
    Board.new(width: board.width, preset: board.to_preset)
  end

  def self.clone_and_apply_move(board:, move:)
    next_board = Board.clone(board)

    # TODO: simplify shared code
    if move.across?
      move.letters.each_with_index do |letter, offset|
        next_board.set_tile(
          row: move.row,
          col: move.col + offset,
          letter: letter
        )
      end
    elsif move.down?
      move.letters.each_with_index do |letter, offset|
        next_board.set_tile(
          row: move.row + offset,
          col: move.col,
          letter: letter
        )
      end
    end

    next_board
  end

  def initialize(width: 15, preset: nil)
    @grid = Array.new(width) do
      Array.new(width) { Tile.null }
    end

    if !preset.nil?
      load_preset(preset)
    end
  end

  def width
    grid.count
  end

  def set_tile(row:, col:, letter:)
    grid[row][col] = Tile.new(letter)

    letter
  end

  def get_tile(row:, col:)
    grid[row][col]
  end

  def get_row(row_idx)
    grid[row_idx]
  end

  def get_col(col_idx)
    grid.transpose[col_idx]
  end

  def to_preset
    grid.flatten.map { |tile| tile.to_s }
      .join('')
  end

  def render
    border_row = "+" + "-" * (width * 2 + 1) + "+"

    buffer = border_row + "\n"

    grid.each_with_index do |row, row_idx|
      buffer += "|"
      row.each_with_index do |_, col_idx|
        buffer += ' ' + get_tile(row: row_idx, col: col_idx).to_s
      end
      buffer += " |\n"
    end

    buffer += border_row

    buffer
  end

  private

  attr_reader :grid

  def load_preset(preset)
    preset.chars.each_with_index do |letter, idx|
      row = idx / width
      col = idx % width
      set_tile(row: row, col: col, letter: letter)
    end
  end
end
