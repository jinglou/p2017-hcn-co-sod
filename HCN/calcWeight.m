%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This code implements the HCN salient/co-salient object detection algorithm in the following paper:
% 
% Jing Lou, Fenglei Xu, Qingyuan Xia, Wankou Yang, Mingwu Ren, "Hierarchical Co-salient Object Detection via Color Names,"
% in Proceedings of the Asian Conference on Pattern Recognition (ACPR), pp. 1-7, 2017.
% 
% Project page: http://www.loujing.com/hcn-co-sod/
%
%
% Copyright (C) 2017 Jing Lou (¥��)
% 
% The usage of this code is restricted for non-profit research usage only and using of the code is at the user's risk.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function weightMat = calcWeight(noframeimg)

w2c = evalin('base','w2c');
ColorNames = evalin('base','ColorNames');

% Color Name Image
cnimg = im2c(double(noframeimg),w2c,0);

C = unique(cnimg(:));
color_count = zeros(11,1);
for k = 1:length(C)
	color_count(C(k)) = length(find(cnimg(:)==C(k)));
end

frequency = color_count/size(noframeimg,1)/size(noframeimg,2);

weight = zeros(11,1);
for k = 1:11
	if frequency(k) == 0
		weight(k) = 0;
	else
		for p = 1:11
			weight(k) = weight(k) + frequency(p)*norm(double(ColorNames(k,:))-double(ColorNames(p,:)))^2;
		end
	end
end

tmp = zeros(size(noframeimg,1), size(noframeimg,2));
for k = 1:11
	ind = cnimg(:)==k;
	tmp(ind) = weight(k);
end
weightMat = tmp;
end