clear
close all
clc
% load featrix
% for each distortion
% optimium comma
the_parameter = 3;
feactorator = 'S_H_V_G_D_caser';
evaluator = feactorator;
load('contributors.mat');
coma_dst_wise = zeros(9, 3, 14);
the_strings = [" "];
for ii = 1:length(contributors{the_parameter, 1})
    the_cell = contributors{the_parameter, 1};
    the_string = the_cell{1, ii};
    the_strings(ii) = the_string;
end
function_name = join(the_strings, '_');
load(['./FMX_FR_SCID_',evaluator,'_', num2str(the_parameter),...
    '_',char(function_name),'.mat'])

commodors = zeros(9, 3);
for dst_idx = 1:9
    Ref_number = 40;
    N = 100;
    REF = round(Ref_number*0.8);
    C = zeros(N,REF);
    for j = 1:N
        rand_order = randperm(Ref_number);
        C(j,:) = rand_order(1:REF);
    end
    
    % [featrix_rows, featrix_cols] = size(featrix_SCID);
    % feactor_length = featrix_cols-5;
    % data = featrix_SCID(:,1:feactor_length);
    % label = featrix_SCID(:,feactor_length+1);
    
    [featrix_rows, featrix_cols] = size(featrix_FR_SCID);
    feactor_length = featrix_cols-5;
    data = featrix_FR_SCID(:,1:feactor_length);
    label = featrix_FR_SCID(:,feactor_length+1);
    
    rows_of_distortion = find(featrix_FR_SCID(:,feactor_length+3)==dst_idx);
    %%
    cost_power = -3:2:15;
    gamma_power = -15:2:3;
    %%
    cost_set = power(2, cost_power);
    gamma_set = power(2, gamma_power);
    init_cost = cost_set(1);
    step_cost = cost_set(2)-cost_set(1);
    init_gamma = gamma_set(1);
    step_gamma = gamma_set(2)- gamma_set(1);
    n_cost = length(cost_set);
    n_gamma = length(gamma_set);
    med_map = zeros(n_cost+1, n_gamma+1);
    med_map(1:n_cost, n_gamma+1) = cost_set';
    med_map(n_cost+1, 1:n_gamma) = gamma_set;
    std_map = zeros(n_cost+1, n_gamma+1);
    std_map(1:n_cost, n_gamma+1) = cost_set';
    std_map(n_cost+1, 1:n_gamma) = gamma_set;
    spr_rows = n_cost*n_gamma;
    spr_mat = zeros(spr_rows, N);
    co_ga = 0;
    row = 0;
    
    for aa = cost_set
        row = row+1;
        col = 0;
        for bb = gamma_set
            col = col+1;
            cost = aa;
            gamma = bb;
            co_ga = co_ga+1;
            c_str = sprintf('%f',cost);
            g_str = sprintf('%.2f',gamma);
            libsvm_options = ['-s 3 -t 2 -g ',g_str,' -c ',c_str];
            
            spear_results = zeros(N,1);
            
            for i = 1:N
                train = ismember(featrix_FR_SCID(:, feactor_length+2),C(i,:));
                test = ~train;
                %         rows_of_distortion = find(featrix_FR_SCID(:,feactor_length+3)==dst_idx);
                test_new = test(rows_of_distortion);
                data_new = data(test,:);
                label_new = label(test);
                model = svmtrain(label(train),data(train,:),libsvm_options);
%                 [predict_score, ~, ~ ] = svmpredict(label(test), data(test,:), model);
                [predict_score, ~, ~] = svmpredict(label_new(test_new), ...
                    data_new(test_new,:), model);
                spear_results(i) = corr(predict_score, label_new(test_new),'type','Spearman');
%                 spear_results(i) = corr(predict_score, label(test),'type','Spearman');     
            end
            spear_median = median(spear_results);
            spear_std = std(spear_results,0);
            spr_mat(co_ga, :) = spear_results';
            
            med_map(row, col) = spear_median;
            std_map(row, col) = spear_std;
        end
    end
    
    med_map2 = med_map(1:n_cost, 1:n_gamma);
    spear_max = max(max(med_map2));
    [the_cost, the_gamma] = find(abs(med_map-spear_max)<0.0001);
    cost_max = med_map(the_cost(1,1),end);
    gamma_max = med_map(end, the_gamma(1,1));
    commodors(dst_idx, 1) = cost_max;
    commodors(dst_idx, 2) = gamma_max;
    commodors(dst_idx, 3) = spear_max;
end
coma_dst_wise(:,:,the_parameter) = commodors;
save('coma_dst_wise.mat', 'coma_dst_wise');
