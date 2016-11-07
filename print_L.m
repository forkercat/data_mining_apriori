function print_L(L_k, L_k_count, k)

if k == 0
    fprintf('\n********* L_result *********\n <Item>          <Freq> \n');
else
    fprintf('\n********* L_%d *********\n <Item>          <Freq> \n', k);
end

for i=1:size(L_k,1)
    l = L_k(i,:);
    fprintf(' [');
    for j=1:length(l)
        fprintf('%d', l(j));
        if j~=length(l)
            fprintf(', ');
        else
            fprintf(']');
        end
    end
    fprintf('          %d\n', L_k_count(i));
end

end