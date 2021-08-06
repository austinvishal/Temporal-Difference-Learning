% Return true if there is an obstacle at coordinates x,y
function Bool=Is_Obstacle (x,y,Grid_Array)
    Bool=Grid_Array(y,x);