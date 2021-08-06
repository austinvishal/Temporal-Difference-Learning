% Draw the robot at position x,y
% This function must be called only once 
% during initialization for each robot
% Return a handle on the drawing (for future transformations)
function Handle=Draw_Robot(x,y)
Handle=patch ( -50+x*100+30*cos (0:0.1:2*pi), 50-y*100-30*sin (0:0.1:2*pi), 'r');