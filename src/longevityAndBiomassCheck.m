function [bare, biomass] = longevityAndBiomassCheck(forest)

bare = true;
biomass = 0;

for i=1:size(forest,1)
    for j=1:size(forest,2)
        if forest(i,j) > 1
            bare = false;
        end
        if forest(i,j) == 2
            biomass = biomass + 1;
        end
    end
end