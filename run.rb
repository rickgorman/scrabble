require_relative './src/game.rb'

board = Board.new(width: 7)
players = [
  HumanPlayer.new(board: board),
  HumanPlayer.new(board: board)
]

dictionary = ['aaa', 'bbb', 'aba', 'aa', 'bb']

game = Game.new(
  board: board,
  players: players,
  dictionary: dictionary
)

game.play
