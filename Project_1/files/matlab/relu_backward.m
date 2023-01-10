function [input_od] = relu_backward(output, input, layer)

% Replace the following line with your implementation.
%input_od = zeros(size(input.data));  % 3200, 100 (h_out*w_out*c, batch_size)
%batch_size = input.batch_size;
%disp(output.diff);

% for n = 1: batch_size
%     input_od(:, n) = input.data(:, n) > 0 ;
% end 

input_od = input.data;
input_od(input_od > 0) = 1;
input_od(input_od <= 0) = 0;
input_od = input_od .* output.diff;

end
