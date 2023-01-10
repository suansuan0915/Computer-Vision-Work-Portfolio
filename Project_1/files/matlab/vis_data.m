layers = get_lenet();
load lenet.mat
% load data
% Change the following value to true to load the entire dataset.
fullset = false;
[xtrain, ytrain, xvalidate, yvalidate, xtest, ytest] = load_mnist(fullset);
xtrain = [xtrain, xvalidate];
ytrain = [ytrain, yvalidate];
m_train = size(xtrain, 2);  % number of images
batch_size = 64;
 
 
layers{1}.batch_size = 1;
img = xtest(:, 1);  % select 1 image from xtest set
img = reshape(img, 28, 28);
figure(100);
imshow(img');
 
%[cp, ~, output] = conv_net_output(params, layers, xtest(:, 1), ytest(:, 1));
output = convnet_forward(params, layers, xtest(:, 1));  % layers' data
output_1 = reshape(output{1}.data, 28, 28);
% Fill in your code here to plot the features.
l = length(layers);

for i = 2:l
    %if strcmpi(layer{i}.type, 'CONV') || strcmpi(layer{i}.type, 'RELU')
    % 1 batch (1 image)
    if i == 2 || i == 3
        plot_data = output{i}.data;
        disp(size(plot_data));  % 11520, 1
        c = output{i}.channel;
        h_out = output{i}.height;
        w_out = output{i}.width;
        disp(h_out);
        disp(w_out);
        disp(c);
        plot_data = reshape(plot_data, [h_out, w_out, c]); % 24,24,20  picture: 2D matrix
        figure(i);

        for j = 1:c
                subplot(4, 5, j);
                image = plot_data(:,:,j);
                imshow(image');
        end
    end
end

