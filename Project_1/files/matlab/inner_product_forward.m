function [output] = inner_product_forward(input, layer, param)

d = size(input.data, 1); % h_in*w_in*c
k = size(input.data, 2); % batch size 100
n = size(param.w, 2);  % neuron 500. % IP layer w: (h*w*c, layers{i}.num)

% Replace the following line with your implementation.
%output.data = zeros([n, k]);
%disp(size(param.w));  % (h*w*c, neuron) (800, 500)
%input.data size: (h_in*w_in*c, batch_size)  (4*4*50, 100)
%output.data size: (neuron, batch_size) (500, 100)
param_w_t = param.w';  % (neuron, h*w*c) (500, 800)
output.data = param_w_t * input.data; % (500, 100)

output.height = input.height;
output.width = input.width;
output.batch_size = input.batch_size;
output.channel = input.channel;

end
