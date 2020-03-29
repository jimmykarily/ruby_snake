class Snake
  # Speed is defined in pixels. It is the number of pixels the head
  # moves in every invocation of the update loop.
  # TODO: Implement decimal values:
  #   Don't move the snake until a full pixel move is supposed to happen. E.g.
  #   with a speed of 0.5 we should only move the snake 1px in every second
  #   invocation.
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

  # Changes direction only when the new direction is not towards the tail.
  def change_direction(direction)
    if (DIRECTIONS.index(direction) - DIRECTIONS.index(@direction)).abs != 2
      @direction = direction
    end
  end

  # Detects if the snake's head will collide with the tail when moved one more
  # pixel towards the current direction. We check if the pixels of the snake's
  # "face" overlap with any of the pixels of any of the tail elements.
  # NOTE: if our calculations are slow, then consider using "contains?" from
  # the ruby2d library: https://www.ruby2d.com/learn/2d-basics/#contains
  def collision?
    next_x = next_head_x(true)
    next_y = next_head_y(true)

    face_pixels =
      case direction
      when "right"
        (next_y..next_y + head_size).map { |y| [next_x + head_size, y] }
      when "left"
        (next_y..next_y + head_size).map { |y| [next_x, y] }
      when "up"
        (next_x..next_x + head_size).map { |x| [x, next_y] }
      when "down"
        (next_x..next_x + head_size).map { |x| [x, next_y + head_size] }
      end

    body.detect do |tail_part|
      part_pixels = if tail_part.width == 1
        # vertical_part
        (tail_part.y..(tail_part.y + head_size)).map { |y| [tail_part.x, y] }
      else
        # horizontal part
        (tail_part.x..(tail_part.x + head_size)).map { |x| [x, tail_part.y] }
      end

      if (part_pixels & face_pixels).any?
        puts "#{part_pixels} \n collide with \n #{face_pixels} \n on : \n #{part_pixels & face_pixels}"
        true
      else
        false
      end
    end
  end

  def handle_input(input)
    if DIRECTIONS.include?(input)
      change_direction(input)
    elsif input == "space"
      if @speed == 0 # we were paused
        @speed = @speed_save
      else
        @speed_save = @speed
        @speed = 0
      end
    end
  end

  # Calculates the next x coordinate of the head in the update loop, based on
  # the current speed. If force_speed_1 it does the same calculation as if
  # speed was "1". It is used for collision calculation (since in that case
  # we don't want to skip pixels).
  def next_head_x(force_speed_1=false)
    new_x = head.x

    case direction
    when "right"
      new_x = head.x + (force_speed_1 ? 1 : speed)
      new_x = new_x - limit_x if new_x > limit_x
    when "left"
      new_x = head.x - (force_speed_1 ? 1 : speed)
      new_x = new_x + limit_x if new_x < 0
    end

    new_x
  end

  # Calculates the next y coordinate of the head in the update loop, based on
  # the current speed. If force_speed_1 it does the same calculation as if
  # speed was "1". It is used for collision calculation (since in that case
  # we don't want to skip pixels).
  def next_head_y(force_speed_1=false)
    new_y = head.y

    case direction
    when "up"
      new_y = head.y - (force_speed_1 ? 1 : speed)
      new_y = new_y + limit_y if new_y < 0
    when "down"
      new_y = head.y + (force_speed_1 ? 1 : speed)
      new_y = new_y - limit_y if new_y > limit_y
    end

    new_y
  end

  def move_head
    head.x = next_head_x
    head.y = next_head_y

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
