function [score, quality_mapdir] = sim_GM_sim_DN_w(Y1_in_in, Y2_in_in, TT_in)
switch nargin
    case 2
        Y1_in = Y1_in_in;
        Y2_in = Y2_in_in;
        TT = 150;
    case 3
        Y1_in = Y1_in_in;
        Y2_in = Y2_in_in;
        TT = TT_in;
end
if length(size(Y1_in))>2
    Y1 = double(rgb2gray(Y1_in));
    Y2 = double(rgb2gray(Y2_in));
else
    Y1 = Y1_in;
    Y2 = Y2_in;
end

T = 170; 
Down_step = 2;
dx = [1 0 -1; 1 0 -1; 1 0 -1]/3;
dy = dx';

aveKernel = fspecial('average',2);
aveY1 = conv2(Y1, aveKernel,'same');
aveY2 = conv2(Y2, aveKernel,'same');
Y1 = aveY1(1:Down_step:end,1:Down_step:end);
Y2 = aveY2(1:Down_step:end,1:Down_step:end);

IxY1 = conv2(Y1, dx, 'same');     
IyY1 = conv2(Y1, dy, 'same'); 
dirY1=atan2d(IyY1,IxY1)+180;
gradientMap1 = sqrt(IxY1.^2 + IyY1.^2);

IxY2 = conv2(Y2, dx, 'same');     
IyY2 = conv2(Y2, dy, 'same');
dirY2=atan2d(IyY2,IxY2)+180;

gradientMap2 = sqrt(IxY2.^2 + IyY2.^2);
quality_mapdir = (2*dirY1.*dirY2 + TT) ./(dirY1.^2+dirY2.^2 + TT);
quality_map = (2*gradientMap1.*gradientMap2 + T) ./(gradientMap1.^2+gradientMap2.^2 + T);
% score1 = std2(quality_map);
% score2 = std2(quality_mapdir);
% score=(2*score1*score2)/(score1+score2+0.01);
%score=score1*score2;

% T1 = 0.85;  %fixed
% T2 = 160; %fixed
% PCSimMatrix = (2 * PC1 .* PC2 + T1) ./ (PC1.^2 + PC2.^2 + T1);
% gradientSimMatrix = (2*gradientMap1.*gradientMap2 + T2) ./(gradientMap1.^2 + gradientMap2.^2 + T2);
Gm = max(gradientMap1, gradientMap2);
SimMatrix = quality_mapdir .* quality_map .* Gm;
score = sum(sum(SimMatrix)) / sum(sum(Gm));
