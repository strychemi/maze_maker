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
    # random_paths is array of randomly generated moves for current location
    random_paths = [N, E, S, W].shuffle
    # for each direction
    random_paths.each do |direction|
      # generate the new coordinates
      nr, nc = row + DROW[direction], col + DCOL[direction]
      # check if the coord is valid (within grid and not visited yet)
      if valid_coord?(nr, nc)
        # binary OR operator to record the wall that needs to be open to move
        @maze[row][col] |= direction
        # appropriate wall needs to be open FROM the old cell
        @maze[nr][nc] |= FROM[direction]
        # recursive call to repeat this whole process
        generate_paths(nr, nc)
      end
    end
  end

  def valid_coord?(row, col)
    row.between?(0, @rows - 1) && col.between?(0, @cols - 1) && @maze[row][col] == 0
  end

  def render
    # since we are print from top left to bottom right,
    # we only need to consider/check the presence of East and South walls
    # for instance, if you printed an East wall for a current cell
    # then  moved right to a new cell,
    # you don't need to consider checking the West wall of the new cell
    puts (" " + "_") * @cols # prints upper boundary of maze
    @rows.times do |row|
      print "|" # prints each row starting from the left
      @cols.times do |col|
        cell = @maze[row][col]
        # use binary AND operator to check presence for South wall
        # if South wall is open, print " ", else print "_"
        print cell & S != 0 ? " " : "_"
        # check presence for east wall
        if cell & E != 0
          # if East wall is open, check if adjacent cell has an open south wall
          # if so
          print (cell | @maze[row][col+1] & S != 0) ? " " : "_"
        else
          # otherwise print East wall
          print "|"
        end
      end
      puts
    end
  end

  def render_values
    @rows.times do |row|
      @cols.times do |col|
        print "#{@maze[row][col]}".ljust(3)
      end
      puts
    end
  end
end

game = MazeMaker.new(10, 10)
game.generate_paths(0, 0)
game.render_values
game.render
