%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Jing Lou, Fenglei Xu, Qingyuan Xia, Wankou Yang, Mingwu Ren, "Hierarchical Co-salient Object Detection via Color Names,"
% in Proceedings of the Asian Conference on Pattern Recognition (ACPR), pp. 1-7, 2017.
% 
% Project page: http://www.loujing.com/hcn-co-sod/
%
% Copyright (C) 2017 Jing Lou (Â¥¾º)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [noFrameImg, frameWidth] = removeFrame(img)
%REMOVEFRAME removes image frame
%   IMG has no frame if FRAMEWIDTH equals to zero
%   The border width is assumed to be fixed and no more than 15 pixels

if ndims(img) == 3
	gray = rgb2gray(img);
else
	gray = img;
end
[Height, Width] = size(gray);

MaxFrame  = 15;
threshold = 0.7;

edgeMap = edge(gray, 'canny');
hasFrame  = false;
frame = zeros(1,4);

% TOP
edgeDensity = mean(edgeMap(1:MaxFrame, :), 2);
topRowIdx = find(edgeDensity>threshold, 1, 'last');
if ~isempty(topRowIdx)
	frame(1) = topRowIdx;
	hasFrame = true;
end

% BOTTOM
edgeDensity = mean(edgeMap(Height-MaxFrame+1:Height, :), 2);
bottomRowIdx = find(edgeDensity>threshold, 1, 'first');
if ~isempty(bottomRowIdx)
	frame(2) = MaxFrame - bottomRowIdx + 1;
	hasFrame = true;
end

% LEFT
edgeDensity = mean(edgeMap(:, 1:MaxFrame), 1);
leftColIdx = find(edgeDensity>threshold, 1, 'last');
if ~isempty(leftColIdx)
	frame(3) = leftColIdx;
	hasFrame = true;
end

% RIGHT
edgeDensity = mean(edgeMap(:, Width-MaxFrame+1:Width), 1);
rightColIdx = find(edgeDensity>threshold, 1, 'first');
if ~isempty(rightColIdx)
	frame(4) = MaxFrame - rightColIdx + 1;
	hasFrame = true;
end


if hasFrame
	frameWidth = max(frame);
	noFrameImg = img(frameWidth+1:Height-frameWidth, frameWidth+1:Width-frameWidth, :);
else
	frameWidth = 0;
	noFrameImg = img;
end

end