function forestGA(populationSize, mutationProb, generations)

%2d Array with first row being fitness values, sencond row being corresponding
%p values
population = [zeros(1,populationSize); rand(1,populationSize);]

for i=1:generations
    
    %Calculate fitnesses based on p values
    for j=1:populationSize
        pval = population (2,j);
        population (1,j) = forest_fire(0.001,pval,50,50);
    end
    
    %Sort by fitness values
    [fitness, pval] = sort(population(1,:),'descend');
    orderByFitness = population(:,pval)
    
    %Keep upper half based on fitnes scores
    
    %Replace bottom half with random p values in the range on min and max
    %of the top half p values
    
    %Mutate
end
