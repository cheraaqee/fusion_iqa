clear
close all
clc
% load featrix
% for each distortion
% optimium comma
for the_parameter = 1:14
    feactorator = 'S_H_V_G_D_caser';
    evaluator = feactorator;
    load('contributors.mat');
    the_strings = [" "];
    for ii = 1:length(contributors{the_parameter, 1})
        the_cell = contributors{the_parameter, 1};
        the_string = the_cell{1, ii};
        the_strings(ii) = the_string;
    end
    function_name = join(the_strings, '_');
    load(['./FMX_FR_SCID_',evaluator,'_', num2str(the_parameter),...
        '_',char(function_name),'.mat'])
    load(['./FMX_FR_SIQAD_',evaluator,'_', num2str(the_parameter),...
        '_',char(function_name),'.mat'])
    
    [featrix_rows, featrix_cols] = size(featrix_FR_SCID);
    feactor_length = featrix_cols-5;
    
    data_train_whole = featrix_FR_SCID(:,1:feactor_length);
    label_train_whole = featrix_FR_SCID(:,feactor_length+1);
    
    data_test_whole = featrix_FR_SIQAD(:,1:feactor_length);
    label_test_whole = featrix_FR_SIQAD(:,feactor_length+1);
    
    kk = 1;
    for ii = 1:1800
       if featrix_FR_SCID(ii, feactor_length+3)==1 ||...
               featrix_FR_SCID(ii, feactor_length+3) ==2||...
               featrix_FR_SCID(ii, feactor_length+3) ==3||...
               featrix_FR_SCID(ii, feactor_length+3) ==4||...
               featrix_FR_SCID(ii, feactor_length+3) ==5||...
               featrix_FR_SCID(ii, feactor_length+3) ==6
           lovely_SCID(kk) = ii;
           kk = kk+1;
       end
    end
    
    kk = 1;
    for ii = 1:980
       if featrix_FR_SIQAD(ii, feactor_length+3)==1 ||...
               featrix_FR_SIQAD(ii, feactor_length+3) ==2||...
               featrix_FR_SIQAD(ii, feactor_length+3) ==3||...
               featrix_FR_SIQAD(ii, feactor_length+3) ==4||...
               featrix_FR_SIQAD(ii, feactor_length+3) ==5||...
               featrix_FR_SIQAD(ii, feactor_length+3) ==6
           lovely_SIQAD(kk) = ii;
           kk = kk+1;
       end
    end
    
    data_train = data_train_whole(lovely_SCID',:);
    label_train = label_train_whole(lovely_SCID');
    
    data_test = data_test_whole(lovely_SIQAD', :);
    label_test = label_test_whole(lovely_SIQAD');
    
    load(['/media/pooryaa/New Volume/mvip_SCI/final_Results/',...
        num2str(the_parameter),'/S_H_V_G_D_caser/bank.mat']);
    cost = bank(the_parameter, 1);
    gamma = bank(the_parameter, 2);
    c_str = sprintf('%f',cost);
    g_str = sprintf('%.2f',gamma);
    libsvm_options = ['-s 3 -t 2 -g ',g_str,' -c ',c_str];
    
    
    model = svmtrain(label_train,data_train,libsvm_options);
    [predict_score, ~, ~ ] = svmpredict(label_test, data_test, model);
    spear_results_dq(1,the_parameter) = corr(predict_score, label_test,'type','Spearman');
    [spear_results_dq(2, the_parameter), spear_results_dq(3, the_parameter)]=...
        PearsonLC(predict_score, label_test);
    spear_results_dq(4,the_parameter) = corr(predict_score, label_test, 'type', 'Kendall');
end
save('cross_p_SCID_SIQAD.mat', 'spear_results_dq');