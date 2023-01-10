function [output] = relu_forward(input)
output.height = input.height;
%disp(input.height);
output.width = input.width;
output.channel = input.channel;
output.batch_size = input.batch_size;

% Replace the following line with your implementation.
%output.data = zeros(size(input.data));
temp = zeros(size(input.data));
%input.data size: (h_in*w_in*c, batch_size)
for i = 1: input.batch_size
    m = input.data(:, i);  % （h_in*w_in*c, 1）
    for j = 1: size(m, 1)
        m(j, :) = max([0, m(j, :)]);
    temp(:, i) = m;
    end
end

output.data = temp;
%disp(size(output.data));  % 11520, 100; 3200, 100; 500, 100

end
