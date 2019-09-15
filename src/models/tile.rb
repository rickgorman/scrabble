class Tile
  def self.null
    Tile.new(nil)
  end

  def initialize(letter)
    # TODO: decide if this gets sanitized here, or if we change something
    #  higher up in the code, or if we change how empty spaces are handled
    if letter == ' '
      @letter = nil
    else
      @letter = letter
    end
  end

  def occupied?
    !letter.nil?
  end

  def empty?
    !occupied?
  end

  def to_s
    return ' ' if letter.nil?

    "#{letter}"
  end

  attr_reader :letter
end
