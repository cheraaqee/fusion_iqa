function feactor = V_S_G_V_S( r, d )
%V_S_G_V_S encodes the similarity of two images in a feature vector

% to execute VIF, a path to the folder 'matlabPyrTools-master' and all its
% sub-directories must be added.
addpath(genpath('./matlabPyrTools-master'));

if length(size(r))>2
    r_gry = double(rgb2gray(r));
    d_gry = double(rgb2gray(d));
    r_rgb = r;
    d_rgb = d;
else
    r_gry = r;
    d_gry = d;
    r_rgb = r;
    d_rgb = d;
end
%% SQMS
SQMS_score = SQMS(r_gry, d_gry);

%% VSI
VSI_score = VSI(r_rgb, d_rgb);

%% SSIM
SSIM_score = ssim(r_gry, d_gry);

%% GMSD
GMSD_score = GMSD(r_gry, d_gry);

%% VIF
VIF_score = vifvec(r_gry, d_gry);

%% vec

feactor = [SQMS_score, VSI_score, SSIM_score, GMSD_score, VIF_score];
end

