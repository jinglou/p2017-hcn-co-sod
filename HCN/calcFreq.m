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
% Copyright (C) 2017 Jing Lou (Â¥¾º)
% 
% The usage of this code is restricted for non-profit research usage only and using of the code is at the user's risk.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [freq, avgColor] = calcFreq(bw, img)
w2c = evalin('base','w2c');
ColorNames = evalin('base','ColorNames');

cnimg = im2c(double(img),w2c,0);
cnimg_new = cnimg.*im2double(bw);

freq = zeros(11,1);
for k = 1:11
	freq(k) = length(find(cnimg_new==k));
end
freq = freq/sum(freq);

avgColor = [0 0 0];
for k = 1:11
	avgColor = avgColor + freq(k).*ColorNames(k,1:3);
end
end