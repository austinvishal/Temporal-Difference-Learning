function Cells=Draw_Grid(Grid_Array,Start,Goal)

X_Grid=size (Grid_Array,2);
Y_Grid=size (Grid_Array,1);

for y=1:Y_Grid
    for x=1:X_Grid
        Color='b';
        if (Grid_Array(y,x)==0)     Color='w'; end
        if (Start==[x,y])           Color='g'; end
        if (Goal==[x,y])            Color='r'; end        
            
        Cells(y,x) = patch ([(x-1)*100,x*100,x*100,(x-1)*100] , [(y-1)*-100,(y-1)*-100,y*-100,y*-100],Color);
    end
end