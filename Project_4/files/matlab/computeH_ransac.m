function [ bestH2to1, inliers] = computeH_ransac( locs1, locs2)
%COMPUTEH_RANSAC A method to compute the best fitting homography given a
%list of matching points.

N_iter = 3000; % more iter, >1000
idx_candidate = [];
points_cnt = 0;
least_dist = 1e10;
max_count = 0;
bestH = [];


for i = 1:N_iter
    if size(locs1,1) < 4
        idx = randperm(size(locs1,1), size(locs1,1));
    else
        idx = randperm(size(locs1,1), 4);
    end
    x1 = locs1(idx, :);
    x2 = locs2(idx, :);
    h = computeH_norm(x2, x1);  % (3,3)
    tform = projtform2d(h);  %projtform2d  %projective2d
    out = transformPointsForward(tform, locs2);
    %x2_y2_1 = [locs2, ones(size(locs2,1),1)];  % locs2 - makes it (4,3)
    %out = h * transpose(x2_y2_1); %(3,N) 
    %abs_sub = abs(locs1 - transpose(out(1:2,:))); %(N,2)
    abs_sub = abs(locs1 - out);
    lst_dis2norm = []; 

    inliers = [];
    for j = 1:size(locs1,1)
        dis_2norm = norm(abs_sub(j,:), 2);
        lst_dis2norm = [lst_dis2norm, dis_2norm];
%         disp('###');
%         disp(dis_2norm);
%         disp(min(lst_dis2norm));
%         disp(max(lst_dis2norm));
%         disp(median(lst_dis2norm));
        dis_threshold = median(lst_dis2norm); % try numbers, 5,10
%         disp(dis_threshold);
        if  dis_2norm <= dis_threshold
            points_cnt = points_cnt + 1;
            idx_candidate = [idx_candidate, j];  % add idx of points candidates
            inliers = [inliers, 1];
        else
            inliers = [inliers, 0];
        end
    end
    
    %disp(length(idx_candidate));
    if points_cnt == max_count
        if sum(abs_sub,'all') < least_dist
            least_dist = sum(abs_sub,'all');
            max_count = points_cnt;
            x1 = locs1(idx_candidate,:);
            x2 = locs2(idx_candidate,:);
            bestH = computeH_norm(x1,x2);
        end
    elseif points_cnt > max_count
       least_dist = sum(abs_sub,'all');
       max_count = points_cnt;
       x1 = locs1(idx_candidate,:);
       x2 = locs2(idx_candidate,:);
       bestH = computeH_norm(x1,x2);  % computerH_norm()
    end

end


if size(bestH,1) == 0
    bestH2to1 = computeH_norm(x1,x2);
else
bestH2to1= transpose(bestH);
end

% visualization of 4 points
I1 = imread('../data/cv_cover.jpg');
I2 = imread('../data/cv_desk.png');
if size(I1, 3) == 3
I1 = rgb2gray(I1);  
% imshow(I1);
end
if size(I2, 3) == 3
I2 = rgb2gray(I2);  % (548,731), channel removed
% imshow(I2_grey);
end

%% Visualization on 4 point-pairs picked randomly w/ most inliers
% x1_ = locs1(idx, :);
% x2_ = locs2(idx, :);
% figure; 
% fig_4 = showMatchedFeatures(I1, I2, x1_, x2_, 'montage'); 
% title('Randomly Picked 4 Points');
% saveas(fig_4, '../Result/Q4.5_4points.png')


%Q2.2.3
end