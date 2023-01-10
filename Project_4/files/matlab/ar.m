% Q3.3.1
arsource_frames = loadVid('../data/ar_source.mov');  %511 frames, (360,640)
book_frames = loadVid('../data/book.mov');  %641 frames
clc;
cover_img = imread('../data/cv_cover.jpg');
% book_aspect_h = size(book_frames(1).cdata, 1);  %(480,640,3) -> (480,640)
% book_aspect_w = size(book_frames(1).cdata, 2); 
v = VideoWriter('../Result/ar.avi');
open(v);
for i = 1:length(arsource_frames)
    frame_data = arsource_frames(i).cdata;
    book_data = book_frames(i).cdata;
    %imshow(book_data);
    [locs1, locs2] = matchPics(cover_img, book_data);
    [bestH2to1, inliers] = computeH_ransac(locs1, locs2);  
%     bestH2to1 = computeH_norm(locs1, locs2);

    crop_ar = frame_data(45:315, 210:430, :);
    scaled_crop_ar = imresize(crop_ar, [size(cover_img,1) size(cover_img,2)]); 
    %imshow(scaled_crop_ar);  %(440,350,3)
    imshow(warpH(scaled_crop_ar, inv(bestH2to1), size(book_data)));
    video_frame = compositeH(transpose(bestH2to1), scaled_crop_ar, book_data);
    imshow(video_frame);
    writeVideo(v, video_frame);
    disp(i);
end

close(v);

