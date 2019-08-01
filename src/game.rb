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

    # TODO: extract bag into a LetterBag
    # - add methods: receive_tiles, pop_tiles
    @bag = initialize_word_bag

    @scores = {}
    initialize_scores
    players_draw_letters
  end

  def play
    until game_won?
      players.rotate!

      display_board(current_player: players.first)

      move_attempts = 0
      loop do
        raise "too many failed move attempts. exiting." if move_attempts > 4
        move_attempts += 1

        move = players.first.get_move

        if valid_move?(move)
          apply_move(move)
          break
        else
          puts "invalid move. try again."
        end
      end
    end
  end

  def display_board(current_player:)
    puts "Current player: #{current_player}"
    puts ""
    puts board.render
  end

  private

  attr_reader :board, :players, :scores, :dictionary, :bag

  def initialize_word_bag
    letter_frequencies = {
      'a': 9,
      'b': 2,
      'c': 2,
      'd': 4,
      'e': 12,
      'f': 2,
      'g': 3,
      'h': 2,
      'i': 9,
      'j': 1,
      'k': 1,
      'l': 4,
      'm': 2,
      'n': 6,
      'o': 8,
      'p': 2,
      'q': 1,
      'r': 6,
      's': 4,
      't': 6,
      'u': 4,
      'v': 2,
      'w': 2,
      'x': 1,
      'y': 2,
      'z': 1
    }

    bag = []
    letter_frequencies.each { |letter, freq| freq.times { bag << letter.to_s } }
    bag.shuffle
  end

  def initialize_scores
    players.each do |player|
      scores[player] = 0
    end
  end

  def players_draw_letters
    players.each do |player|
      7.times { player.receive_tiles([bag.pop]) }
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

    mv = MoveValidator.new(move: move, board: board, dictionary: dictionary)
    mv.valid_move?

    @board = mv.instance_variable_get(:@next_board)
  end

  def valid_move?(move)
    MoveValidator
      .new(move: move, board: board, dictionary: dictionary)
      .valid_move?
  end
end
