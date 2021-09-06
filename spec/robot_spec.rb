require 'robot'
require 'set'

describe 'Robot' do

    describe 'attributes' do
        it "allows reading for :x" do
            robot = Robot.new({name: 'test', x: 0, y: 0, facing:"NORTH"})
            expect(robot.x).to eq(0)
        end

        it "allows reading for :y" do
            robot = Robot.new({name: 'test', x: 0, y: 0, facing:"NORTH"})
            expect(robot.y).to eq(0)
        end

        it "allows reading for :name" do
            robot = Robot.new({name: 'test', x: 0, y: 0, facing:"NORTH"})
            expect(robot.name).to eq('test')
        end

        it "allows reading for :facing" do
            robot = Robot.new({name: 'test', x: 0, y: 0, facing:"NORTH"})
            expect(robot.facing).to eq("NORTH")
        end
    end
    describe '#status' do
        it "correctly reports robot's position" do
            robot = Robot.new({name: 'test', x: 0, y: 0, facing:"NORTH"})
            expect{ robot.status }.to output("test: 0,0,NORTH\n").to_stdout
        end
    end
    
    describe '#move' do
        it "allows movement to the north" do
            robot = Robot.new({name: 'test', x: 0, y: 0, facing:"NORTH"})
            free_spaces = Set[[0,0], [0,1]]
            robot.move(free_spaces)
            expect{ robot.status }.to output("test: 0,1,NORTH\n").to_stdout
        end

        it "allows movement to the south" do
            robot = Robot.new({name: 'test', x: 0, y: 1, facing:"SOUTH"})
            free_spaces = Set[[0,0], [0,1]]
            robot.move(free_spaces)
            expect{ robot.status }.to output("test: 0,0,SOUTH\n").to_stdout
        end

        it "allows movement to the east" do
            robot = Robot.new({name: 'test', x: 0, y: 0, facing:"EAST"})
            free_spaces = Set[[0,0], [1,0]]
            robot.move(free_spaces)
            expect{ robot.status }.to output("test: 1,0,EAST\n").to_stdout
        end

        it "allows movement to the west" do
            robot = Robot.new({name: 'test', x: 1, y: 0, facing:"WEST"})
            free_spaces = Set[[0,0], [1,0]]
            robot.move(free_spaces)
            expect{ robot.status }.to output("test: 0,0,WEST\n").to_stdout
        end

        it "rejects movement to a non-free space" do
            robot = Robot.new({name: 'test', x: 1, y: 1, facing:"NORTH"})
            free_spaces = Set[[0,0],[0,1],[1,0],[1,1]]
            expect{ robot.move(free_spaces) }.to output("invalid command: test's destination is not a valid space\n").to_stdout
        end
    end
end