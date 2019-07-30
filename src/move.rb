class Move
  # TODO: rather than take letters, the move can take Tiles
  def initialize(row:, col:, direction:, letters:)
    @row = row
    @col = col
    @direction = direction
    @letters = letters
  end

  attr_reader :col, :row, :letters

  def across?
    direction == :across
  end

  def down?
    direction == :down
  end

  def length
    letters.count
  end

  private

  attr_reader :direction
end
