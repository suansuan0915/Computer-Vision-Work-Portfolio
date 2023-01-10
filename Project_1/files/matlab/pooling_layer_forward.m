function [output] = pooling_layer_forward(input, layer)

    h_in = input.height;
    w_in = input.width;
    c = input.channel;
    batch_size = input.batch_size;
    k = layer.k;
    pad = layer.pad;
    stride = layer.stride;
    
    h_out = (h_in + 2*pad - k) / stride + 1;
    w_out = (w_in + 2*pad - k) / stride + 1;
    
    
    output.height = h_out;  % 12; 4
    output.width = w_out;  % 12; 4
    output.channel = c;
    output.batch_size = batch_size;

    % Replace the following line with your implementation.
    %output.data = zeros([h_out, w_out, c, batch_size]);
    %input.data size: (h_in*w_in*c, batch) 11520, 100
    %%temp = [];  % store all output from max pooling
    res = zeros([h_out, w_out, c, batch_size]);
    for i = 1: batch_size
        m = input.data(:, i);  % 11520, 1
        m_re = reshape(m, [h_in, w_in, c]);  % 576, 20
        for j = 1: c
            m_j = m_re(:, :, j);  % 24,24
            temp = [];
            for x = 1: stride: size(m_j, 1)
                for y = 1: stride: size(m_j, 2)
                    if x+stride-1 <= size(m_j, 1) && y+stride-1 <= size(m_j, 2)
                        max_val_m = m_j(x:x+stride-1, y:y+stride-1);  % 2,2
                        max_val = max(max_val_m, [], "all");
                        temp = [temp, max_val];     
                    end
                end                
            end
            res0 = reshape(temp, [h_out, w_out]);
            res0_t = res0';
            res(:, :, j, i) = res0_t;
        end
    end

    %disp(h_out* w_out* c* batch_size);  % 288000; 80000
    %disp(size(temp));  % 1, 288000
    % reshape(): along row-axis
    %A = [1,2,3,4,5,6];  %disp(A);
    %A_ = reshape(A, [3,2]);  %disp(A_);
    %disp(size(res));
    output.data = reshape(res, [h_out * w_out * c, batch_size]);
    %disp(size(output.data));
end

