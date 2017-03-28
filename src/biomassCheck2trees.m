function [biomassTree1,biomassTree2] = biomassCheck2trees(forest)

biomassTree1 = 0;
biomassTree2 = 0;

for i=1:size(forest,1)
    for j=1:size(forest,2)
        if forest(i,j) == 2
            biomassTree1 = biomassTree1 + 1;
        elseif forest(i,j) == 3
            biomassTree2 = biomassTree2 + 1;
        end
    end
end

biomassTree1 = biomassTree1/(size(forest,1)*size(forest,2));
biomassTree2 = biomassTree2/(size(forest,1)*size(forest,2));