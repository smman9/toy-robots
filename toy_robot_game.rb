#!/usr/bin/env ruby
require 'set'
require_relative 'classes/robot'
require_relative 'classes/GameManager.rb'

size_x = 6
size_y = 6

game_manager = GameManager.new(size_x, size_y)
game_manager.create_grid

while true
    puts "Enter Command:"

    input = gets.chomp
    exit if input.include? "EXIT"
    
    input_array = input.split(" ")

    if input_array.length > 3
        puts "invalid command: too many arguments"
    end

    game_manager.evaluate_command(input_array)
end