% c的子集是否在L里面
function flag = has_infrequent_subset(c, L)

% c的n-子集
subset = nchoosek(c, size(L,2));

flag = 1;
for i=1:size(subset,2)
    if ~ismember(subset(i,:), L, 'rows')
        flag = 0;
        break;
    end
end

end