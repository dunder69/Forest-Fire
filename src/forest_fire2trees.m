% Forest fire 
% Original code from: http://rosettacode.org/wiki/Forest_fire#MATLAB_.2F_Octave
% Modified by Paolo Macias

% Mode 1 = Biomass
% Mode 2 = Longevity

function [tree1Fitness, tree2Fitness] = forest_fire2trees(f,p1,p2,N,M,mode)

timeStepCap = 5000;
longevity = timeStepCap;
biomassArrayTree1 = [];
biomassArrayTree2 = [];

% Set default parameters if not provided
if nargin<6;
    mode=1;
end

if nargin<5;
    M=250;
end

if nargin<4;
    N=250;
end

if nargin<3;
    p1=.05;
end

if nargin<2;
    p1=.03;
end

if nargin<1;
    f=0.01;
end

% initialize empty space
F = ones(M,N);

colormap([0,0,0;0,1,0;.05,.3,0;0.937,0.451,0]);

% 1 = Barren, Tree will only grow on barren spot
% 2 = Tree species 1
% 3 = Tree species 2
% 4 = Burning

for i=0:timeStepCap
    image(F); pause(.1)
    G=F;
    for m=1:M
        for n=1:N
            % If bare (1)
            if F(m,n) == 1
                % randomly select which species gets a change to grow first
                if rand < .5
                    % Species 1 gets a chance first
                    if rand < p1
                        G(m,n) = 2;
                    elseif rand < p2
                        G(m,n) = 3;
                    end    
                else
                    % Species 2 gets a chance first
                    if rand < p2
                        G(m,n) = 3;
                    elseif rand < p1
                        G(m,n) = 2;
                    end
                end
            end
            
            % If tree (2)
            if F(m,n) == 2 || F(m,n) == 3
                
                % Then catch on fire based on probability f
                if rand < f
                    G(m,n) = 4;
                end
            end
            
            %If on fire
            if F(m,n) == 4
              %Set surrounding trees on fire (with boundry checks) 
              if(m-1 > 0 && n+1 <= N && (F(m-1,n+1) == 2 || F(m-1,n+1) == 3)) %NW
                  G(m-1,n+1) = 4;
              end
              if(n+1 <= N && (F(m,n+1) == 2 || F(m,n+1) == 3)) %N
                  G(m,n+1) = 4;
              end
              if(m+1 <=M && n+1 <= N && (F(m+1,n+1) == 2 || F(m+1,n+1) == 3))%NE
                  G(m+1,n+1) = 4;
              end
              
              if(m-1 > 0 && (F(m-1,n) == 2 || F(m-1,n) == 3)) %W
                  G(m-1,n) = 4;
              end
              if(m+1 <= M && (F(m+1,n) == 2 || F(m+1,n) == 3)) %E
                  G(m+1,n) = 4;
              end
              
              if(m-1 > 0 && n-1 > 0 && (F(m-1,n-1) == 2 || F(m-1,n-1) == 3)) %SW
                  G(m-1,n-1) = 4;
              end
              if(n-1 > 0 && (F(m,n-1) == 2 || F(m,n-1) == 3)) %S
                  G(m,n-1) = 4;
              end
              if(m+1 <=M && n-1 > 0 && (F(m+1,n-1) == 2 || F(m+1,n-1) == 3))%SE
                 G(m+1,n-1) = 4;
              end
              
              %Estinguish and go bare
              G(m,n) = 1;
            end
        end
    end
    F=G;
    
    %If Biomass Mode
    if mode == 1
        %Check if bare/ calculate biomass
        [currentBiomassTree1, currentBiomassTree2] = biomassCheck2trees(F);
    
        %Filling biomass array with percentage of trees occupied
        biomassArrayTree1 = [biomassArrayTree1;currentBiomassTree1];
        biomassArrayTree2 = [biomassArrayTree2;currentBiomassTree2];
    
    %If Longevity Mode
    elseif mode == 2
        bare = longevityCheck2trees(F);
        if bare == true
            longevity = i;
            break;
        end
    end
end;


%If Biomass Mode
if mode == 1
    tree1Fitness = mean(biomassArrayTree1);
    tree2Fitness = mean(biomassArrayTree2);
%If Longevity Mode
elseif mode == 2
    tree1Fitness = longevity;
    tree2Fitness = longevity;
end
    