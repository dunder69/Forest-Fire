function population = forestGA(populationSize, mutationProb, mutationRange, generations)

%2d Array with first row being fitness values, sencond row being corresponding
%p values
population = [zeros(1,populationSize); rand(1,populationSize)];
halfPopSize = (populationSize/2);

% Calculate fitnesses for all members of population based on p value
for i=1:populationSize
   pval = population (2,i);
   population (1,i) = forest_fire(0.001,pval,50,50);
end

for i=2:generations
    
    %Calculate fitnesses based on p values on lower half
    for j=halfPopSize:populationSize
        pval = population (2,j);
        population (1,j) = forest_fire(0.001,pval,250,250);
    end
    
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
        if population(2,j) > upperMax
            upperMax = orderByFitness(2,j);
        end
        if population(2,j) < upperMin
            upperMin = orderByFitness(2,j);
        end
    end
    
    %Replace bottom half with random p values in the range on min and max
    %of the top half p values
    for j=halfPopSize:populationSize
        temp(2,j) = upperMin + (upperMax-upperMin).*rand(1,1);
    end
    
    %Mutate
    for j=1:populationSize
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
    
    population = temp;
end
