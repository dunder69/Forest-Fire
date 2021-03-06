% Forest fire
% Original code from: http://rosettacode.org/wiki/Forest_fire#MATLAB_.2F_Octave
% Modified by Paolo Macias

% Mode 1 = Biomass
% Mode 2 = Longevity

function returnArray = firefighters(f, p, N, M, mode)

timeStepCap = 5000;
longevity = timeStepCap;
biomassArray = [];
returnArray = [];
firefighterCount = 50:50:1000;
% Set default parameters if not provided
if nargin < 5;
    mode = 1;
end

if nargin < 4;
    M = 250;
end

if nargin < 3;
    N = 250;
end

if nargin < 2;
    p = .03;
end

if nargin < 1;
    f = 0.01;
end


colormap([0, 0, 0; 0, 1, 0; 0.937,0.451,0;0.01,0.424,0.925]);

% 1 = Barren, Tree will only grow on barren spot
% 2 = Tree
% 3 = Burning
% 4 = Just Extinguished by Fire Fighter
for j = 1:length(firefighterCount)
    firefighterCount(j)
    % initialize empty space
F = ones(M, N);
biomassArray = [];

    for i = 0:timeStepCap
        image(F); pause(.1)
        G = F;
        fires = [];
        for m = 1:M
            for n = 1:N
                %If on fire
                if F(m, n) == 3
                    fires = [fires, m, n];
                end
            end
        end
        
        %Firefighters 
        if length(fires)/2 > firefighterCount(j)
            perm = randperm(length(fires) / 2);
            for k = 1:length(perm)
                loc = perm(k)-1;
                G(fires(loc*2+1), fires(loc*2+2)) = 4;
            end
        else
            for k = 0:length(fires)/2-1
                G(fires(k*2+1), fires(k*2+2)) = 4;
            end
        end
     
        for m = 1:M
            for n = 1:N
                % If bare (1)
                if F(m, n) == 1
                    % Then grow a tree based on probability p
                    if rand < p
                        G(m, n) = 2;
                    end
                end
             
                % If tree (2)
                if F(m, n) == 2
                 
                    % Then catch on fire based on probability f
                    if rand < f
                        G(m, n) = 3;
                    end
                end
             
                %If on fire
                if F(m, n) == 3
                        %Set surrounding trees on fire (with boundry checks)
                        if (m - 1 > 0 && n + 1 <= N && F(m - 1, n + 1) == 2) %NW
                            G(m - 1, n + 1) = 3;
                        end
                        if (n + 1 <= N && F(m, n + 1) == 2) %N
                            G(m, n + 1) = 3;
                        end
                        if (m + 1 <= M && n + 1 <= N && F(m + 1, n + 1) == 2) %NE
                            G(m + 1, n + 1) = 3;
                        end
                     
                        if (m - 1 > 0 && F(m - 1, n) == 2) %W
                            G(m - 1, n) = 3;
                        end
                        if (m + 1 <= M && F(m + 1, n) == 2) %E
                            G(m + 1, n) = 3;
                        end
                     
                        if (m - 1 > 0 && n - 1 > 0 && F(m - 1, n - 1) == 2) %SW
                            G(m - 1, n - 1) = 3;
                        end
                        if (n - 1 > 0 && F(m, n - 1) == 2) %S
                            G(m, n - 1) = 3;
                        end
                        if (m + 1 <= M && n - 1 > 0 && F(m + 1, n - 1) == 2) %SE
                            G(m + 1, n - 1) = 3;
                        end
                        
                        if G(m, n) ~= 4
                            %Estinguish and go bare
                            G(m, n) = 1;
                        end
                end
                
                %If previously extinguished by a fire fighter, set back to
                %tree
                if F(m, n) == 4
                    
                    G(m, n) = 2;
                end
            end
        end
        F = G;
     
        %If Biomass Mode
        if mode == 1
            %Check if bare/ calculate biomass
            currentBiomass = biomassCheck(F);
         
            %Filling biomass array with percentage of trees occupied
            biomassArray = [biomassArray; currentBiomass];
            
         
            %If Longevity Mode
        elseif mode == 2
            bare = longevityCheck(F);
            if bare == true
                longevity = i;
                break;
            end
        end
    end
    returnArray = [returnArray,mean(biomassArray)];
    returnArray
end

%If Biomass Mode
%if mode == 1
%    fitness = mean(biomassArray);
%    %If Longevity Mode
%elseif mode == 2
%    fitness = longevity;
end
