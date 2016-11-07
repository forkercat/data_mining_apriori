function print_C(C_k, C_count, k)

fprintf('\n********* C_%d *********\n <Item>          <Freq>\n', k);
    
for i=1:size(C_k,1)
    c = C_k(i,:);
    fprintf(' [');
    for j=1:length(c)
        fprintf('%d', c(j));
        if j~=length(c)
            fprintf(', ');
        else
            fprintf(']');
        end
    end
    fprintf('          %d\n', C_count(i));
end

end