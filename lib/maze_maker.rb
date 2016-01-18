class MazeMaker
  # -------------------------------------------------------------
  # Maze is constructed using Binary representation (i.e. bit math):
  #
  # [0, 0] represents top left of 2D array
  # a cell with a value of 0 has all 4 walls (2^0 or 0000)
  # a cell with a value of 1 has it's North wall open (2^1 or 0001)
  # a cell with a value of 2 has it's East wall open (2^2 or 0010)
  # a cell with a value of 4 has it's South wall open (2^3 or 0100)
  # a cell with a value of 8 has it's West wall open (2^4 or 1000)
  #
  # a cell can have multiple walls open
  # For example: 12 represents South and West wall open (1100)
  # and a 15 represents a cell with no walls at all (1111)
  # Visually, a cell with 1 indicates something that looks like |_| (0001)
  # or cell with 5 indicates something that could like | | (0101)
  # -------------------------------------------------------------

  N, E, S, W = 1, 2, 4, 8
  DROW = { N => -1, E => 0, S => 1, W => 0 }
  DCOL = { N => 0, E => 1, S => 0, W => -1 }
  FROM = { N => S, E => W, S => N, W => E }


  def initialize(rows, cols)
    @rows = rows
    @cols = cols
    @maze = Array.new(@rows) { Array.new(@cols, 0) }
  end

  def generate_paths(row, col)
    random_paths = [N, E, S, W].shuffle
    random_paths.each do |direction|
      nr, nc = row + DROW[direction], col + DCOL[direction]

      if valid_coord?(nr, nc)
        @maze[row][col] |= direction
        @maze[nr][nc] |= FROM[direction]
        generate_paths(nr, nc)
      end

    end

  end

  def valid_coord?(row, col)
    row.between?(0, @rows - 1) && col.between?(0, @cols - 1) && @maze[row][col] == 0
  end

  def render
    puts (" " + "_") * @cols
    @rows.times do |row|
      print "|"
      @cols.times do |col|
        cell = @maze[row][col]
        print cell & S != 0 ? " " : "_"
        if cell & E != 0
          print (cell | @maze[row][col+1] & S != 0) ? " " : "_"
        else
          print "|"
        end
      end
      puts
    end
  end

  def render_values
    @rows.times do |row|
      @cols.times do |col|
        print "#{@maze[row][col]}\t"
      end
      puts
    end
  end
end

game = MazeMaker.new(10, 10)
game.generate_paths(0, 0)
game.render_values
game.render
