%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This code is for [1], and can only be used for non-comercial purpose. If
% you use our code, please cite [1].
% 
% Code Author: Wangjiang Zhu
% Email: wangjiang88119@gmail.com
% Date: 3/24/2014
% 
% [1] Wangjiang Zhu, Shuang Liang, Yichen Wei, and Jian Sun. Saliency Optimization from Robust Background Detection.
%     In CVPR, 2014.
% 
%
% Notes (Jing Lou):
%   - In order to integrate RBD into the proposed HCN model, we remove some
%     codes and produce a simplified version as follows:
%       1. To generate 3 single-layer saliency maps, we directly feed the 
%          three layers (noFrameImg) to the superpixel segmentation module.
%       2. We add a module for adjustment of intensity of the resultant
%          single-layer saliency maps (Line #60).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function RBD(img, imgname, layer, param)

useSP = true;		% You can set useSP = false to use regular grid for speed consideration

[h, w, ~] = size(img);
frameRecord = [h, w, 1, h, 1, w];

% Segment input rgb image into patches (SP/Grid)
pixNumInSP = 600;                           %pixels in each superpixel
spnumber = round( h * w / pixNumInSP );     %super-pixel number for current image

if useSP
	[idxImg, adjcMatrix, pixelList] = SLIC_Split(img, spnumber);
else
	[idxImg, adjcMatrix, pixelList] = Grid_Split(img, spnumber);
end

% Get super-pixel properties
spNum = size(adjcMatrix, 1);
meanRgbCol = GetMeanColor(img, pixelList);
meanLabCol = colorspace('Lab<-', double(meanRgbCol)/255);
meanPos = GetNormedMeanPos(pixelList, h, w);
bdIds = GetBndPatchIds(idxImg);
colDistM = GetDistanceMatrix(meanLabCol);
posDistM = GetDistanceMatrix(meanPos);
[clipVal, geoSigma, neiSigma] = EstimateDynamicParas(adjcMatrix, colDistM);

% Saliency Optimization
[bgProb, bdCon, bgWeight] = EstimateBgProb(colDistM, adjcMatrix, bdIds, clipVal, geoSigma);
wCtr = CalWeightedContrast(colDistM, posDistM, bgProb);
optwCtr = SaliencyOptimization(adjcMatrix, bdIds, colDistM, neiSigma, bgWeight, wCtr);

smapName = ['RBD\L',int2str(layer),'\',imgname(1:end-4),'_RBD_L',int2str(layer),'.png'];
SaveSaliencyMap(optwCtr, pixelList, frameRecord, smapName, true);


%% Adjust image intensity values (Jing Lou)
tmpsmap = imread(smapName);
tmpsmap = im2uint8(tmpsmap);
X = adjust(tmpsmap, param.theta_r, param.theta_g);
imwrite(X, smapName);

end