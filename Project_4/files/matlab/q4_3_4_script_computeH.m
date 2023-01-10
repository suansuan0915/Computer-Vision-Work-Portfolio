%% Script Testing Q4.3. Homography Computation

%% read images
cv_cover = imread('../data/cv_cover.jpg');
cv_desk = imread('../data/cv_desk.png');

%% get match points
[x1, x2] = matchPics(cv_cover, cv_desk);
H2to1 = computeH(x1, x2);  % uncomment for Q4.3
% H2to1 = computeH_norm(x1, x2);  % uncomment for Q4.4

% select 10 random points
out = [];
idx = randperm(11, 10);
in = [x1(idx,1), x1(idx,2)];  %(10,2)

for i = 1:size(idx,2)
% disp(idx(i));  % must keep same order w/ idx
x_ = x1(idx(i), 1);
y_ = x1(idx(i), 2);
coord = H2to1 * [x_;y_;1];
coord = coord / coord(3);
xycoord = transpose(coord(1:2,:));
out = vertcat(out, xycoord);
end

%% plot
figure;
fig = showMatchedFeatures(cv_cover, cv_desk, in, out, 'montage');
saveas(fig, '../Result/Q4.3_computeH.png');
% saveas(fig, '../Result/Q4.4_computeH_norm.png');