require_relative '../models/board.rb'
require_relative '../models/random_computer_player.rb'
require_relative '../services/move_validator.rb'
require_relative '../controllers/board_controller.rb'

class Game
  MAX_MOVE_ATTEMPTS = 10000

  def initialize(
    board: Board.new,
    players: [
      RandomComputerPlayer.new(board: board),
      RandomComputerPlayer.new(board: board)
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
      current_player = players.first

      display_board(current_player: current_player)

      move_attempts = 0
      loop do
        raise "too many failed move attempts. exiting." if move_attempts > MAX_MOVE_ATTEMPTS
        move_attempts += 1

        move = current_player.get_move

        begin
          apply_move(move)
          display_move(current_player: current_player, move: move)

          current_player.drop_tiles(move.letters)
          current_player.receive_tiles(bag.pop(move.length))

          break
        rescue => e
          # puts "invalid move. try again. #{e.message}"
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
    @board = BoardController.update(
      board: board,
      move: move,
      dictionary: dictionary
    )
  end

  def display_move(current_player:, move:)
    puts "Player #{current_player} is playing"
  end

  def valid_move?(move)
    MoveValidator
      .new(move: move, board: board, dictionary: dictionary)
      .valid_move?
  end
end
