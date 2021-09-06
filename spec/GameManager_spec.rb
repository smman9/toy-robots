require 'GameManager.rb'

describe 'GameManager' do

    describe 'attributes' do

      it "allows reading for :grid_x" do
        gm = GameManager.new(1,1)
        expect(gm.grid_x).to eq(1)
      end
      
      it "allows reading for :grid_y" do
        gm = GameManager.new(1,1)
        expect(gm.grid_y).to eq(1)
      end

      it "allows reading for :facings" do
        gm = GameManager.new(1,1)
        expect(gm.facings).to eq(["NORTH", "EAST", "SOUTH", "WEST"])
      end

      it "allows reading for :robots" do
        gm = GameManager.new(1,1)
        expect(gm.robots).to be_empty
      end

      it "allows reading for :free_space" do
        gm = GameManager.new(1,1)
        expect(gm.free_spaces).to eq(Set[[0,0]])
      end
      
    end

    describe '#create_grid' do
      it "creates the appropriate amount of free spaces" do
        gm = GameManager.new(2,2)
        expect(gm.free_spaces).to eq(Set[[0,0], [0,1], [1,0], [1,1]])
      end
    end

    describe '#place_robot' do
      it "places a robot on the grid and reports its location" do
        gm = GameManager.new(2,2)
        input_name = "TEST"
        input_array = [1,1,"NORTH"]
        expect { gm.place_robot(input_name, input_array) }.to output("New Robot TEST created at 1, 1, facing NORTH\n").to_stdout
      end

      it "rejects a robot based on name uniqueness" do
        gm = GameManager.new(2,2)
        input_name = "TEST"
        input_array = [1,1,"NORTH"]
        gm.place_robot(input_name, input_array)
        expect { gm.place_robot(input_name, input_array) }.to output("invalid command: robot TEST already exists\n").to_stdout
      end

      it "rejects a robot placed on a space with another robot on it" do
        gm = GameManager.new(2,2)
        input_name = "TEST"
        input_array = [1,1,"NORTH"]
        input_name2 = "TEST2"
        input_array2 = [1,1,"NORTH"]
        gm.place_robot(input_name, input_array)
        expect{ gm.place_robot(input_name2, input_array2) }.to output("invalid command: space 1, 1 is not free\n").to_stdout
      end

      it "rejects a robot placed outside the grid" do
        gm = GameManager.new(2,2)
        input_name = "TEST"
        input_array = [-1,-1,"NORTH"]
        expect { gm.place_robot(input_name, input_array) }.to output("invalid command: space -1, -1 is not free\n").to_stdout
      end
    end

    describe '#robot_status' do
      it "reports a robot's status" do
        gm = GameManager.new(2,2)
        input_name = "TEST"
        input_array = [0,0,"NORTH"]
        gm.place_robot(input_name, input_array)
        expect { gm.robot_status("TEST") }.to output("TEST: 0,0,NORTH\n").to_stdout
      end

      it "does not report on robots that do not exist" do
        gm = GameManager.new(2,2)
        input_name = "TEST"
        input_array = [0,0,"NORTH"]
        gm.place_robot(input_name, input_array)
        expect { gm.robot_status("a") }.to output("invalid command: no such robot exists\n").to_stdout
      end
    end

    describe '#move_robot' do
      it "moves a robot to its destination" do
        gm = GameManager.new(2,2)
        input_name = "TEST"
        input_array = [0,0,"NORTH"]
        gm.place_robot(input_name, input_array)
        gm.move_robot("TEST")
        expect { gm.robot_status("TEST") }.to output("TEST: 0,1,NORTH\n").to_stdout
      end

      it "handles free space appropriately after a robot has moved" do
        gm = GameManager.new(1,2)
        input_name = "TEST"
        input_array = [0,0,"NORTH"]
        gm.place_robot(input_name, input_array)
        expect{ gm.move_robot("TEST") }.to change {gm.free_spaces}.from([[0,1]]).to([[0,0]])
      end

      it "does not attempt to move a robot which does not exist" do
        gm = GameManager.new(2,2)
        input_name = "TEST"
        input_array = [0,0,"NORTH"]
        gm.place_robot(input_name, input_array)
        expect{ gm.move_robot("a") }.to output("invalid command: no such robot exists\n").to_stdout
      end

      it "does not attempt to move a robot into an occupied space" do
        gm = GameManager.new(2,2)
        input_name = "TEST"
        input_array = [0,1,"NORTH"]
        gm.place_robot(input_name, input_array)
        input_name2 = "TEST2"
        input_array2 = [0,0,"NORTH"]
        gm.place_robot(input_name2, input_array2)
        expect{ gm.move_robot("TEST2") }.to output("invalid command: TEST2's destination is not a valid space\n").to_stdout
      end      

    end

    describe "#turn_robot" do
      it "turns a given robot LEFT" do
        gm = GameManager.new(2,2)
        input_name = "TEST"
        input_array = [0,0,"NORTH"]
        gm.place_robot(input_name, input_array)
        gm.turn_robot("TEST", "LEFT")
        expect { gm.robot_status("TEST") }.to output("TEST: 0,0,WEST\n").to_stdout
      end

      it "turns a given robot RIGHT" do
        gm = GameManager.new(2,2)
        input_name = "TEST"
        input_array = [0,0,"NORTH"]
        gm.place_robot(input_name, input_array)
        gm.turn_robot("TEST", "RIGHT")
        expect { gm.robot_status("TEST") }.to output("TEST: 0,0,EAST\n").to_stdout
      end

      it "rejects a non-valid direction" do
        gm = GameManager.new(2,2)
        input_name = "TEST"
        input_array = [0,0,"NORTH"]
        gm.place_robot(input_name, input_array)
        expect{ gm.turn_robot("TEST", "ABOUTFACE") }.to output("invalid command: invalid direction\n").to_stdout
      end

      it "does not attempt to turn a robot that doesn't exist" do
        gm = GameManager.new(2,2)
        expect{ gm.turn_robot("TEST", "LEFT") }.to output("invalid command: no such robot exists\n").to_stdout
      end
    end

    describe "#find_robot_by_name" do
      it "finds a robot that has been created" do
        gm = GameManager.new(2,2)
        input_name = "TEST"
        input_array = [0,0,"NORTH"]
        gm.place_robot(input_name, input_array)
        expect(gm.find_robot_by_name("TEST")).not_to eq(nil)
      end

      it "does not find a robot that has been not created" do
        gm = GameManager.new(2,2)
        input_name = "TEST"
        input_array = [0,0,"NORTH"]
        gm.place_robot(input_name, input_array)
        expect(gm.find_robot_by_name("a")).to eq(nil)
      end

    end

end