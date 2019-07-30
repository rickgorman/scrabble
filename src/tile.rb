class Tile
  def self.null
    Tile.new(nil)
  end

  def initialize(letter)
    @letter = letter
  end

  def occupied?
    !letter.nil?
  end

  def to_s
    return ' ' if letter.nil?

    "#{letter}"
  end

  attr_reader :letter
end
