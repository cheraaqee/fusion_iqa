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
    
    data_test_whole = featrix_FR_SCID(:,1:feactor_length);
    label_test_whole = featrix_FR_SCID(:,feactor_length+1);
    
    data_train_whole = featrix_FR_SIQAD(:,1:feactor_length);
    label_train_whole = featrix_FR_SIQAD(:,feactor_length+1);
    
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
    
    data_test = data_test_whole(lovely_SCID',:);
    label_test = label_test_whole(lovely_SCID');
    
    data_train = data_train_whole(lovely_SIQAD', :);
    label_train = label_train_whole(lovely_SIQAD');
    
    featrix_dst_SCID = featrix_FR_SCID(lovely_SCID, :);
    featrix_dst_SIQAD = featrix_FR_SIQAD(lovely_SIQAD, :);
    for dst_udx =1:6
        kk = 1;
        for ii = 1:size(featrix_dst_SCID, 1)
            if featrix_dst_SCID(ii, feactor_length+3)==dst_udx
                dsts_SCID(kk) = ii;
                kk = kk+1;
            end
        end
        kk = 1;
        for ii = 1:size(featrix_dst_SIQAD, 1)
            if featrix_dst_SIQAD(ii, feactor_length+3)==dst_udx
                dsts_SIQAD(kk) = ii;
                kk = kk+1;
            end
        end
        test_d_dst(:,:,dst_udx) = featrix_dst_SCID(dsts_SCID,1:feactor_length);
        test_l_dst(:,dst_udx) = featrix_dst_SCID(dsts_SCID,feactor_length+1);
        train_d_dst(:,:,dst_udx) = featrix_dst_SIQAD(dsts_SIQAD,1:feactor_length);
        train_l_dst(:,dst_udx) = featrix_dst_SIQAD(dsts_SIQAD,feactor_length+1);
    end
    
    load(['/media/pooryaa/New Volume/mvip_SCI/final_Results/',...
        num2str(the_parameter),'/S_H_V_G_D_caser/bank.mat']);
    cost = bank(the_parameter, 1);
    gamma = bank(the_parameter, 2);
    c_str = sprintf('%f',cost);
    g_str = sprintf('%.2f',gamma);
    libsvm_options = ['-s 3 -t 2 -g ',g_str,' -c ',c_str];
    for dst_udx = 1:6
        model = svmtrain(train_l_dst(:,dst_udx),train_d_dst(:,:,dst_udx),libsvm_options);
        [predict_score, ~, ~ ] = svmpredict(test_l_dst(:,dst_udx), test_d_dst(:,:,dst_udx), model);
        spear_results_qc_dst(1, dst_udx, the_parameter) = corr(predict_score, test_l_dst(:,dst_udx),'type','Spearman');
        [spear_results_qc_dst(2, dst_udx, the_parameter), spear_results_qc_dst(3, dst_udx, the_parameter)]=...
            PearsonLC(predict_score, test_l_dst(:,dst_udx));
        spear_results_qc_dst(4, dst_udx, the_parameter) = corr(predict_score, test_l_dst(:,dst_udx),'type','Kendall');
    end
    clear train_d_dst train_l_dst test_d_dst test_l_dst
end
save('cross_p_dst_SIQAD_SCID.mat', 'spear_results_qc_dst');