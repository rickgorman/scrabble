require_relative './board.rb'
require_relative './human_player.rb'
require_relative './move_validator.rb'


class Game
  def initialize(
    board: Board.new,
    players: [
      HumanPlayer.new(board: board),
      HumanPlayer.new(board: board)
    ],
    dictionary: ['aaa', 'bbb', 'aba', 'aa', 'bb']
  )
    @board = board
    @players = players
    @dictionary = dictionary

    @scores = {}
    initialize_scores
  end

  def play
    until game_won?
      players.rotate!

      display_board(current_player: players.first)

      move = players.first.get_move

      apply_move(move) if valid_move?(move)
    end
  end

  def display_board(current_player:)
    puts "Current player: #{current_player}"
    puts ""
    puts board.render
  end

  private

  attr_reader :board, :players, :scores, :dictionary

  def initialize_scores
    players.each do |player|
      scores[player] = 0
    end
  end

  def game_won?
    # play 6 turns
    @win_condition ||= 6
    @win_condition -= 1
    @win_condition == 0
  end

  def apply_move(move)
    # TODO: extract the next_board method out into a MoveController, or possibly
    #  into the Board class. I'm a bit concerned about Board knowing about Move.
    #  Does a Board Move things, or does a DungeonMaster-like controller take
    #  charge and perform the moving?

    @board = MoveValidator
              .new(move: move, board: board, dictionary: dictionary)
              .instance_variable_get(:@next_board)
  end

  def valid_move?(move)
    MoveValidator
      .new(move: move, board: board, dictionary: dictionary)
      .valid_move?
  end
end

Game.new.play
