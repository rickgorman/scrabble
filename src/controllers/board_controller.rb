require_relative '../models/board'
require_relative '../services/move_validator'

class InvalidMoveException < StandardError; end

class BoardController
  def update(board:, move:, dictionary:)
    move_validator = \
      MoveValidator.new(
        board: board,
        move: move,
        dictionary: dictionary
      )

    # TODO: maybe move this into the model?
    if !move_validator.valid_move?
      raise InvalidMoveException.new("move: #{move}")
    end

    Board.clone_and_apply_move(board: board, move: move)
  end
end
