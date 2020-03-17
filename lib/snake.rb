class Snake
  attr_accessor :body, :direction, :speed, :head_size, :limit_x, :limit_y,
    :apples_eaten

  DIRECTIONS = {
    "up" => 0,
    "right" => 1,
    "down" => 2,
    "left" => 3
  }

  APPLE_SPEED_BOOST = 1
  APPLE_SPEED_BOOST_THRESHOLD = 10 # How many apples should the snake eat before a speed boost happens

  # Creates a new snake at x, y.
  # Initially the snake moves downwards
  def initialize(limit_x:, limit_y:, head_size:)
    head = Square.new(size: head_size, x: limit_x / 2, y: limit_y /2, z: 1,
                      color: "#DEC9B9")
    @body = [head]
    @limit_x = limit_x
    @limit_y = limit_y
    @speed = 1
    @head_size = head_size
    @apples_eaten = 0

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

    return body[0].x, body[0].y
  end

  # Increase the speed by APPLE_SPEED_BOOST every APPLE_SPEED_BOOST_THRESHOLD apples
  def adjust_speed
    @speed = (@apples_eaten / APPLE_SPEED_BOOST_THRESHOLD) + APPLE_SPEED_BOOST
  end

  def eat_the_apple
    @apples_eaten += 1
    adjust_speed
    # TODO: add to the tale
  end
end
