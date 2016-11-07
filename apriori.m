% 读取原始数据
D_raw = load('data.txt');
% 将数据离散化
D = preprocess(D_raw);
max_order = max(D(:));  % 获得最大编号 1~max

% 最小支持度, 最小置信度
min_sup = 0.1;     % rel = 0.05, abs = 7
min_sup_abs = ceil(size(D,1) * min_sup);    % 绝对最小支持度
min_conf = 0.4;

% 求次数
[freq, orders] = hist(D(:), [1:max_order]);

% 显示C_1
fprintf('********* C_1 *********\norder     freq\n');

for i=1:length(orders)
    fprintf('%2.d        %d\n', orders(i), freq(i)); 
end

% 生成L_1
L_1 = [];
L_1_count = [];
for i=1:length(orders)
    if(freq(i) >= min_sup_abs)
        L_1 = [L_1; orders(i)];
        L_1_count = [L_1_count; freq(i)];
    end
end

fprintf('\n');

% 显示L_1
fprintf('********* L_1 ******F***\n<Item>     <req> \n');
for i=1:length(L_1)
    fprintf('%2.d        %d\n', L_1(i), L_1_count(i)); 
end


% 求解k-项频繁集
K = 3;  % 针对这个问题为3
L_result = []; % 结果
L_result_count = []; % 次数

% 初始化
L_k_1 = L_1;
L_k_1_count = L_1_count;

for k=2:K  % 实际要L_k-1是否为空集, 针对这个问题我们直接将设置成K
    
    % 生成C_k
    C_k = apriori_gen(L_k_1, k - 1);
    count = zeros(size(C_k, 1), 1);
    
    % 计数
    for i=1:size(C_k,1)
        c = C_k(i,:);
        for j=1:size(D,1)
            d = D(j,:);
            % 加all()的作用, 判断是不是子集
            if all(ismember(c,d))
                count(i) = count(i) + 1;
            end
        end
    end
    
    % 筛选
    L_k = C_k(find(count >= min_sup_abs),:);
    L_k_count = count(find(count >= min_sup_abs),:);
    
    % ******************* 显示开始 **********************
    
    % C_k
    print_C(C_k, count, k)
    
    % L_k
    print_L(L_k, L_k_count, k);
    
    % ******************* 显示结束 **********************
    
    %  传出数据
    
    if size(L_k,1) > 0
        L_k_1= L_k;
        L_result = L_k;
        L_result_count = L_k_count;
    else 
        % 空了, 结束了
        if k == 2 % 针对第一轮就跳出的特殊处理
            L_result = L_k_1;
            L_result_count = L_k_1_count;
        end
        break;
    end
    
end

% ********* 显示结果 **********
print_L(L_result, L_result_count, 0);

% 显示支持度,置信度
fprintf('\nMinimum Support: %.2f  (absolute support = %d)  \nMinimum Confidence: %.1f%%\n\n', min_sup, min_sup_abs, min_conf * 100);

% 置信度处理
% 遍历L_result得到每个频繁项集, 对其生成非空子集
fprintf('Rules:\n');
rules = {};
numOfRules = 1;
for i=1:size(L_result,1)
    % 存储子集
    subset = {};
    % 从1到k-1找子集
    l = L_result(i,:);
    for j=1:length(l) - 1
        % 找到所有子集, 将其全部放进subset里面
        new_set = nchoosek(l, j);
        for k=1:size(new_set,1)
            subset = [subset new_set(k,:)];
        end
    end
    
    % 遍历subset, 对于每一个非空真子集s, 得到s->(l-s)的规则
    for k=1:length(subset)
        s = subset{k};
        % r = l - s
        r = setdiff(l, s);
        
        % 计算置信度, conf = support_count(l) / support_count(s)
        % 从L_result_count可以得知support_count(l)
        support_count_l = L_result_count(i);
        % 计算support_count(l), 其实这里更好的方法应该存起来之前的频繁集
        % 遍历事务
        support_count_s = 0;
        for m=1:size(D,1)
            d = D(m,:);
            % 加all()的作用, 判断是不是子集
            if all(ismember(s,d))
                support_count_s = support_count_s + 1;
            end
        end
        conf = support_count_l / support_count_s;
        
        % 生成规则的字符串
        s_str = strrep(num2str(s), '  ', ', ');
        r_str = strrep(num2str(r), '  ', ', ');
        rule_str = ['[', s_str, ']', ' -> ', '[', r_str, ']'];
        
        % 加入到rules里面
        rules{numOfRules, 1} = rule_str;
        rules{numOfRules, 2} = conf;
        numOfRules = numOfRules + 1;
    end
end

% 对rules进行排序
confs = rules(:,2);
[temp, ind] = sort(cell2mat(confs), 'descend');
rules_sorted = rules(ind,:);

% 筛选
confs_sorted = rules_sorted(:,2);
ind = find(cell2mat(confs_sorted) >= min_conf);
rules_sorted_filtered = rules_sorted(ind,:);

% 输出
for i=1:size(rules_sorted_filtered, 1)
    rule_str = rules_sorted_filtered{i, 1};
    conf = rules_sorted_filtered{i, 2};
    fprintf('%s   %.1f%%\n', rule_str, conf * 100);
end

fprintf('\n');


