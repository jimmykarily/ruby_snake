#!/usr/bin/env ruby

require_relative 'lib/snake'
require_relative 'lib/world'
require 'ruby2d'

$world = World.new(500, 500)
$snake = Snake.new($world.width, $world.height)

# Set the window size
set width: $world.width, height: $world.height

on :key_up do |event|
  $snake.set_direction(event.key.to_s)
end

update do
  $snake.move()
end

show
