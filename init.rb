#!/usr/bin/env ruby
require 'set'
require_relative 'lib/robot'
require_relative 'lib/GameManager.rb'

size_x = 6
size_y = 6

game_manager = GameManager.new(size_x, size_y)

while true
    puts "Enter Command:"

    input = gets.chomp
    exit if input.include? "EXIT"
    
    input_array = input.split(" ")

    if input_array.length > 3 || input_array.length <= 1
        puts "invalid command: argument error"
        next
    end

    name = input_array[0].chomp.delete_suffix!(":")
    command_operator = input_array[1].upcase
    case command_operator
    when "PLACE"
        if input_array.length <= 2
            puts "invalid command: too few arguments for PLACE"
        else
            coord_array = input_array[2].delete(" ").split(",")
            game_manager.place_robot(name, coord_array)
        end
    when "MOVE"
        game_manager.move_robot(name)
    when "REPORT"
        game_manager.robot_status(name)
    when "LEFT", "RIGHT"
        game_manager.turn_robot(name, command_operator)
    else
        puts "invalid command"
    end
end