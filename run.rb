require_relative './src/models/game.rb'
require_relative './src/models/board.rb'
require_relative './src/models/random_computer_player.rb'

board = Board.new(width: 15)
players = [
  RandomComputerPlayer.new(board: board),
  RandomComputerPlayer.new(board: board)
]

dictionary = ['aaa', 'bbb', 'aba', 'aa', 'bb', 'ab', 'ba', 'aaaa', 'aabb']
# dictionary = File.readlines('dictionary.txt').map { |line| line.chomp }

game = Game.new(
  board: board,
  players: players,
  dictionary: dictionary
)

game.play
