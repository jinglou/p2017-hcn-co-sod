%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Jing Lou, Fenglei Xu, Qingyuan Xia, Wankou Yang, Mingwu Ren, "Hierarchical Co-salient Object Detection via Color Names,"
% in Proceedings of the Asian Conference on Pattern Recognition (ACPR), pp. 1-7, 2017.
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

function X = adjust(I, ratio, gamma)
%ADJUST intensity values of I, please see Ref. [17]

C = unique(I(:));
tmpsum = 0;
for k = 1:length(C)
	tmpsum = tmpsum + length(find(I==C(k)));
	if tmpsum >= numel(I) * (1-ratio)
		break;
	end
end
if C(k) > 0
	X = imadjust(I, [0,double(C(k))/255], [0,1], gamma);
else
	X = I;
end
end