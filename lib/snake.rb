class Snake
  attr_accessor :body, :direction, :speed, :limit_x, :limit_y

  HEAD_SIZE=20

  DIRECTIONS = {
    "up" => 0,
    "right" => 1,
    "down" => 2,
    "left" => 3
  }

  # Creates a new snake at x, y.
  # Initially the snake moves downwards
  def initialize(limit_x, limit_y)
    head = Square.new(size: HEAD_SIZE, x: limit_x / 2, y: limit_y /2)
    head.color = 'red'
    @body = [head]
    @limit_x = limit_x
    @limit_y = limit_y
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
      body[0].y = body[0].y + limit_y if body[0].y < 0
    when "down"
      body[0].y = body[0].y + speed
      body[0].y = body[0].y - limit_y if body[0].y > limit_y
    when "right"
      body[0].x = body[0].x + speed
      body[0].x = body[0].x - limit_x if body[0].x > limit_x
    when "left"
      body[0].x = body[0].x - speed
      body[0].x = body[0].x + limit_x if body[0].x < 0
    end
  end
end
