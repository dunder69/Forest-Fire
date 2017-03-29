function [populationSpecies1,populationSpecies2,maxTree1,avgTree1,minTree1,maxTree2,avgTree2,minTree2] = forestGA2trees(populationSize, mutationProb, mutationRange, generations, mode)

% Mode 1 = Biomass
% Mode 2 = Longevity

%2d Array with first row being fitness values, sencond row being corresponding
%p values
populationSpecies1 = [zeros(1,populationSize); rand(1,populationSize)];
populationSpecies2 = [zeros(1,populationSize); rand(1,populationSize)];
halfPopSize = (populationSize/2);

% Each of these arrays will hold the p values that produced the min max and
% avg fitnesses each generation and the associated fitnesses
maxTree1 = zeros(2,generations);
avgTree1 = zeros(2,generations);
minTree1 = zeros(2,generations);
maxTree2 = zeros(2,generations);
avgTree2 = zeros(2,generations);
minTree2 = zeros(2,generations);

% Calculate fitnesses for all members of population based on p value
for i=1:populationSize
   pval1 = populationSpecies1 (2,i);
   pval2 = populationSpecies2 (2,i);
   [tree1Fitness, tree2Fitness] = forest_fire2trees(0.001,pval1,pval2,250,250,mode);
   populationSpecies1 (1,i) = tree1Fitness;
   populationSpecies2 (1,i) = tree2Fitness;
end
% Find min, max, avg, get index of each so we can get corresponding p
% value
[max1 max1idx] = max(populationSpecies1 (1,:));
[min1 min1idx] = min(populationSpecies1 (1,:));
[max2 max2idx] = max(populationSpecies2 (1,:));
[min2 min2idx] = min(populationSpecies2 (1,:));

avgf1 = mean(populationSpecies1 (1,:)); % Avg fitness
avgp1 = mean(populationSpecies1 (2,:)); % Avg p value
avgf2 = mean(populationSpecies2 (1,:));
avgp2 = mean(populationSpecies2 (2,:));


maxTree1(1,1) = max1; % max fitness
maxTree1(2,1) = populationSpecies1(2,max1idx); % p value associated with max fitness
minTree1(1,1) = min1; % min fitness
minTree1(2,1) = populationSpecies1(2,min1idx); % p value associated with min fitness
avgTree1(1,1) = avgf1; % avg fitness
avgTree1(2,1) = avgp1; % avg p value

maxTree2(1,1) = max2; % max fitness
maxTree2(2,1) = populationSpecies2(2,max2idx); % p value associated with max fitness
minTree2(1,1) = min2; % min fitness
minTree2(2,1) = populationSpecies2(2,min2idx); % p value associated with min fitness
avgTree2(1,1) = avgf2; % avg fitness
avgTree2(2,1) = avgp2; % avg p value

disp('Finished generation 1');

for i=2:generations
    
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
    %of the top half p values. These are the "children"
    for j=halfPopSize:populationSize
        temp1(2,j) = upperMinTre1 + (upperMaxTree1-upperMinTre1).*rand(1,1);
        temp2(2,j) = upperMinTre2 + (upperMaxTree2-upperMinTre2).*rand(1,1);
    end
    
    %Mutate children
    for j=halfPopSize:populationSize
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
    
    
    %Calculate fitnesses of children
    for j=halfPopSize:populationSize
        pval1 = temp1 (2,j);
        pval2 = temp2 (2,j);
        [tree1Fitness, tree2Fitness] = forest_fire2trees(0.001,pval1,pval2,250,250,mode);
        temp1 (1,j)  = tree1Fitness;
        temp2 (1,j)  = tree2Fitness;
    end
    
    % Set generation
    populationSpecies1 = temp1;
    populationSpecies2 = temp2;
    
    %Calc min, max, avg
    [max1 max1idx] = max(populationSpecies1 (1,:));
    [min1 min1idx] = min(populationSpecies1 (1,:));
    [max2 max2idx] = max(populationSpecies2 (1,:));
    [min2 min2idx] = min(populationSpecies2 (1,:));

    avgf1 = mean(populationSpecies1 (1,:)); % Avg fitness
    avgp1 = mean(populationSpecies1 (2,:)); % Avg p value
    avgf2 = mean(populationSpecies2 (1,:));
    avgp2 = mean(populationSpecies2 (2,:));

    %Fill arrays for plots
    maxTree1(1,i) = max1; % max fitness
    maxTree1(2,i) = populationSpecies1(2,max1idx); % p value associated with max fitness
    minTree1(1,i) = min1; % min fitness
    minTree1(2,i) = populationSpecies1(2,min1idx); % p value associated with min fitness
    avgTree1(1,i) = avgf1; % avg fitness
    avgTree1(2,i) = avgp1; % avg p value
    
    maxTree2(1,1) = max2; % max fitness
    maxTree2(2,1) = populationSpecies2(2,max2idx); % p value associated with max fitness
    minTree2(1,1) = min2; % min fitness
    minTree2(2,1) = populationSpecies2(2,min2idx); % p value associated with min fitness
    avgTree2(1,1) = avgf2; % avg fitness
    avgTree2(2,1) = avgp2; % avg p value
    
    status = ['Finished generation ',num2str(i)];
    disp(status);
end


%After loop sort the last generation 
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

% Plot stuff
x = 1:generations;

p1 = plot(x,minTree1,'-bv');
hold on;
p2 = plot(x,avgTree1,'-bd');
hold on;
p3 = plot(x,maxTree1,'-b^');
hold on;

p4 = plot(x,minTree2,'--mv');
hold on;
p5 = plot(x,avgTree2,'--md');
hold on;
p6 = plot(x,maxTree2,'--m^');

title({'Plot Showing Which Growth Rate (p) Produced the'; 'Min, Avg, and Max Fitness Each Generation for 2 Species'},'FontSize', 18);
xlabel('Generations','FontSize', 22);
ylabel('Growth Rate (p)','FontSize', 22);
lgd = legend([p1 p2 p3 p4 p5 p6],'Species 1 Min','Species 1 Avg','Species 1 Max','Species 2 Min','Species 2 Avg','Species 2 Max');
lgd.FontSize = 18;