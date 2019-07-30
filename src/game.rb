require_relative './board.rb'
require_relative './human_player.rb'


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

      display_board

      move = players.first.get_move
      apply_move(move) if valid_move?(move)
    end
  end

  def display_board
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
    puts "implement me!"
  end

  def valid_move?(move)
    true
  end
end
