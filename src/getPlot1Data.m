function [biomass, longevity] = getPlot1Data
    pVals1 = linspace(0.01,0.99,99);
    pVals2 = linspace(0.001,0.009,9);
    pVals = [pVals2,pVals1];
    biomass = zeros(1,length(pVals));
    longevity = zeros(1,length(pVals));
    for i=1:length(pVals)
        i
        [biomass(1,i), longevity(1,i)] = forest_fire2(0.001,pVals(i));
    end
    figure
scatter(biomass, longevity, 1000 , pVals, 'filled')
figure
plot(pVals, biomass)

end