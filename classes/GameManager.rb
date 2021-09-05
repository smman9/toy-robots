require 'set'
require_relative 'robot'

class GameManager
    attr_reader :grid_x, :grid_y

    def initialize(x, y)
        @grid_x = x
        @grid_y = y
        @COMMANDS = ["PLACE", "MOVE", "LEFT", "RIGHT", "REPORT", "EXIT"]
        @FACINGS = ["NORTH", "EAST", "SOUTH", "WEST"]
        @robots = []
        @free_spaces = Set.new()
    end

    def create_grid
        0.upto(grid_x - 1) do |i|
            0.upto(grid_y - 1) do |j|
                @free_spaces.add([i,j])
            end
        end
    end

    def evaluate_command(command_array)
        #command_array should look like [NAME:, COMMAND, (COORDS+FACING)]
        #TODO: consider breaking into methods?
        name = command_array[0].chomp.delete_suffix!(":")
        command_operator = command_array[1]

        case command_operator
        when "PLACE"
            robot_array = command_array[2].delete(" ").split(",")
            robot_x = robot_array[0].to_i
            robot_y = robot_array[1].to_i
            if @free_spaces.include?([robot_x, robot_y])
                new_robot = Robot.new({name: name, x: robot_x, y: robot_y, facing:robot_array[2]})
                @robots.push(new_robot)
                @free_spaces.delete([robot_x, robot_y])
                puts "New Robot #{name} created at #{robot_x}, #{robot_y}, facing #{robot_array[2]}"    
            else
                puts "invalid command: space #{robot_x}, #{robot_y} is not free"
            end 

        when "MOVE"
            target_robot = find_robot_by_name(name)
            if target_robot != nil
                old_location = [robot.x, robot.y]
                new_location = target_robot.move_robot(@free_spaces)
                if new_location != nil
                    @free_spaces.delete(new_location)
                    @free_spaces.push(old_location) 
                end
            end

        when "REPORT"
            target_robot = find_robot_by_name(name)
            if target_robot != nil
                target_robot.status
            end
            
        #TODO: rework movement to be more extensible. this shit WET
        when "LEFT"
            target_robot = find_robot_by_name(name)
                if target_robot != nil
                    i = @FACINGS.find_index(target_robot.facing)
                    new_facing = @FACINGS[(i-1) % @FACINGS.length]
                    target_robot.facing = new_facing
                end 

        when "RIGHT"
            target_robot = find_robot_by_name(name)
                if target_robot != nil
                    i = @FACINGS.find_index(target_robot.facing)
                    new_facing = @FACINGS[(i+1) % @FACINGS.length]
                    target_robot.facing = new_facing
                end 

        else
            puts "invalid command"
        end
    end

    def index_of_robot(name)
        @robots.index { |robot| robot.name == name}
    end

    def find_robot_by_name(name)
        robot = @robots.find { |robot| robot.name == name}
        if robot == nil
            puts "invalid command: no such robot exists"
        else
            robot
        end
    end

end
