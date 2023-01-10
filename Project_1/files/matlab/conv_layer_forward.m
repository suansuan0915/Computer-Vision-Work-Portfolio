function [output] = conv_layer_forward(input, layer, param)
% Conv layer forward
% input: struct with input data
% layer: convolution layer struct
% param: weights for the convolution layer

% output: 

h_in = input.height;
w_in = input.width;
c = input.channel;
batch_size = input.batch_size;
k = layer.k;
pad = layer.pad;
stride = layer.stride;
num = layer.num;
% resolve output shape
h_out = (h_in + 2*pad - k) / stride + 1;
w_out = (w_in + 2*pad - k) / stride + 1;

assert(h_out == floor(h_out), 'h_out is not integer')
assert(w_out == floor(w_out), 'w_out is not integer')
input_n.height = h_in;
input_n.width = w_in;
input_n.channel = c;

%% Fill in the code
% Iterate over the each image in the batch, compute response,
% Fill in the output datastructure with data, and the shape.  
input_n.batch_size = batch_size;
input_n.data = input.data;
%disp(size(input.data)); % 784, 100 (h_in*w_in*c, batch_size) 
% -> output.data: (h_out*w_out*num, batch_size)
%disp(h_in); % 28
%disp(w_in); % 28
%disp(size(col_m))  % 25, 576, 100
%param.w  % 25, 20 (k*k*c, filter)
output.data = zeros(h_out*w_out*num, input_n.batch_size);  % 11520, 100
input_trans = im2col_conv_batch(input_n, layer, h_out, w_out);  % (k*k*c, h_out*w_out, batch_size) matrix

for i = 1: input_n.batch_size
    input_per_batch = input_trans(:, :, i);
    %disp(size(input_per_batch)); % 25, 276
    input_per_batch_t = input_per_batch'; % 576,25
    p = input_per_batch_t * param.w;  % 576,20 (h_out*w_out, filter)
    % param.b: (1, num)
    for j = 1: num
        p(:, j) = p(:, j) + param.b(:, j);
    end
    p_batch = reshape(p, [h_out*w_out*num, 1]);  % 11520,1
    output.data(:, i) = p_batch;
end

%disp(size(output.data));  % 11520, 100 (2D)
output.height = h_out;
output.width = w_out;
output.channel = num;
output.batch_size = batch_size;

end

