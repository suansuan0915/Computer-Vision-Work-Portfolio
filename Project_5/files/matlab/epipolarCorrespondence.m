function [pts2] = epipolarCorrespondence(im1, im2, F, pts1)
% epipolarCorrespondence:
%   Args:
%       im1:    Image 1. (640,480)
%       im2:    Image 2
%       F:      Fundamental Matrix from im1 to im2. (3,3)
%       pts1:   coordinates of points in image 1. (110,2)
%   Returns:
%       pts2:   coordinates of points in image 2
%

%% Get point on epipolar line l 
% one point comes in each time
% images are 3d
p1 = round([pts1'; 1]);
l = F * p1;  % l = [a;b;c], line ax+by+c=0
l = l / -l(2);  % for p2 construction

%% select window around point p1
x1 = p1(1);
y1 = p1(2);
%window1 = im1(y1-5: y1+5, x1-5: x1+5, :);  % (5,5,3)
i = 0;
h = size(im1,1);
w = size(im1,2);

for x2 = p1(1)-50:p1(1)+50
    i = i+1;
    y2 = round(l(1) * x2 + l(3));
    p2 = round([x2,y2,1]);

    %% contraint range
    if y2 > 5
        y_bot2 = y2-5;
    else
        y_bot2 = 1;
    end
    if y2 < h-5
        y_up2 = y2+5;
    else
        y_up2 = h;
    end

    if x2 > 5
        x_bot2 = x2-5;
    else
        x_bot2 = 1;
    end
    if x2 < w-5
        x_up2 = x2+5;
    else
        x_up2 = w;
    end

    if y1 > 5 
        y_bot1 = y1-5;
    else
        y_bot1 = 1;
    end
    if y1 < h-5
        y_up1 = y1+5;
    else
        y_up1 = h;
    end

    if x1 > 5
        x_bot1 = x1-5;
    else
        x_bot1 = 1;
    end
    if x1 < w-5
        x_up1 = x1+5;
    else
        x_up1 = w;
    end
    
    y_dif = min((y_up1-y_bot1), (y_up2-y_bot2));
    x_dif = min((x_up1-x_bot1), (x_up2-x_bot2));
    %window1 = im1(y_bot1: y_up1, x_bot1: x_up1, :);
    %window2 = im2(y_bot2: y_up2, x_bot2: x_up2, :);
    window1 = im1(y_bot1: (y_bot1+y_dif), x_bot1: (x_bot1+x_dif), :);
    window2 = im2(y_bot2: (y_bot2+y_dif), x_bot2: (x_bot2+x_dif), :);

    distance = sqrt(sum((double(window1) - double(window2)).^2,'all'));

    if i == 1
        pts2 = [p2(1), p2(2)];
        distance_thre = distance;
    end
    
    if distance < distance_thre
        distance_thre = distance;
        pts2 = [p2(1), p2(2)];
    end

end
