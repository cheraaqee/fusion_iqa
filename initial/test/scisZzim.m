for ii = 1:14
   load(['/media/pooryaa/New Volume/mvip_SCI/final_Results/',...
       num2str(ii),'/S_H_V_G_D_caser/bank.mat']);
   data_SCID{11, ii+2} = bank(ii, 3);
end