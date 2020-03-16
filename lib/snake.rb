class Snake
  attr_accessor :body, :direction, :speed

  DIRECTIONS = {
    "up" => 0,
    "right" => 1,
    "down" => 2,
    "left" => 3
  }

  # Creates a new snake at x, y.
  # Initially the snake moves downwards
  def initialize(head_size)
    head = Square.new(size: head_size)
    head.color = 'red'
    @body = [head]
    @speed = 1

    @direction = DIRECTIONS["down"]
  end

  # TODO: Don't change the direction when new_direction
  # is towards the snake's tale.
  def set_direction(direction)
    if new_direction = DIRECTIONS[direction]
      puts "Setting direction to #{direction}"
      @direction = new_direction
    end
  end

  def move
    case Snake::DIRECTIONS.invert[$snake.direction]
    when "up"
      body[0].y = body[0].y - speed
    when "down"
      body[0].y = body[0].y + speed
    when "right"
      body[0].x = body[0].x + speed
    when "left"
      body[0].x = body[0].x - speed
    end
  end
end
