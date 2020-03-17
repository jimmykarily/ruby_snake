class World
  attr_accessor :width, :height, :square_size, :points, :points_label,
    :apple_x, :apple_y, :apple

  APPLE_POINTS = 10

  # width: the width of the window
  # height: the height of the window
  # square_size: the minimum world object (e.g. the snake head, the apply size etc)
  def initialize(width:, height:, square_size:)
    @width = width
    @height = height
    @square_size = square_size
    @points = 0
    @apple = show_apple
    @points_label = update_points(0)
  end

  def update_points(points)
    if !points_label
      Text.new("Points: #{points}",
        x: square_size, y: square_size,
        font: 'fonts/HappyMonkey-Regular.ttf',
        size: 20,
        color: "#DEC9B9",
        z: 10
      )
    else
      @points_label.text = "Points: #{points}"
    end
  end

  # Creates an apple at a random location on the board
  def show_apple
    @apple_x = rand(width-square_size)
    @apple_y = rand(height-square_size)

    if !apple
      Image.new('images/apple.png', x: apple_x, y: apple_y,
                width: square_size, height: square_size, z: 0)
    else
      apple.x = @apple_x
      apple.y = @apple_y
    end
  end

  # Checks if a square of size square_size would "touch" the apple if it was
  # on the given coordinates.
  # Important: The coordinates define the top left corner of the square
  def close_to_apple?(x, y)
    (apple_x - x).abs <= square_size && (apple_y - y).abs <= square_size
  end

  def eat_the_apple
    show_apple
    update_points(@points += APPLE_POINTS)
  end
end
