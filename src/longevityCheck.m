function bareForest = longevityCheck(forest)

bareForest = true;

for i=1:size(forest,1)
    for j=1:size(forest,2)
        if forest(i,j) == 2
            bareForest = false;
            return
        end
    end
end