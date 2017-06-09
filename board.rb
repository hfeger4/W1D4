require "byebug"


class Board
  attr_reader :width, :height, :you_lose

  #all possible adjacencies to a given tile
  ADJ_TYPES = [[-1,-1], [0,-1], [1,-1], [-1,0], [1,0], [-1,1], [0,1], [1,1]]

  def initialize(x = 4, y = 4, mines = 2)
    @grid = Array.new(x){Array.new(y) {Tile.new}}
    @width = x
    @height = y
    @you_lose = false
    populate_mines(mines)
    assign_all_adjacents
  end

  def [](row, col)
    @grid[row][col]
  end

  def []=(row, col, mark)
    @grid[row][col] = mark
  end

  def populate_mines(count)
    if count > width * height
      raise "Invalid mine count."
    end
    while count > 0
      x_pos = rand(width)
      y_pos = rand(height)
      picked_tile = self[x_pos, y_pos]
      unless picked_tile.is_mined
        count -= 1
        picked_tile.is_mined = true
      end
    end
  end

  def reveal(x_pos,y_pos)
    tile = self[x_pos, y_pos]
    if tile.is_mined
      @you_lose = true
      puts "YOU LOSE"
    else
      tile.revealed = true
      if tile.adjacent==0#recursive
        ADJ_TYPES.each do |type|
          working_x, working_y = x_pos, y_pos
          working_x += type.first
          working_y += type.last
          if is_valid_location?(working_x,working_y)
            unless self[working_x,working_y].revealed
              reveal(working_x,working_y)
            end
          end
        end
      end
    end
  end

  def assign_all_adjacents
    @width.times do |x_pos|
      @height.times do |y_pos|
        assign_adjacents(x_pos, y_pos)
      end
    end
  end

  def assign_adjacents(tile_x, tile_y)
    count = 0
    ADJ_TYPES.each do |type|
        working_x, working_y = tile_x, tile_y
        working_x += type.first
        working_y += type.last
        # byebug
      if is_valid_location?(working_x, working_y)
        count += 1 if self[working_x, working_y].is_mined
      end
    end
    self[tile_x, tile_y].adjacent = count
  end

  def is_valid_location?(x_pos, y_pos)
    return false if x_pos < 0 || y_pos < 0
    return false if x_pos >= width || y_pos >= height
    true
  end

  def render
    @grid.each do |row|
      array = row.map{|tile| render_helper(tile)}
      p array.join(" ")
    end
  end

  def win?
    tiles=@grid.flatten
    tiles.each do |tile|
      if tile.revealed==false && tile.is_mined==false
        return false
      end
    end
    puts "Congrats! You win!"
    true
  end

  def render_helper(tile)
    if tile.revealed == false
      tile.is_flagged ? :f : :*
    else
      tile.is_mined ? :m : tile.adjacent
    end
  end

end

class Tile
  attr_accessor :is_mined, :is_flagged, :adjacent, :revealed

  def initialize
    @is_flagged = false
    @is_mined = false
    @revealed = false
  end
end
