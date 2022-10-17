function [score, LBP_S_M, W] = LBPSI( ref_in, dst_in, T_in, alpha_in)
%LBPSI is an implementation for Alaie's 2016 paper.
%   The function receives two images as arguments and returns their texture
%   similarity index. The arguments 'T_in' and 'alpha_in' are optional. 
%   cite: Alaei, Alireza, Donatello Conte, Michael Blumenstein, and Romain 
%   Raveaux. "Document image quality assessment based on texture similarity
%   index." In 2016 12th IAPR Workshop on Document Analysis Systems (DAS), 
%   pp. 132-137. IEEE, 2016.
switch nargin
    case 2
        ref = ref_in;
        dst = dst_in;
        T = 0.01;
        alpha = 0.3;
    case 3
        ref = ref_in;
        dst = dst_in;
        T = T_in;
        alpha = 0.3;
    case 4
        ref = ref_in;
        dst = dst_in;
        T = T_in;
        alpha = alpha_in;
end
%% preprocessing
if length(size(ref))>2
    ref = double(rgb2gray(ref));
    dst = double(rgb2gray(dst));
else
    ref = double(ref);
    dst = double(ref);
end
if max(max(ref))<=1
    ref = ref*255;
    dst = dst*255;
end
Down_step = 2;
aveKernel = fspecial('average',2);
ave_ref = conv2(ref, aveKernel,'same');
ave_dst = conv2(dst, aveKernel,'same');
R = ave_ref(1:Down_step:end,1:Down_step:end);
D = ave_dst(1:Down_step:end,1:Down_step:end);
%% LBP_256 similarity maps
LBP_M_R = double(lbp_new(R, 1, 8, 0, 'x'));
LBP_M_D = double(lbp_new(D, 1, 8, 0, 'x'));
LBP_S_M = (2*LBP_M_R.*LBP_M_D + T) ./(LBP_M_R.^2+...
    LBP_M_D.^2 + T);
LBP_H_R = lbp_new(R, 1, 8, 0, 'hist');
LBP_H_D = lbp_new(D, 1, 8, 0, 'hist');
LBP_S_H = (2*LBP_H_R.*LBP_H_D + T) ./(LBP_H_R.^2+...
    LBP_H_D.^2 + T);
%% pooling
dx = [1 0 -1; 1 0 -1; 1 0 -1]/3;
dy = dx';
IxY1 = conv2(R, dx, 'same');     
IyY1 = conv2(R, dy, 'same');    
gradientMap1 = sqrt(IxY1.^2 + IyY1.^2);
IxY2 = conv2(D, dx, 'same');     
IyY2 = conv2(D, dy, 'same');
gradientMap2 = sqrt(IxY2.^2 + IyY2.^2);
W = max(gradientMap1, gradientMap2);
W = W(2:end-1, 2:end-1);
LBP_S_M_W = LBP_S_M.*W;
LBP_SIM_M_W = sum(sum(LBP_S_M_W))/sum(sum(W));
LBP_SIM_H = sum(LBP_S_H)/256;
score = (alpha*LBP_SIM_H)+((1-alpha)*LBP_SIM_M_W);
end