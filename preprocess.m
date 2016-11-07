function data = preprocess(raw_data)

% attr #1
data_1 = raw_data(:,1);
% min 1930, max 1994
data_1_new = [];
for i=1:length(data_1)
    elem = data_1(i);
    id = floor((elem - 1921) / 10) + 1;
    data_1_new = [data_1_new; id];
end
data_1_max_id = max(data_1_new);
% id:1-8

% attr #2
data_2 = raw_data(:,2);
% min 40, max 120
data_2_new = [];
for i=1:length(data_2)
    elem = data_2(i);
    id = floor((elem - 31) / 10) + data_1_max_id + 1;
    data_2_new = [data_2_new; id];
end
data_2_max_id = max(data_2_new);
% id:9-17

% attr #3
data_3 = raw_data(:,3);
% min 1.2, max 2.0
data_3_new = [];
for i=1:length(data_3)
    elem = data_3(i);
    id = floor((elem - 1.11) / 0.1) + data_2_max_id + 1;
    data_3_new = [data_3_new; id];
end
data_3_max_id = max(data_3_new);
% id:18-26

% disp info
fprintf('Discreted Rules(type D for displaying data):\n\nbirth_year: (id: %d-%d)\n', 1, data_1_max_id);
for i=1:data_1_max_id
    fprintf('%d    %d - %d\n', i, 1921 + (i - 1) * 10, 1921 + i * 10 - 1);
end

fprintf('\nweight: (id:%d-%d)\n', data_1_max_id + 1, data_2_max_id);
for i=1:(data_2_max_id - data_1_max_id)
    fprintf('%d    %d - %d\n', data_1_max_id + i, 31 + (i - 1) * 10, 31 + i * 10 - 1);
end

fprintf('\nheight: (id:%d-%d)\n', data_2_max_id + 1, data_3_max_id);
for i=1:(data_3_max_id - data_2_max_id)
    fprintf('%d    %.2f - %.2f\n', data_2_max_id + i, 1.11 + (i - 1) * 0.1, 1.11 + i * 0.1 - 0.01);
end

fprintf('\n');

data = [data_1_new data_2_new data_3_new];

end