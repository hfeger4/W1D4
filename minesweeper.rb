require_relative "board"
require "byebug"

class Minesweeper

  attr_accessor :board

  def initialize
    @board = Board.new
  end

  def run
    until board.win? || board.you_lose
      board.render
      play_turn
    end
  end

  def play_turn
    puts "Do you want to flag or move?"
    answer = gets.chomp.downcase
    flag if answer == "flag"
    move if answer == "move"
  end

  def move
    puts "Which tile do you want to move on."
    tile_pos = get_user_pick
    board.reveal(tile_pos.first,tile_pos.last)
  end

  def flag
    puts "Which tile do you want to flag?"
    tile_pos = get_user_pick
    tile = board[tile_pos.first, tile_pos.last]
    tile.is_flagged = true unless tile_pos.nil?
  end

  def get_user_pick
    tile_pos = gets.chomp
    tile_pos = parse_pos(tile_pos)
    puts "That is not a valid tile location!" if tile_pos == nil
    tile_pos
  end

  def parse_pos(string)
    pos_array = string.split(",").map{|el| Integer(el)}
    return nil if pos_array.length != 2
    return nil unless pos_array.all?{|el| board.is_valid_location?(pos_array.first,pos_array.last)}
    pos_array
  end


end



game=Minesweeper.new
game.run
