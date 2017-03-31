function [population,maxTree,avgTree,minTree] = forestGA(populationSize, mutationProb, mutationRange, generations, mode)

% Mode 1 = Biomass
% Mode 2 = Longevity

M = 250;
N = 250;

%2d Array with first row being fitness values, sencond row being corresponding
%p values
population = [zeros(1,populationSize); rand(1,populationSize)];
halfPopSize = (populationSize/2);

% Each of these arrays will hold the p values that produced the min max and
% avg fitnesses each generation and the associated fitnesses
maxTree = zeros(2,generations);
avgTree = zeros(2,generations);
minTree = zeros(2,generations);

% Calculate fitnesses for all members of population based on p value
for i=1:populationSize
   pval = population (2,i);
   population (1,i) = forest_fire(0.001,pval,M,N,mode);
end

% Find min, max, avg, get index of each so we can get corresponding p
% value
[maxf, maxidx] = max(population (1,:));
[minf, minidx] = min(population (1,:));
avgf = mean(population (1,:)); % Avg fitness
avgp = mean(population (2,:)); % Avg p value

maxTree(1,1) = maxf; % max fitness
maxTree(2,1) = population(2,maxidx); % p value associated with max fitness
minTree(1,1) = minf; % min fitness
minTree(2,1) = population(2,minidx); % p value associated with min fitness
avgTree(1,1) = avgf; % avg fitness
avgTree(2,1) = avgp; % avg p value

disp('Finished generation 1');

for i=2:generations
    
    %Sort by fitness values
    [fitness, pval] = sort(population(1,:),'descend');
    orderByFitness = population(:,pval);
    
    %Keep upper half based on fitnes scores, calc min and max of upper half
    upperMax = 0;
    upperMin = 1;
    temp = [zeros(1,populationSize); zeros(1,populationSize)];
    for j=1:halfPopSize
        temp(1,j) = orderByFitness (1,j);
        temp(2,j) = orderByFitness (2,j);
        if orderByFitness(2,j) > upperMax
            upperMax = orderByFitness(2,j);
        end
        if orderByFitness(2,j) < upperMin
            upperMin = orderByFitness(2,j);
        end
    end
    
    %Replace bottom half with random p values in the range on min and max
    %of the top half p values. These are the "children"
    for j=halfPopSize:populationSize
        temp(2,j) = upperMin + (upperMax-upperMin).*rand(1,1);
    end
    
    %Mutate children
    for j=halfPopSize:populationSize
        if rand() < mutationProb
            addOrSub = rand;
            pChange = (mutationRange).*rand(1,1);
            if addOrSub < 0.5
                if temp(2,j) + mutationRange > 1
                   temp(2,j) = 1;
                else
                    temp(2,j) = temp(2,j) + pChange;
                end
            else
                if temp(2,j) - mutationRange < 0
                    temp(2,j) = 0;
                else
                    temp(2,j) = temp(2,j) - pChange;
                end
            end
        end
    end
    
    %Calculate fitnesses of children
    for j=halfPopSize:populationSize
        pval = temp (2,j);
        treeFitness = forest_fire(0.001,pval,M,N,mode);
        temp (1,j)  = treeFitness;
    end
    
    % Set generation
    population = temp;
    
    %Calc min, max, avg
    [maxf, maxidx] = max(population (1,:));
    [minf, minidx] = min(population (1,:));
    
    avgf = mean(population (1,:)); % Avg fitness
    avgp = mean(population (2,:)); % Avg p value
    
    
    %Fill arrays for plots
    maxTree(1,i) = maxf; % max fitness
    maxTree(2,i) = population(2,maxidx); % p value associated with max fitness
    minTree(1,i) = minf; % min fitness
    minTree(2,i) = population(2,minidx); % p value associated with min fitness
    avgTree(1,i) = avgf; % avg fitness
    avgTree(2,i) = avgp; % avg p value
    
    status = ['Finished generation ',num2str(i)];
    disp(status);
    
    
end

%After loop sort the last generation 
[fitness, pval] = sort(population(1,:),'descend');
orderByFitness = population(:,pval);
population = orderByFitness;


%Write population to file
filename = strcat('pop',num2str(populationSize),'-mp',num2str(mutationProb),'-mr',num2str(mutationRange),'-gens',num2str(generations),'-mode',num2str(mode),'.txt');
dlmwrite(filename,population);
