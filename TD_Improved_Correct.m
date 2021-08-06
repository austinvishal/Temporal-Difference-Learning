close all;
clear all;

% Position of the obstacle in the grid 1=obstacle 0=free cell
Grid_Array=  [1,1,1,1,1,1,1,1,1;
             1,0,0,0,0,0,1,0,1;
             1,0,0,0,1,0,1,0,1;
             1,0,0,0,1,0,1,0,1;
             1,1,1,1,1,0,1,0,1;
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
Nb_It=1;                                % Count the number of iterations
Nb_Episodes=100;                         % Number of episodes

Gamma=0.999;
Alpha=0.5;


% Initialize V(s)=0 for each state
V=(1-Grid_Array').*rand(X_Grid,Y_Grid);
Visit=zeros (X_Grid,Y_Grid);


pause
% Loop for Nb_Episodes
while (Nb_It<Nb_Episodes)
    
    % Initialize s (Initial state)
    x=Start(1);
    y=Start(2);
    
    CumulatedReward(Nb_It)=0;
    
    % Repeat for each episode:
    while (x~=Goal(1) | y~=Goal(2))
        
    
        if (rand>(Nb_It/Nb_Episodes))
            
            % randomly select an action            
            a=round(rand*3);        % 0 = Up
                                    % 1 = Right
                                    % 2 = Down
                                    % 3 = Left
        else
            
           % Take the best known action
           if (Is_Obstacle (x,y-1,Grid_Array)==1) VUp   =V(x,y); else VUp    =V(x,y-1); end
           if (Is_Obstacle (x+1,y,Grid_Array)==1) VRight=V(x,y); else VRight =V(x+1,y); end
           if (Is_Obstacle (x,y+1,Grid_Array)==1) VDown =V(x,y); else VDown  =V(x,y+1); end           
           if (Is_Obstacle (x-1,y,Grid_Array)==1) VLeft =V(x,y); else VLeft  =V(x-1,y); end           
           
           switch (max ([VUp;VRight;VDown;VLeft])) 
               case VUp    , a=0;
               case VRight , a=1;
               case VDown  , a=2;
               case VLeft  , a=3;                   
           end           
        end
                
            
        % Take action a
        % Old state : x,y
        % New state : X,Y
        X=x; Y=y;
        switch (a)
            case 0, if (Is_Obstacle (x,y-1,Grid_Array)==0) Y=y-1; end  % Up
            case 1, if (Is_Obstacle (x+1,y,Grid_Array)==0) X=x+1; end  % Right
            case 2, if (Is_Obstacle (x,y+1,Grid_Array)==0) Y=y+1; end  % Down
            case 3, if (Is_Obstacle (x-1,y,Grid_Array)==0) X=x-1; end  % Left        
        end
                
        % Observe reward : 
        R=-1;

        % For plotting
        CumulatedReward(Nb_It)=CumulatedReward(Nb_It)+R;

        % Update V
        
        % ------ Improvement -----
        Alpha=1/(1+Visit(x,y));
        Visit(x,y)=Visit(x,y)+1;
        % ------ Improvement -----        
        V(x,y)=V(x,y)+Alpha*( R + Gamma*V(X,Y) - V(x,y) );
        
        
        % s <- s'
        x=X;
        y=Y;
        
        % Update the position of the robot on the graphic
        figure (1);
        Move_Robot(x,y,Robot);
        pause (0.01);
        drawnow();
       
    end
    

    figure (2);
    Bar3 (-V');
    title (sprintf ('V for Episode %d',Nb_It));

    
    figure (3);
    plot (CumulatedReward);
    xlabel ('Episodes');
    ylabel ('Cumulated reward');
    title ('Cumulated reward for each episode');
    drawnow();    
    
    Nb_It=Nb_It+1;                      % Increments the number of iteration
    if (Nb_It>1000)                     % After 1000 interations, the script is killed
        disp ('Too many interations...');
        return; 
    end         
end  