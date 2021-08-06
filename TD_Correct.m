close all;
clear all;

% Position of the obstacle in the grid 1=obstacle 0=free cell
Grid_Array=  [1,1,1,1,1,1,1,1,1;
            1,0,0,0,0,0,1,0,1;
            1,0,0,0,0,0,1,0,1;
            1,0,0,0,0,0,1,0,1;
            1,0,0,0,0,0,1,0,1;
            1,0,0,0,0,0,0,0,1;
            1,1,1,1,1,1,1,1,1];

% Size of the grid
X_Grid=size (Grid_Array,2);
Y_Grid=size (Grid_Array,1);


% Coordinates of the starting cell
Start=[2,2];

% Coordinates of the goal
Goal=[8,6];

% Draw the grid (draw the obstacles, starting cell and goal
Graphic = Draw_Grid(Grid_Array,Start,Goal);
Robot=Draw_Robot (Start(1),Start(2));


% Parameters
Nb_It=0;                                % Count the number of iterations
Nb_Episodes=1001;                         % Number of episodes

Gamma=0.9999;


% Initialize V(s)=0 for each state
%V=(1-Grid_Array').*zeros(X_Grid,Y_Grid)*0.1;
V=zeros (X_Grid,Y_Grid);
Visit=zeros (X_Grid,Y_Grid);



% Loop for Nb_Episodes
while (Nb_It<Nb_Episodes)

    % Initialize s (Initial state)
    x=Start(1);
    y=Start(2);

    % Repeat for each episode:
    while (x~=Goal(1) | y~=Goal(2))

        a=round(rand*3);
        % 0 = Up
        % 1 = Right
        % 2 = Down
        % 3 = Left

        % Take action a
        X=x; Y=y;
        switch (a)
            case 0, if (Is_Obstacle (x,y-1,Grid_Array)==0) Y=y-1; end  % Up
            case 1, if (Is_Obstacle (x+1,y,Grid_Array)==0) X=x+1; end  % Right
            case 2, if (Is_Obstacle (x,y+1,Grid_Array)==0) Y=y+1; end  % Down
            case 3, if (Is_Obstacle (x-1,y,Grid_Array)==0) X=x-1; end  % Left
        end

        % Old state : x,y
        % New state : X,Y
        Move_Robot(X,Y,Robot);
        drawnow();

        % Observe reward :
        R=-1;

        % Update V
        Alpha=1/(1+Visit(x,y));
        V(x,y)= V(x,y) + Alpha*( R + Gamma*V(X,Y) - V(x,y) );
        Visit(x,y)=Visit(x,y)+1;

        % s <- s'
        x=X;
        y=Y;


    end


figure (2);
Bar3 (-V');
title (sprintf ('Episode %d',Nb_It));
drawnow();


    Nb_It=Nb_It+1;                      % Increments the number of iteration
    if (Nb_It>1010)                     % After 1000 interations, the script is killed
        disp ('Too many interations...');
        return;
    end

    
end


figure (2);
Bar3 (-V');
title (sprintf ('Episode %d',Nb_It));
