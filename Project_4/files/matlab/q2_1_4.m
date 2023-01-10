%Q2.1.4
close all;
clear all;

cv_cover = imread('../data/cv_cover.jpg');
cv_desk = imread('../data/cv_desk.png');
% disp(size(cv_cover));  % (440,350)
% disp(size(cv_desk));  % (548, 731, 3)
% imshow(cv_desk) 

[locs1, locs2] = matchPics(cv_cover, cv_desk);

figure;
fig = showMatchedFeatures(cv_cover, cv_desk, locs1, locs2, 'montage');
title('Showing all matches');
fig;
saveas(fig, '../Result/Q4_1.png');