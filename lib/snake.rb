class Snake
  attr_accessor :head, :body, :direction, :speed, :speed_save, :head_size,
    :limit_x, :limit_y, :apples_eaten

  DIRECTIONS = ["up","right","down","left"]

  APPLE_SPEED_BOOST = 1
  APPLE_SPEED_BOOST_THRESHOLD = 10 # How many apples should the snake eat before a speed boost happens
  SNAKE_HEAD_COLOR="#DEC9B9"
  SNAKE_TAIL_COLOR="white"
  TAIL_GROW_PIXELS=8 # number of pixels to grow tail after eating an apple

  # Creates a new snake at x, y.
  # Initially the snake moves downwards
  def initialize(limit_x:, limit_y:, head_size:)
    @head = Square.new(size: head_size, x: limit_x / 2,
                      y: limit_y / 2, z: 1, color: SNAKE_HEAD_COLOR)
    @body = []
    @limit_x = limit_x
    @limit_y = limit_y
    @speed = @speed_save = 1
    @head_size = head_size
    @apples_eaten = 0
    @grow_tail_pixels=0

    @direction = "down"
  end

  # TODO: Don't change the direction when new_direction
  # is towards the snake's tale.
  def handle_input(input)
    if DIRECTIONS.include?(input)
      @direction = input
    elsif input == "space"
      if @speed == 0 # we were paused
        @speed = @speed_save
      else
        @speed_save = @speed
        @speed = 0
      end
    end
  end

  def move_head
    case direction
    when "up"
      head.y = head.y - speed
      head.y = head.y + limit_y if head.y < 0
    when "down"
      head.y = head.y + speed
      head.y = head.y - limit_y if head.y > limit_y
    when "right"
      head.x = head.x + speed
      head.x = head.x - limit_x if head.x > limit_x
    when "left"
      head.x = head.x - speed
      head.x = head.x + limit_x if head.x < 0
    end

    return head.x, head.y
  end

  # Remove "speed" number of elements from the end of the body and
  # add the same number of elements at the start of the body (correctly oriented
  # according to the current direction)
  def move_tail
    ([speed,[body.length,@grow_tail_pixels].max].min).times do |i|
      body.unshift(
        case direction
        when "up"
          Rectangle.new(
            x: head.x, y: (head.y+head_size) + i,
            width: head_size, height: 1, color: SNAKE_TAIL_COLOR,
            z: 1)
        when "down"
          Rectangle.new(
            x: head.x, y: head.y - (i+1),
            width: head_size, height: 1, color: SNAKE_TAIL_COLOR,
            z: 1)
        when "right"
          Rectangle.new(
            x: head.x - (i+1), y: head.y,
            width: 1, height: head_size, color: SNAKE_TAIL_COLOR,
            z: 1)
        when "left"
          Rectangle.new(
            x: (head.x+head_size) + i , y: head.y,
            width: 1, height: head_size, color: SNAKE_TAIL_COLOR,
            z: 1)
        end
      )
    end

    if speed > @grow_tail_pixels
      body.pop(speed - @grow_tail_pixels).each{|element| element.remove}
      @grow_tail_pixels = 0
    else
      @grow_tail_pixels = @grow_tail_pixels - speed
    end
  end

  def move
    return [head.x, head.y] if @speed == 0 # We are paused

    new_head_location = move_head
    move_tail

    new_head_location
  end

  # Increase the speed by APPLE_SPEED_BOOST every APPLE_SPEED_BOOST_THRESHOLD apples
  def adjust_speed
    @speed = (@apples_eaten / APPLE_SPEED_BOOST_THRESHOLD) + APPLE_SPEED_BOOST
  end

  def adjust_tail
    @grow_tail_pixels=TAIL_GROW_PIXELS
  end

  def eat_the_apple
    @apples_eaten += 1
    adjust_speed
    adjust_tail
  end
end
