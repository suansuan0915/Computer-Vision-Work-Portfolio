function dispM = get_disparity(im1, im2, maxDisp, windowSize)
% GET_DISPARITY creates a disparity map from a pair of rectified images im1 and
%   im2, given the maximum disparity MAXDISP and the window size WINDOWSIZE.
w = (windowSize-1)/2;
dispM = zeros(size(im1));

%% pad images <- coordinates below
im1 = im2double(im1);
im2 = im2double(im2);
im1_pad = padarray(im1, [w,w], 0, 'both');  %(670, 458)
im2_pad = padarray(im2, [w,w], 0, 'both');  %(670, 457)
% disp(size(im1_pad));
for y = 1:size(im1,1)
    for x = 1:size(im1,2)
        y_ = y + w;
        x_ = x + w;
        im1_w = im1_pad(y_-w: y_+w, x_-w:x_+w);  % keep 2w difference, same as the formula

        d = 0;
        i = 0;
        for pad = max(w+1, x_-maxDisp): x_  % idx on pos1 must > 0
            i = i + 1;
            im2_w = im2_pad(y_-w: y_+w, pad-w: pad+w);
            distance = sqrt(sum(sum((im1_w - im2_w) .^ 2)));
            if i == 1
                min_dist = distance;
            end
            if distance <= min_dist
                min_dist = distance;
                d = x_ - pad;
            end
        end
        dispM(y,x) = d;
    end

end

end

