#!/usr/bin/env ruby

require_relative 'lib/snake'
require_relative 'lib/world'
require 'ruby2d'

$world = World.new(width: 500, height: 500, square_size: 30)
$snake = Snake.new(limit_x: $world.width,
                   limit_y: $world.height,
                   head_size: $world.square_size)
$world.show_apple

# Set the window size
set width: $world.width, height: $world.height
set title: "Ruby snake!"
set background: '#5B4443'

on :key_up do |event|
  $snake.handle_input(event.key.to_s)
end

update do
  snake_x, snake_y = $snake.move
  if $world.close_to_apple?(snake_x, snake_y)
    $world.eat_the_apple
    $snake.eat_the_apple
  end

  if $snake.collision?
    $snake.speed = 0
    $world.game_over
  end
end

show
