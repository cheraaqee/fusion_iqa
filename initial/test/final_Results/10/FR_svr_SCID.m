clear
clc
close all
%
feactorator ='S_H_V_G';
%
prey = imread('./ReferenceSCIs/SCI01.bmp');
%
% prey = double(rgb2gray(prey));
%
feactor_length = length(feval(feactorator, prey, prey));
featrix_FR_SCID = zeros(1800, feactor_length+5);
load('MOS_SCID.mat');
img_idx = 0;
for ref_idx = 1:40
   for dst_idx = 1:9
      for dst_lev = 1:5
          ref_nme = ['SCI', num2str(ref_idx,'%02.f'),'.bmp'];
          ref_pth = ['./ReferenceSCIs/',ref_nme];
          ref_img = imread(ref_pth);
          dst_nme = ['SCI', num2str(ref_idx,'%02.f'),'_',...
              num2str(dst_idx),'_',num2str(dst_lev),'.bmp'];
          dst_pth = ['./DistortedSCIs/', dst_nme];
          dst_img = imread(dst_pth);
          %
          % ref_img = double(rgb2gray(ref_img));
          % dst_img = double(rgb2gray(dst_img));
          %
          begin = tic;
          feactor = feval(feactorator, ref_img, dst_img);
          nigeb = toc(begin);
          img_idx = img_idx+1
          featrix_FR_SCID(img_idx, 1:feactor_length) = feactor;
          featrix_FR_SCID(img_idx, feactor_length+1) = MOS_SCID(img_idx);
          featrix_FR_SCID(img_idx, feactor_length+2) = ref_idx;
          featrix_FR_SCID(img_idx, feactor_length+3) = dst_idx;
          featrix_FR_SCID(img_idx, feactor_length+4) = dst_lev;
          featrix_FR_SCID(img_idx, feactor_length+5) = nigeb;
      end
   end
end
save(['FMX_FR_SCID_',feactorator, '.mat'], 'featrix_FR_SCID');