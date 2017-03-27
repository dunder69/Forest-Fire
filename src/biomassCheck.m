function biomass = biomassCheck(forest)

biomass = 0;

for i=1:size(forest,1)
    for j=1:size(forest,2)
        if forest(i,j) == 2
            biomass = biomass + 1;
        end
    end
end

biomass = biomass/(size(forest,1)*size(forest,2));