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
	
	def place_robot(name, coord_array)
		robot_x = coord_array[0].to_i
		robot_y = coord_array[1].to_i
		if @free_spaces.include?([robot_x, robot_y])
			new_robot = Robot.new({name: name, x: robot_x, y: robot_y, facing:coord_array[2]})
			@robots.push(new_robot)
			@free_spaces.delete([robot_x, robot_y])
			puts "New Robot #{name} created at #{robot_x}, #{robot_y}, facing #{coord_array[2]}"    
		else
			puts "invalid command: space #{robot_x}, #{robot_y} is not free"
		end
	end

	def move_robot(name)
		target_robot = find_robot_by_name(name)
		if target_robot != nil
			old_location = [target_robot.x, target_robot.y]
			new_location = target_robot.move(@free_spaces)
			if new_location != nil
				@free_spaces.delete(new_location)
				@free_spaces.add(old_location) 
			end
		end
	end

	def robot_status(name)
		target_robot = find_robot_by_name(name)
		if target_robot != nil
			target_robot.status
		end
	end

	def turn_robot(name, direction)
		target_robot = find_robot_by_name(name)
		#switch in case we want different directions in the future, like turn around 
		if target_robot != nil
			i = @FACINGS.find_index(target_robot.facing)
			case direction
			when "LEFT"
				i -= 1
			when "RIGHT"
				i += 1
			else
				puts "invalid command: invalid direction"
			end
			new_facing = @FACINGS[(i) % @FACINGS.length]
			target_robot.facing = new_facing		
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
