function [populationSpecies1,populationSpecies2] = forestGA2trees(populationSize, mutationProb, mutationRange, generations, mode)

% Mode 1 = Biomass
% Mode 2 = Longevity

%2d Array with first row being fitness values, sencond row being corresponding
%p values
populationSpecies1 = [zeros(1,populationSize); rand(1,populationSize)];
populationSpecies2 = [zeros(1,populationSize); rand(1,populationSize)];
halfPopSize = (populationSize/2);

% Calculate fitnesses for all members of population based on p value
for i=1:populationSize
   pval1 = populationSpecies1 (2,i);
   pval2 = populationSpecies2 (2,i);
   [tree1Fitness, tree2Fitness] = forest_fire2trees(0.001,pval1,pval2,250,250,mode);
   populationSpecies1 (1,i) = tree1Fitness;
   populationSpecies2 (1,i) = tree2Fitness;
end
disp('Finished generation 1');

for i=2:generations
    
    %Calculate fitnesses based on p values on lower half
    for j=halfPopSize:populationSize
        pval1 = populationSpecies1 (2,j);
        pval2 = populationSpecies2 (2,j);
        [tree1Fitness, tree2Fitness] = forest_fire2trees(0.001,pval1,pval2,250,250,mode);
        populationSpecies1 (1,j)  = tree1Fitness;
        populationSpecies2 (1,j)  = tree2Fitness;
    end
    
    %Sort by fitness values
    [fitness1, pval1] = sort(populationSpecies1(1,:),'descend');
    orderByFitness1 = populationSpecies1(:,pval1);
    [fitness2, pval2] = sort(populationSpecies2(1,:),'descend');
    orderByFitness2 = populationSpecies2(:,pval2);
    
    %Keep upper half based on fitnes scores, calc min and max of upper half
    upperMaxTree1 = 0;
    upperMinTre1 = 1;
    upperMaxTree2 = 0;
    upperMinTre2 = 1;
    temp1 = [zeros(1,populationSize); zeros(1,populationSize)];
    temp2 = [zeros(1,populationSize); zeros(1,populationSize)];
    for j=1:halfPopSize
        temp1(1,j) = orderByFitness1 (1,j);
        temp1(2,j) = orderByFitness1 (2,j);
        temp2(1,j) = orderByFitness2 (1,j);
        temp2(2,j) = orderByFitness2 (2,j);
        if populationSpecies1(2,j) > upperMaxTree1
            upperMaxTree1 = orderByFitness1(2,j);
        end
        if populationSpecies1(2,j) < upperMinTre1
            upperMinTre1 = orderByFitness1(2,j);
        end
        if populationSpecies2(2,j) > upperMaxTree2
            upperMaxTree2 = orderByFitness2(2,j);
        end
        if populationSpecies2(2,j) < upperMinTre2
            upperMinTre2 = orderByFitness2(2,j);
        end
    end
    
    %Replace bottom half with random p values in the range on min and max
    %of the top half p values
    for j=halfPopSize:populationSize
        temp1(2,j) = upperMinTre1 + (upperMaxTree1-upperMinTre1).*rand(1,1);
        temp2(2,j) = upperMinTre2 + (upperMaxTree2-upperMinTre2).*rand(1,1);
    end
    
    %Mutate
    for j=1:populationSize
        if rand() < mutationProb
            addOrSub = rand;
            pChange1 = (mutationRange).*rand(1,1);
            pChange2 = (mutationRange).*rand(1,1);
            if addOrSub < 0.5
                if temp1(2,j) + mutationRange > 1
                   temp1(2,j) = 1;
                else
                    temp1(2,j) = temp1(2,j) + pChange1;
                end
                if temp2(2,j) + mutationRange > 1
                   temp2(2,j) = 1;
                else
                    temp2(2,j) = temp2(2,j) + pChange2;
                end
            else
                if temp1(2,j) - mutationRange < 0
                    temp1(2,j) = 0;
                else
                    temp1(2,j) = temp1(2,j) - pChange1;
                end
                if temp2(2,j) - mutationRange < 0
                    temp2(2,j) = 0;
                else
                    temp2(2,j) = temp2(2,j) - pChange2;
                end
            end
        end
    end
    
    populationSpecies1 = temp1;
    populationSpecies2 = temp2;
    status = ['Finished generation ',num2str(i)];
    disp(status);
end


%After loop calculate the last fitness vaules of the new generation and
%sort

%Calculate fitnesses based on p values on lower half
for j=halfPopSize:populationSize
    pval1 = populationSpecies1 (2,j);
    pval2 = populationSpecies2 (2,j);
    [treeFitness1, treeFitness2] = forest_fire2trees(0.001,pval1,pval2,250,250,mode);
    populationSpecies1 (1,j) = treeFitness1;
    populationSpecies1 (1,j) = treeFitness2;
end
    
%Sort by fitness values
[fitness1, pval1] = sort(populationSpecies1(1,:),'descend');
orderByFitness1 = populationSpecies1(:,pval1);
populationSpecies1 = orderByFitness1;
[fitness2, pval2] = sort(populationSpecies2(1,:),'descend');
orderByFitness2 = populationSpecies2(:,pval1);
populationSpecies2 = orderByFitness2;

%Write population to file
filename = strcat('2trees-pop1-pop',num2str(populationSize),'-mp',num2str(mutationProb),'-mr',num2str(mutationRange),'-gens',num2str(generations),'-mode',num2str(mode),'.txt');
dlmwrite(filename,populationSpecies1);
filename = strcat('2trees-pop2-pop',num2str(populationSize),'-mp',num2str(mutationProb),'-mr',num2str(mutationRange),'-gens',num2str(generations),'-mode',num2str(mode),'.txt');
dlmwrite(filename,populationSpecies2);
