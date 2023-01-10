% A test script using templeCoords.mat
%
% Write your code here
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Test 3.1.1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Load images and points
im1 = imread('../data/im1.png');
im2 = imread('../data/im2.png');

%% display two images in one window
% figure;
% tiledlayout(1,2);
% nexttile;
% imshow(im1);
% nexttile;
% imshow(im2);

load('../data/someCorresp.mat');  % M, pts1, pts2

%% Compute fundamental matrix F
F = eightpoint(pts1, pts2, M);
% displayEpipolarF(im1, im2, F);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Test 3.1.2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[p2] = epipolarMatchGUI(im1, im2, F);


tc = load('../data/templeCoords.mat');
tc_pts1 = tc.pts1;  %(288,2)
tc_pts2 = zeros(size(tc_pts1));
for i = 1:size(tc_pts2,1)
    pts = tc_pts1(i,:);
    tc_pts2(i,:) = epipolarCorrespondence(im1, im2, F, pts);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Test 3.1.3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('../data/intrinsics.mat');
% load K1: (3,3) double, K2: same size
E = essentialMatrix(F, K1, K2);
disp('E =');
disp(E);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Test 3.1.4 & Test 3.1.5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

extrinsic1 = [1 0 0 0; 0 1 0 0; 0 0 1 0];  % [R|t] -> [I|0]
P1 = K1 * extrinsic1;

extrinsics2 = camera2(E);  % get 4 extrinsic matrix candidates
ext2_1 = extrinsics2(:,:,1);
ext2_2 = extrinsics2(:,:,2);
ext2_3 = extrinsics2(:,:,3);
ext2_4 = extrinsics2(:,:,4);
P2_1 = K2 * ext2_1;
P2_2 = K2 * ext2_2;
P2_3 = K2 * ext2_3;
P2_4 = K2 * ext2_4;
pts3d_1 = triangulate(P1, tc_pts1, P2_1, tc_pts2);
pts3d_2 = triangulate(P1, tc_pts1, P2_2, tc_pts2);
pts3d_3 = triangulate(P1, tc_pts1, P2_3, tc_pts2);
pts3d_4 = triangulate(P1, tc_pts1, P2_4, tc_pts2);

%% check if positive depth (see slide#20-Stereo)
pos_1 = sum(pts3d_1(:,3) > 0);
pos_2 = sum(pts3d_2(:,3) > 0);
pos_3 = sum(pts3d_3(:,3) > 0);
pos_4 = sum(pts3d_4(:,3) > 0);
[val, idx] = max([pos_1, pos_2, pos_3, pos_4]);
disp('optimal_intrinsic2 index:');
disp(idx)
%% Conclusion:
% matrix 2 is the optimal P2

%% pts3d_2 for error calculation
pts3d_2_error = triangulate(P1, pts1, P2_2, pts2);

%% Check re-projection error by 3D-to-2D (x=PX)
% for image 1
x_pts1 = zeros(size(pts1));  % (N,2)
X_pts3d_1 = [pts3d_2_error'; ones(1, size(pts3d_2_error,1))];
x_pts1_ = P1 * X_pts3d_1;
x_pts1_ = x_pts1_' / x_pts1_(3);  % (N,3)
for i = 1: size(x_pts1_,1)
    record1_1by3 = x_pts1_(i,:);
    record1_1by2 = record1_1by3 / record1_1by3(3); 
    x_pts1(i,:) = record1_1by2(1:2);
end
error1 = sqrt(sum((double(x_pts1) - double(pts1)).^2,'all')) / size(x_pts1,1);
disp('Re-projection error for image1 is:')
disp(error1);

% for image 2
x_pts2 = zeros(size(pts2));  % (N,2)
X_pts3d_2 = [pts3d_2_error'; ones(1, size(pts3d_2_error,1))];
x_pts2_ = P2_2 * X_pts3d_2;
x_pts2_ = x_pts2_'; %/ x_pts2(3);  % (N,3)
for i = 1: size(x_pts2_,1)
    record_1by3 = x_pts2_(i,:);
    record_1by2 = record_1by3 / record_1by3(3); 
    x_pts2(i,:) = record_1by2(1:2);
end
error2 = sqrt(sum((double(x_pts2) - double(pts2)).^2,'all')) / size(x_pts2,1);
disp('Re-projection error for image2 is:')
disp(error2);

%% plot
% disp(pts3d_2);
p = plot3(pts3d_2(:,1), pts3d_2(:,2), pts3d_2(:,3), '.');
axis equal

%% Store rotation matrix, transition matrix
R1 = extrinsic1(:, 1:3); %(3,3)
t1 = extrinsic1(:, 4); %(3,1)
R2 = ext2_2(:, 1:3);
t2 = ext2_2(:, 4);

% save extrinsic parameters for dense reconstruction
save('../data/extrinsics.mat', 'R1', 't1', 'R2', 't2');
