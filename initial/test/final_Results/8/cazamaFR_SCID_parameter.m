
clear
clc
close all
bank = zeros(14, 3);
the_parameter = 8
    evaluator = 'S_H_V_G_D_caser';
    load('contributors.mat');
    the_strings = [" "];
    for ii = 1:length(contributors{the_parameter, 1})
        the_cell = contributors{the_parameter, 1};
        the_string = the_cell{1, ii};
        the_strings(ii) = the_string;
    end
    function_name = join(the_strings, '_');
    load(['./', evaluator, '/FMX_FR_SCID_',evaluator,'_', num2str(the_parameter),...
        '_',char(function_name),'.mat'])
    Ref_number = 40;
    N = 100;
    REF = round(Ref_number*0.8);
    C = zeros(N,REF);
    for j = 1:N
        rand_order = randperm(Ref_number);
        C(j,:) = rand_order(1:REF);
    end
    [featrix_rows, featrix_cols] = size(featrix_FR_SCID);
    feactor_length = featrix_cols-5;
    data = featrix_FR_SCID(:,1:feactor_length);
    label = featrix_FR_SCID(:,feactor_length+1);
    %% !!!!!!!!!!!!!!!!!!!!!       C O M M E N T!       !!!!!!!!!!!!!!!!!!!!!!!
    % set the desired range for cost and gamma:
    % cost_set = initial:step:final;
    % gamma_set = initial:step:final;
    cost_power = -3:2:15;
    gamma_power = -15:2:3;
    cost_set = power(2, cost_power);
    gamma_set = power(2, gamma_power);
    % cost_set = 1200:200:2000;
    % gamma_set = 0.4:0.1:0.6;
    %%
    
    
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
                
                model = svmtrain(label(train),data(train,:),libsvm_options);
                [predict_score, ~, ~] = svmpredict(label(test), data(test,:), model);
                spear_results(i) = corr(predict_score, label(test),'type','Spearman');
                spear_median = median(spear_results);
                spear_std = std(spear_results,0);
                
            end
            spr_mat(co_ga, :) = spear_results';
            
            med_map(row, col) = spear_median;
            std_map(row, col) = spear_std;
        end
    end
    
    med_map2 = med_map(1:n_cost, 1:n_gamma);
    spear_max = max(max(med_map2));
    [the_cost, the_gamma] = find(abs(med_map-spear_max)<0.0001);
    cost_max = med_map(the_cost,end);
    gamma_max = med_map(end, the_gamma);
    mesh_mesh = zeros(n_cost*5, n_gamma*5);
    for ii = 1:n_cost
        for jj = 1:n_gamma
            mesh_mesh((ii-1)*5+1:ii*5,(jj-1)*5+1:jj*5) = med_map2(ii, jj);
        end
    end
    
    bank(the_parameter, 1) = cost_max(1,1);
    bank(the_parameter, 2) = gamma_max(1,1);
    bank(the_parameter, 3) = spear_max;
    close all
    clear FMX_FR_SIQAD

save(['./', evaluator, '/bank.mat'], 'bank');