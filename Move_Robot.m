% Redraw the robot at coordinates x,y
function Move_Robot (x,y,Handle)

set (Handle,'XData',-50+x*100+30*cos (0:0.1:2*pi));
set (Handle,'YData', 50-y*100-30*sin (0:0.1:2*pi));