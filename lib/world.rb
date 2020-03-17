class World
  attr_accessor :width, :height, :square_size

  # width: the width of the window
  # height: the height of the window
  # square_size: the minimum world object (e.g. the snake head, the apply size etc)
  def initialize(width:, height:, square_size:)
    @width = width
    @height = height
    @square_size = square_size
  end

  # Creates an apple at a random location on the board
  def show_apple
    Image.new('images/apple.png',
              x: rand(width-square_size),
              y: rand(height-square_size),
              width: square_size, height: square_size, z: 0)
  end
end
