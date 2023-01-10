% Your solution to Q2.1.5 goes here!

%% Read the image and convert to grayscale, if necessary
cv_cover = imread('../data/cv_cover.jpg');
if size(cv_cover, 3) == 3
cv_cover = rgb2gray(cv_cover);  
end
% imshow(cv_cover);

%%%% FAST + BRIEF method
%% Compute the features and descriptors
lst = [];
% compute features and descriptors for cv_cover itself
I = cv_cover;
corners_I = detectFASTFeatures(I);
loc_I = corners_I.Location;
[desc_I, locs_I] = computeBrief(I, loc_I);

for i = 0:36
    %% Rotate image
    Ii = imrotate(cv_cover, i*10);
    %% Compute features and descriptors
    corners_Ii = detectFASTFeatures(Ii);
    loc_Ii = corners_Ii.Location;
    [desc_Ii, locs_Ii] = computeBrief(Ii, loc_Ii); 
    %% Match features
    indexPairs = matchFeatures(desc_I, desc_Ii, MatchThreshold=10.0, MaxRatio=0.68); 
    locs1 = loc_I(indexPairs(:,1),:); 
    locs2 = loc_Ii(indexPairs(:,2),:);
    %% Update histogram
    cnt_match = size(indexPairs, 1);
    lst(end+1) = cnt_match;
    %% visualize match result
    if i == 1 || i == 2 || i == 3
    figure;
    fig = showMatchedFeatures(I, Ii, locs1, locs2, 'montage');
    name = ['../Result/Q4.2_BRIEF',num2str(i),'.png'];
    saveas(fig, name);

    end
end

% disp(size(lst));  %(1,37)

%% Display histogram
figure;
fig_BRIEF_his = histogram(lst);
title('BRIEF Method - Histogram');
saveas(fig_BRIEF_his, '../Result/Q4.2_BRIEF_his.png');
figure;
fig_BRIEF_bar = bar(lst);
title('BRIEF Method - Bar Chart');
saveas(fig_BRIEF_bar, '../Result/Q4.2_BRIEF_bar.png');


%%%% SURF method
%% Compute the features and descriptors
lst_surf = [];
% compute features and descriptors for cv_cover itself
Isurf = cv_cover;
corners_Isurf = detectSURFFeatures(Isurf);
loc_Isurf = corners_Isurf.Location;
[desc_Isurf, locs_Isurf] = extractFeatures(Isurf, loc_Isurf, Method='SURF');

for i = 0:36
    %% Rotate image
    Iis = imrotate(cv_cover, i*10);
    %% Compute features and descriptors
    corners_Iis = detectSURFFeatures(Iis);
    loc_Iis = corners_Iis.Location;
    [desc_Iis, locs_Iis] = extractFeatures(Iis, loc_Iis, Method='SURF'); 
    %% Match features
    indexPairs_s = matchFeatures(desc_Isurf, desc_Iis, MatchThreshold=10.0, MaxRatio=0.68); 
    locs1s = loc_Isurf(indexPairs_s(:,1),:); 
    locs2s = loc_Iis(indexPairs_s(:,2),:);
    %% Update histogram
    cnt_match_s = size(indexPairs_s, 1);
    lst_surf(end+1) = cnt_match_s;
    %% visualize match result
    if i == 1 || i == 2 || i == 3
    figure;
    fig = showMatchedFeatures(Isurf, Iis, locs1s, locs2s, 'montage');
    name = ['../Result/Q4.2_SURF',num2str(i),'.png'];
    saveas(fig, name);
    end
end

%% Display histogram
figure;
fig_SURF_his = histogram(lst_surf);
title('SURF Method - Histogram');
saveas(fig_SURF_his, '../Result/Q4.2_SURF_his.png');
figure;
fig_SURF_bar = bar(lst_surf);
title('SURF Method - Bar Chart');
saveas(fig_SURF_bar, '../Result/Q4.2_SURF_bar.png');