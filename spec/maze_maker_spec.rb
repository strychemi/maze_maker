require 'maze_maker'

describe MazeMaker do

  let(:rows) { 15 }
  let(:cols) { 15 }
  let(:maze) { MazeMaker.new(rows, cols) }

  describe '#initialize' do
    it 'initializes an 2D array with proper input dimensions' do
      r = maze.instance_variable_get(:@maze).length
      c = maze.instance_variable_get(:@maze)[0].length
      expect(r).to eq(rows)
      expect(c).to eq(cols)
    end
  end

  describe '#generate_paths' do
    it 'takes valid starting coords as arguments'
    it 'generates a valid maze'
  end
end
