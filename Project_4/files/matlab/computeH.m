function [ H2to1 ] = computeH( x1, x2 )
%COMPUTEH Computes the homography between two sets of points
% (M*1)
x = x1(:, 1);
y = x1(:, 2);
x_ = x2(:, 1);
y_ = x2(:, 2);

A = [];
for i = 1:size(x, 1)
top_row = [-x(i) -y(i) -1 0 0 0 x(i)*x_(i) y(i)*x_(i) x_(i)];
bottom_row = [0 0 0 -x(i) -y(i) -1 x(i)*y_(i) y(i)*y_(i) y_(i)];
m_i = [top_row; bottom_row];
A = vertcat(A, m_i);
end

% disp(size(A));  %(2*#points, 9)

ATA = transpose(A) * A;
[V,D] = eig(ATA);
[e, idx] = sort(diag(D));
min_idx = idx(1);
% disp(e(1));  % min eigenvalue
% disp(idx(1));
v_min = V(:, min_idx);
% disp(size(v_min)); %(9,1)

%% transform (9,1) into (3,3) matrix
H2to1 = vertcat(transpose(v_min(1:3,:)), transpose(v_min(4:6,:)), transpose(v_min(7:9,:)));
% disp(size(H2to1));  %(3,3)
% disp(v_min);
% disp(H2to1);
end
