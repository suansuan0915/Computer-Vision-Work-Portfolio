%% Network defintion
layers = get_lenet();
layers{1}.batch_size = 1;
load lenet.mat;

nums_y = [6, 2, 1, 0, 7];
fig_length = length(nums_y);
%classes_y = nums_y + 1  (classes starts from 0)
predicted = zeros(1, fig_num);
prob = zeros(1, fig_num);

for i = 1:fig_length
    i_path = strcat('../images/real_test/', 'f', num2str(i), '.jpg');
    f = imread(i_path);
    if size(f, 3) > 1
         f_bw = rgb2gray(f);
    end
    f_bw_reverse = imcomplement(f_bw);  % reverse colors
    f_bw_reverse_sized = imresize(f_bw_reverse, [28,28]);
    f_ = transpose(f_bw_reverse_sized);
    f_ = reshape(f_, 28*28, 1);
    [output, P] = convnet_forward(params, layers, f_);
    %disp(size(P));  % 10,1
    %disp(P);
    [val, idx] = max(P); % idx is class
    predicted(:, i) = idx; 
    prob(:, i) = P(idx);
end

predicted_num = predicted - 1;
acc = sum((nums_y) == predicted_num) / fig_length;

disp('Predicted classes are:');
disp(predicted);
disp('Predicted numbers are:');
disp(predicted_num);
disp('Probabilities:');
disp(prob);
disp('Actual numbers:');
disp(nums_y);
disp('predction accuracy:')
disp(acc)
