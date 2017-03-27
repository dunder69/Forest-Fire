function longevityCheck = longevityCheck(forest)

longevityCheck = False;

for i=1:size(forest,1)
    for j=1:size(forest,2)
        if forest(i,j) == 2
            longevityCheck = True;
            return
        end
    end
end