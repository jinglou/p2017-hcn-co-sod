%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Jing Lou, Fenglei Xu, Qingyuan Xia, Wankou Yang, Mingwu Ren, "Hierarchical Co-salient Object Detection via Color Names,"
% in Proceedings of the Asian Conference on Pattern Recognition (ACPR), pp. 718-724, 2017. (Spotlight)
% 
% Project page: http://www.loujing.com/hcn-co-sod/
%
% References:
%   [17] J. Lou, H. Wang, L. Chen, Q. Xia, W. Zhu, and M. Ren, "Exploiting color name space for salient object detection,"
%        arXiv:1703.08912 [cs.CV], pp. 1¨C13, 2017.  http://www.loujing.com/cns-sod/
%
%
% Copyright (C) 2017 Jing Lou (Â¥¾º)
% 
% The usage of this code is restricted for non-profit research usage only and using of the code is at the user's risk.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function avgColor = calcFreq(bw, img)
%CALCFREQ exploits color names to compute the average RGB color values (3-D) of a foreground region,
% which is generated using the corresponding binary image BW and the original input image IMG

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