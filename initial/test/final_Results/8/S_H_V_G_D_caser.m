function feactor = S_H_V_G_D_caser( r, d, in_case )
%V_S_G_V_S encodes the similarity of two images in a feature vector

% to execute VIF, a path to the folder 'matlabPyrTools-master' and all its
% sub-directories must be added.
% addpath(genpath('/media/pooryaa/New Volume/Chetoani_FR/IFC/Copy_of_= IFC/ifcvec_release/matlabPyrTools-master'));
% addpath(genpath('E:\== Chetoani_FR\IFC\Copy_of_= IFC\ifcvec_release\matlabPyrTools-master'));
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

%% HaarPSI
HaarPSI_score = HaarPSI(r_rgb, d_rgb);
%% GMSD
GMSD_score = GMSD(r_gry, d_gry);

%% VIF
VIF_score = vifvec(r_gry, d_gry);

%% DIQA
LBPSI_score = LBPSI(r_rgb, d_rgb);
%% vec
mother_feactor = [SQMS_score, HaarPSI_score, (1-GMSD_score), VIF_score, LBPSI_score];
child_feactor = [HaarPSI_score, (1-GMSD_score), VIF_score, LBPSI_score];
load('combinations.mat');
% load('contributors.mat');
switch nargin
    case 2
        the_case =0;
        feactor = mother_feactor;
    case 3
        the_case = in_case;
end
for ii = 1:size(combinations, 1)
   if ii == the_case
      attach = child_feactor(combinations{ii,:});
      feactor = [SQMS_score, attach];
%       disp(contributors{ii,1})
   end
end

end

