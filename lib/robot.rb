class Robot
    attr_accessor :x, :y, :facing, :name

    def initialize(options={})
        @name = options[:name]
        @x = options[:x]
        @y = options[:y]
        @facing = options[:facing]
    end

    def status
        puts "#{name}: #{x},#{y},#{facing}"
    end

    def move(free_spaces)
        destination = [@x, @y]
        case @facing
        when "NORTH"
            destination[1] += 1
        when "EAST"
            destination[0] += 1
        when "SOUTH"
            destination[1] -= 1
        when "WEST"
            destination[0] -= 1
        else
            puts "invalid command"
        end

        if free_spaces.include? destination
            @x = destination[0]
            @y = destination[1]            
        else
            puts "invalid command: #{name}'s destination is not a valid space"
            return
        end
        destination
    end




end