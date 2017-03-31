% Plot stuff
generations = 20;

x = 1:generations;

p1 = plot(x,minTree1(2,:),'-bv');
hold on;
p2 = plot(x,avgTree1(2,:),'-bd');
hold on;
p3 = plot(x,maxTree1(2,:),'-b^');
hold on;

p4 = plot(x,minTree2(2,:),'--mv');
hold on;
p5 = plot(x,avgTree2(2,:),'--md');
hold on;
p6 = plot(x,maxTree2(2,:),'--m^');
hold on;

title({'Plot Showing Which Growth Rate (p) Produced the'; 'Min, Avg, and Max Fitness Each Generation for 2 Species'},'FontSize', 18);
xlabel('Generations','FontSize', 22);
ylabel('Growth Rate (p)','FontSize', 22);
lgd = legend([p1 p2 p3 p4 p5 p6],'Species 1 Min','Species 1 Avg','Species 1 Max','Species 2 Min','Species 2 Avg','Species 2 Max','Location','southeast');
lgd.FontSize = 18;
