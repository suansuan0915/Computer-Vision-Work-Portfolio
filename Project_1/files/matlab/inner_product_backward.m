function [param_grad, input_od] = inner_product_backward(output, input, layer, param)

% Replace the following lines with your implementation.
param_grad.b = zeros(size(param.b));  % param.b: 1, neurons (1,500)
param_grad.w = zeros(size(param.w));  % param.w: h*w*c, neuron (800, 500)

% input.data size: (800, 100) 4*4*50
batch_size = input.batch_size;
input_od = zeros(size(input.data));

for n = 1: batch_size
    %temp_data_diff = reshape(output.diff(:, n), [h_out*w_out, num]); 
    temp_data_diff = output.diff(:, n);  % output.diff: 500,100 (neurons, batch) - derivative of loss to hi
    temp_data_diff_t = temp_data_diff';  % 1, 500
    weight = param.w;  % 800, 500
    param_grad.b = param_grad.b + temp_data_diff_t * 1;
    param_grad.w = param_grad.w + input.data(:, n) * temp_data_diff_t;
    input_od(:, n) = weight*temp_data_diff;
end

end
