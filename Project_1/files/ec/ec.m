%% Network defintion
layers = get_lenet();
layers{1}.batch_size = 1;
image_num = 4;
load lenet.mat;

for i = 1: image_num
    % read images
    if i == 3
        path = strcat('../images/', 'image', num2str(i), '.png');
    else
    path = strcat('../images/', 'image', num2str(i), '.jpg');
    end
    img = imread(path);
    %figure;
    %imshow(img);  
    %disp(size(img));  % check if input image is greyscale; otherwise, convert from RGB to greyscale
    if size(img, 3) > 1
        img = rgb2gray(img);
    end
    
    level = graythresh(img);
    %disp(level);
    img_bi = ~imbinarize(img, level);  % reverse black white colors
    img_bi = bwareaopen(img_bi, 20);  % remove small objects in binary image (3rd image)
    figure;
    imshow(img_bi);

    %cc = bwconncomp(img_bi);
    %disp(cc);
    [L, n] = bwlabel(img_bi);
    stats = regionprops(L, 'BoundingBox');  % (objects_num, 1) for each input: 6,1
    %regionprops() return each w/ 1-by-2Q BoundingBox [x, y, width, height]
    %disp(stats(1).BoundingBox);  % [0.0005    0.0005    2.7390    0.2940]

    %% plot bounding boxes
    objects_num = size(stats,1);
    %figure;
    for j = 1 : objects_num
    rectangle('Position', stats(j).BoundingBox, 'EdgeColor', 'r');  % boxes only cover some parts
    end

    digits_for_test = zeros(28, 28, objects_num);
    figure;
    for k = 1: objects_num
        box = stats(k).BoundingBox;
        digit_img = imcrop(L, box);
        %% padding
        [h, w] = size(digit_img);
        if h > w
            pad_img = padarray(digit_img, [0, round((h-w)/2)], 0);
        else
            pad_img = padarray(digit_img, [round((w-h)/2), 0], 0);
        end
        pad_img = padarray(pad_img, ceil(0.2 * [h,w]), 0);

        %disp(size(digit_img));
        dig_img_rs = imresize(pad_img, [28, 28])';
        img_m = im2col(dig_img_rs, [28 28]);  % 784,1
        img_m = reshape(img_m, [28,28]);
        %imshow(img_m);
        digits_for_test(:,:, k) = img_m;
        subplot(1, objects_num, k);
        imshow(img_m);
    end
    
    %% prediction part
    predicted = zeros(1, objects_num);
    for a = 1: objects_num
        d_for_test = digits_for_test(:,:,a);
        d_for_test = reshape(d_for_test, [28*28, 1]);
        [output, P] = convnet_forward(params, layers, d_for_test);
        [val, idx] = max(P); 
        predicted(:, a) = idx; 
    end

    predicted_num = predicted-1;
    disp(strcat('Predicted for input image_',' ', num2str(i), ':'));
    disp(predicted_num);
end