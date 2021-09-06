# toy-robots
A submission for Active Pipe's coding challenge

## Assumptions
* Robot names must be unique.
* Robot names are case sensitive, but commands and facings are not.

## Design notes
* Could certainly improve error handling. While if statements work for now for readability's sake, they should be refactored to proper exception handling
* Chose console input for ease of manual testing. For automated testing, however, text input should be included
* When operating with a robot, all it cares about is free spaces, which we feed to it. That way, the robot does not need to know about the dimensions of the grid or existance of other robots. The trade-off is that this operation gets more expensive the more robots there are and the larger the grid is.

## Additional commands
* EXIT: exits the program.

## Local

### Requirements
You will need at ruby version 3.0.2
check ruby version by using ruby -v

### Running
ruby init.rb