%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This code implements the proposed salient/co-salient object detection algorithm in the following paper:
% 
% Jing Lou, Fenglei Xu, Qingyuan Xia, Wankou Yang, Mingwu Ren, "Hierarchical Co-salient Object Detection via Color Names,"
% in Proceedings of the Asian Conference on Pattern Recognition (ACPR), pp. 1-7, 2017.
% 
% Project page: http://www.loujing.com/hcn-co-sod/
%
% References:
%   [17] J. Lou, H. Wang, L. Chen, Q. Xia, W. Zhu, and M. Ren, "Exploiting color name space for salient object detection,"
%        arXiv:1703.08912 [cs.CV], pp. 1¨C13, 2017.  http://www.loujing.com/cns-sod/
%   [26] W. Zhu, S. Liang, Y. Wei, and J. Sun, "Saliency optimization from robust background detection,"
%        in Proc. IEEE Conf. Comput. Vis. Pattern Recognit., 2014, pp. 2814¨C2821.
%
%
% Copyright (C) 2017 Jing Lou (Â¥¾º)
% 
% The usage of this code is restricted for non-profit research usage only and using of the code is at the user's risk.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; clear; close all;


%% Add folders to search path
addpath('CNS');
addpath('RBD');
addpath('RBD\Funcs');
addpath('RBD\Funcs\SLIC');
load('w2c.mat');	% color names mapping


%% Parameters
param.delta    = 32;          % sample step
omega_c        = [3, 6, 12];  % kernel radius \omega_c
omega_r        = [5, 9, 17];  % kernel radius \omega_r
param.theta_r  = 0.04;        % saturation ratio \theta_r
param.theta_g  = 1.9;         % gamma \theta_g
param.w_f      = 0.4;         % to control single-layer saliency combination

imgPath        = 'images\';   % image path
imgSuff        = '.bmp';      % image suffix
smPath         = 'HCNs\';     % saliency maps
cosmPath       = 'HCNco\';    % co-saliency maps

% RGB values of 11 color names
ColorNames = [
	0    0    0; 
	0    0    1;
	.5  .4  .25;
	.5  .5   .5;
	0    1    0;
	1   .8    0;
	1   .5    1;
	1    0    1;
	1    0    0;
	1    1    1;
	1    1    0
];


%% Make folders
folders = {'CNS', 'RBD'};
for fno = 1:length(folders)
	for lno = 1:3
		if exist([folders{fno},'\L',int2str(lno)], 'dir') ~= 7
			system(['md ', folders{fno},'\L',int2str(lno)]);
		end
	end
end


%% Saliency maps (HCNs)
imgs = dir([imgPath, '*', imgSuff]);

if exist(smPath, 'dir') ~= 7
	system(['md ', smPath]);
end

fprintf('=======Saliency Maps (HCNs)=======\n');
for imgno = 1:length(imgs)
	t1 = clock;
	imgname = imgs(imgno).name;
	fprintf('%03d/%03d - %s\n\t', imgno, length(imgs), imgname);
	
	img = imread([imgPath, imgname]);
	if ismatrix(img)
		img = repmat(img, [1 1 3]);
	end
	
	[noFrameImg, frameWidth] = removeFrame(img);
	
	% CNS & RBD
	for lno = 1:3
		fprintf('L%d. ', lno);
		% parameters
		param.omega_c = omega_c(lno);
		param.omega_r = omega_r(lno);
		
		% Layer generation
		switch lno
			case 1
				Resize_Width = 100;
			case 2
				Resize_Width = 200;
			case 3
				Resize_Width = 400;
		end
		img_L = imresize(noFrameImg, [nan, Resize_Width]);
		
		% CNS ($\mathcal{L}_{\text{\tiny{CNS}}}^i$)
		cnsName = ['CNS\L',int2str(lno),'\',imgname(1:end-4),'_CNS_L',int2str(lno),'.png'];
		if exist(cnsName, 'file') ~= 2
			smap_CNS = CNS(img_L, param);
			imwrite(smap_CNS, cnsName);
		end
		smap_CNS = imread(cnsName);
		
		% RBD ($\mathcal{L}_{\text{\tiny{RBD}}}^i$)
		rbdName = ['RBD\L',int2str(lno),'\',imgname(1:end-4),'_RBD_L',int2str(lno),'.png'];
		if exist(rbdName, 'file') ~= 2
			RBD(img_L, imgname, lno, param);
		end
		smap_RBD = imread(rbdName);

		% Single-layer combination ($\mathcal{L}_{\text{\tiny{HCN}}}^i$)
		I = ones(size(smap_CNS));
		smap_sLayerCom = (2*exp(-(abs(im2double(smap_CNS)-im2double(smap_RBD))))-2*exp(-I)+I) .* ...
			(param.w_f*im2double(smap_CNS) + (1-param.w_f)*im2double(smap_RBD));
		smap_sLayerCom = im2uint8(smap_sLayerCom);
		
		% Single-layer refinement ($\widetilde{\mathcal{L}}_{\text{\tiny{HCN}}}^i$)
		corr = immultiply(im2double(smap_CNS), im2double(smap_RBD));
		weightMat = mat2gray(calcWeight(img_L));
		smap_sLayerRefine = mat2gray(imreconstruct(corr, imadd(weightMat.^2.*corr.^2, im2double(smap_sLayerCom).^2)).^2);
		smap_sLayerRefine = imadjust(smap_sLayerRefine, [0, mean(smap_sLayerRefine(:))], [0, 1], 1);
		smap_sLayerRefine = imfill(smap_sLayerRefine, 'holes');
		smap_sLayerRefine = mat2gray(smap_sLayerRefine);
		smap_sLayerRefine = im2uint8(smap_sLayerRefine);
		
		% Resize single-layer saliency map to original image size ($\widehat{\mathcal{L}}_{\text{\tiny{HCN}}}^i$)
		if frameWidth ~= 0	
			smap_sLayerFrame = zeros(size(img,1), size(img,2), 'uint8');
			smap_sLayerFrame(frameWidth+1:size(img,1)-frameWidth, frameWidth+1:size(img,2)-frameWidth) = ...
				imresize(smap_sLayerRefine, [size(img,1)-2*frameWidth size(img,2)-2*frameWidth]);
		else
			smap_sLayerFrame = imresize(smap_sLayerRefine, [size(img,1) size(img,2)]);
		end
		smap_sLayerFrame = im2double(smap_sLayerFrame);

		switch lno
			case 1
				smap_mLayerL1 = smap_sLayerFrame;
			case 2
				smap_mLayerL2 = smap_sLayerFrame;
			case 3
				smap_mLayerL3 = smap_sLayerFrame;
		end
	end
	
	% Multi-layer fusion and refinement ($S_s$)
	avgMap = (smap_mLayerL1 + smap_mLayerL2 + smap_mLayerL3) / 3;	% $\overline{\mathcal{L}}_{\text{\tiny{HCN}}}$
	d_1 = mean(mean(abs(avgMap-smap_mLayerL1)));
	d_2 = mean(mean(abs(avgMap-smap_mLayerL2)));
	d_3 = mean(mean(abs(avgMap-smap_mLayerL3)));
	d_bar = (d_1 + d_2 + d_3);
	newMap = (exp(-d_1/d_bar/2).*smap_mLayerL1 + exp(-d_2/d_bar/2).*smap_mLayerL2 + exp(-d_3/d_bar/2).*smap_mLayerL3);
	corr = smap_mLayerL1 .* smap_mLayerL2 .* smap_mLayerL3;
	weightMat = mat2gray(calcWeight(img));
	S_s = imreconstruct(corr, imadd(weightMat.^3.*corr.^3, newMap.^3)).^3;
	% Save saliency maps
	imwrite(S_s, [smPath, imgname(1:end-4), '_HCNs.png']);

	t2 = clock;
	fprintf('(Time: %fs)\n', etime(t2,t1));
end
fprintf('\n');


%% Co-saliency maps (HCNco)
if exist('HCNco', 'dir') ~= 7
	system('md HCNco');
end

fprintf('=======Co-saliency Maps (HCNco)=======\n');
for imgno = 1:length(imgs)
	imgname = imgs(imgno).name;
	
	if strcmp(imgname(end-4),'2')
		tmpname = imgname(1:end-5);
		fprintf('%03d/%03d - %s ', imgno/2, length(imgs)/2, tmpname);
		
		img1 = imread([imgPath, tmpname, '1', imgSuff]);
		img2 = imread([imgPath, tmpname, '2', imgSuff]);
		sm1  = imread([smPath, tmpname, '1_HCNs.png']);
		sm2  = imread([smPath, tmpname, '2_HCNs.png']);
		% Co-saliency maps
		cosm1 = zeros(size(sm1));
		cosm2 = zeros(size(sm2));
		
		% Foreground regions
		bw1 = sm1 > 2*mean(sm1(:));
		bw2 = sm2 > 2*mean(sm2(:));
		regions1 = regionprops(bw1,'PixelList');
		regions2 = regionprops(bw2,'PixelList');
		
		if length(regions1)>1 || length(regions2)>1
			% $A(r_1^i)$
			for ino = 1:length(regions1)
				tmp1 = zeros(size(bw1));
				pixellist = regions1(ino).PixelList;
				for m = 1:size(pixellist,1)
					tmp1(pixellist(m,2),pixellist(m,1)) = 1;
				end
				avgColor = calcFreq(tmp1, img1);
				Ar_1(ino,1:3) = avgColor;
			end
			
			% $A(r_2^j)$
			for jno = 1:length(regions2)
				tmp2 = zeros(size(bw2));
				pixellist = regions2(jno).PixelList;
				for m = 1:size(pixellist,1)
					tmp2(pixellist(m,2),pixellist(m,1)) = 1;
				end
				avgColor = calcFreq(tmp2, img2);
				Ar_2(jno,1:3) = avgColor;
			end
			
			% $D_{ij}$
			Diff = zeros(1,3);
			diffno = 1;
			for ino = 1:length(regions1)
				for jno = 1:length(regions2)
					Diff(diffno,1) = ino;
					Diff(diffno,2) = jno;
					Diff(diffno,3) = norm(Ar_1(ino,1:3) - Ar_2(jno,1:3))^2;
					diffno = diffno + 1;
				end
			end
			
			% $\overline{D}$
			avgDiff = mean(Diff(:,3));
			for dno = 1:size(Diff,1)
				if Diff(dno,3) <= avgDiff
					pixellist1 = regions1(Diff(dno,1)).PixelList;
					for m = 1:size(pixellist1,1)
						cosm1(pixellist1(m,2),pixellist1(m,1)) = sm1(pixellist1(m,2),pixellist1(m,1));
					end
					pixellist2 = regions2(Diff(dno,2)).PixelList;
					for m = 11:size(pixellist2,1)
						cosm2(pixellist2(m,2),pixellist2(m,1)) = sm2(pixellist2(m,2),pixellist2(m,1));
					end
				end
			end
			cosm1 = im2uint8(cosm1);
			cosm2 = im2uint8(cosm2);
		else
			cosm1 = sm1;
			cosm2 = sm2;
		end
		
		% Save co-saliency maps
		cosm1 = imfill(cosm1, 'holes');
		cosm1(cosm1 <= 2*mean(cosm1(:))) = 0;
		cosm2 = imfill(cosm2, 'holes');
		cosm2(cosm2 <= 2*mean(cosm2(:))) = 0;
		imwrite(cosm1, [cosmPath, tmpname, '1_HCNco.png']);
		fprintf('.');
		imwrite(cosm2, [cosmPath, tmpname, '2_HCNco.png']);
		fprintf('.\n');
	end
end
fprintf('\n=======END=======\n\n');


%% Remove folders from search path
rmpath('CNS');
rmpath('RBD');
rmpath('RBD\Funcs');
rmpath('RBD\Funcs\SLIC');



