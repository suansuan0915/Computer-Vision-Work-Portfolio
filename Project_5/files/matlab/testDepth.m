clear all ;
% Load image and paramters
im1 = imread('../data/im1.png');
im2 = imread('../data/im2.png');
im1 = rgb2gray(im1);
im2 = rgb2gray(im2);
load('rectify.mat', 'M1', 'M2', 'K1n', 'K2n', 'R1n', 'R2n', 't1n', 't2n');
% imshow(im1);  % (640,480)

%% rectification
%% comment out this block if no-rectification
[imL imR bbL bbR] = warp_stereo(im1, im2, M1, M2);
% disp(size(imL)); %(668,911)
% imshow(imL);  % about half is black
im1 = imL(:, 1: 515);  %change crop size to change disparity
im2 = imR(:, end-515:end);  
im1 = flip(im1,1);
im1 = flip(im1,2);
% figure;
% imshow(im1);
im2 = flip(im2,1);
im2 = flip(im2,2);
% figure;
% imshow(im2);

maxDisp = 20; 
windowSize = 3;
dispM = get_disparity(im1, im2, maxDisp, windowSize);

% --------------------  get depth map

depthM = get_depth(dispM, K1n, K2n, R1n, R2n, t1n, t2n);


% --------------------  Display

figure; imagesc(dispM.*(im1>40)); colormap(gray); axis image;
figure; imagesc(depthM.*(im1>40)); colormap(gray); axis image;
