#!/usr/bin/env ruby

require_relative 'lib/snake'
require_relative 'lib/world'
require 'ruby2d'

$world = World.new(width: 500, height: 500, square_size: 20)
$snake = Snake.new(limit_x: $world.width,
                   limit_y: $world.height,
                   head_size: $world.square_size)
$world.show_apple

# Set the window size
set width: $world.width, height: $world.height
set title: "Ruby snake!"
set background: '#5B4443'

on :key_up do |event|
  $snake.set_direction(event.key.to_s)
end

update do
  $snake.move()
end

show
