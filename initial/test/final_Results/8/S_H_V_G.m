function feactor = S_H_V_G( r, d )
%V_S_G_V_S encodes the similarity of two images in a feature vector

% to execute VIF, a path to the folder 'matlabPyrTools-master' and all its
% sub-directories must be added.
% addpath(genpath('/media/pooryaa/New Volume/Chetoani_FR/IFC/Copy_of_= IFC/ifcvec_release/matlabPyrTools-master'));
addpath(genpath('E:\== Chetoani_FR\IFC\Copy_of_= IFC\ifcvec_release\matlabPyrTools-master'));

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

%% HaarPSI
HaarPSI_score = HaarPSI(r_rgb, d_rgb);
%% GMSD
GMSD_score = GMSD(r_gry, d_gry);

%% VIF
VIF_score = vifvec(r_gry, d_gry);

%% vec

feactor = [SQMS_score, HaarPSI_score, (1-GMSD_score), VIF_score];
end

