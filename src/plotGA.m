% Plot stuff
generations = 20;

x = 1:generations;

p1 = plot(x,minTree(2,:),'-bv');
hold on;
p2 = plot(x,avgTree(2,:),'-bd');
hold on;
p3 = plot(x,maxTree(2,:),'-b^');
hold on;

title({'Plot Showing Which Growth Rate (p) Produced the'; 'Min, Avg, and Max Fitness Each Generation'},'FontSize', 18);
xlabel('Generations','FontSize', 22);
ylabel('Growth Rate (p)','FontSize', 22);
lgd = legend([p1 p2 p3],'P Value that Produced Min Finess','P Value that Produced Avg Finess','P Value that Produced Max Finess','Location','southeast');
lgd.FontSize = 18;
