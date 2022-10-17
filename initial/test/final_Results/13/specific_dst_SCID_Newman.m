clear
close all
clc
feactorator = 'S_H_V_G_D_caser';
evaluator = feactorator;
load('contributors.mat');
load('./S_H_V_G_D_caser/bank.mat');
dst_wise_all = zeros(9, 14);
the_parameter = 13
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
mkdir(evaluator);
N = 1000;
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

cost =bank(the_parameter, 1);
gamma = bank(the_parameter, 2);
c_str = sprintf('%f',cost);
g_str = sprintf('%.2f',gamma);
libsvm_options = ['-s 3 -t 2 -g ',g_str,' -c ',c_str];
morrelatoins = zeros(7, 1);
for dst_idx = 1:9
    spear_results = zeros(N,1);
    for i = 1:N
        %         train = ismember(featrix_SCID(:, (feactor_length+2)),C(i,:));
        train = ismember(featrix_FR_SCID(:, (feactor_length+2)),C(i,:));
        test = ~train;
        rows_of_distortion = find(featrix_FR_SCID(:,feactor_length+3)==dst_idx);
        %         rows_of_distortion = find(featrix_FR_SCID(:,feactor_length+3)==dst_idx);
        test_new = test(rows_of_distortion);
        data_new = data(rows_of_distortion);
        label_new = label(rows_of_distortion);
        model = svmtrain(label(train),data(train,:),libsvm_options);
        [predict_score, ~, ~] = svmpredict(label_new(test_new), ...
            data_new(test_new,:), model);
        spear_results(i) = corr(predict_score, label_new(test_new),'type','Spearman');
        %         kendall_results(i) = corr(predict_score, label_new(test_new),'type','Kendall');
        %         [PLCC(i) RMSE(i)]=PearsonLC(predict_score, label_new(test_new));
    end
    
    spear_median = median(spear_results);
    %     kendall_median = median(kendall_results);
    %     PLCC_median = median(PLCC);
    %     RMSE_median = median(RMSE);
    %     spear_std = std(spear_results,0);
    %     morrelations{1,1, dst_idx} = 'SROCC';
    %     morrelations{1,2, dst_idx} = 'PLCC';
    %     morrelations{1,3, dst_idx} = 'RMSE';
    %     morrelations{1,4, dst_idx} = 'Kendall';
    morrelations(dst_idx, 1) = spear_median;
    %     morrelations{2,2, dst_idx} = PLCC_median;
    %     morrelations{2,3, dst_idx} = RMSE_median;
    %     morrelations{2,4, dst_idx} = kendall_median;
end
dst_wise_all(:,the_parameter) = morrelations;

the_table = cell(10, 15);
distortions = {'GN'; 'GB'; 'MB'; 'CC'; 'JPEG'; 'JPEG2000'; 'CSC'; 'HEVC-SCC'; 'CQD'};
the_table(2:end,1) = distortions;
for ii = 1:14
    the_table{1, ii+1} = ii;
end
for ii = 1:9
    for jj = 1:14
        the_table{ii+1, jj+1} = dst_wise_all(ii, jj);
    end
end
save('./S_H_V_G_D_caser/the_table_SCID.mat', 'the_table');