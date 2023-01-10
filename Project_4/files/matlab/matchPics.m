function [ locs1, locs2] = matchPics( I1, I2 )
%MATCHPICS Extract features, obtain their descriptors, and match them!

%% Convert images to grayscale, if necessary
if size(I1, 3) == 3
I1 = rgb2gray(I1);  
% imshow(I1);
end
if size(I2, 3) == 3
I2_grey = rgb2gray(I2);  % (548,731), channel removed
% imshow(I2_grey);
end

%% Detect features in both images
corners_I1 = detectFASTFeatures(I1);
%%% view I1 detected features
% figure;
% imshow(I1); hold on;
% plot(corners_I1);
% % plot(corners_I1.selectStrongest(150));

corners_I2 = detectFASTFeatures(I2_grey);
%%% view I2 detected features
% figure;
% imshow(I2_grey); hold on;
% plot(corners_I2);
% % plot(corners_I2.selectStrongest(150));
% disp(corners_I1);  % cornerPoints object: Location (m*2 matrix), Metric, count

%% Obtain descriptors for the computed feature locations
loc_I1 = corners_I1.Location;
loc_I2 = corners_I2.Location;
[desc_I1, locs_I1] = computeBrief(I1, loc_I1);  % (579,258)
[desc_I2, locs_I2] = computeBrief(I2_grey, loc_I2);   % (294,258)

%% Match features using the descriptors
indexPairs = matchFeatures(desc_I1, desc_I2, MatchThreshold=10.0, MaxRatio=0.68);  
% disp(size(indexPairs));  % (18,2) for MaxRatio=0.7, (11,2) for 0.68
locs1 = locs_I1(indexPairs(:,1),:); 
locs2 = locs_I2(indexPairs(:,2),:); 

%% show greyscale imgs match
% figure; ax = axes;
% showMatchedFeatures(I1, I2_grey, locs1, locs2, 'montage', Parent=ax);  

end

