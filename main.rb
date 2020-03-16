#!/usr/bin/env ruby

require_relative 'lib/snake'
require 'ruby2d'

BOARD_WIDTH=500
BOARD_HEIGHT=500
SNAKE_HEAD_SIZE=20

# Set the window size
set width: BOARD_WIDTH, height: BOARD_HEIGHT

$snake = Snake.new(SNAKE_HEAD_SIZE)

on :key_up do |event|
  $snake.set_direction(event.key.to_s)
end

update do
  $snake.move()
end

show
