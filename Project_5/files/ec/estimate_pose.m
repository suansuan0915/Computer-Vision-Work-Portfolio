function P = estimate_pose(x, X)
% ESTIMATE_POSE computes the pose matrix (camera matrix) P given 2D and 3D
% points.
%   Args:
%       x: 2D points with shape [2, N]
%       X: 3D points with shape [3, N]
% p: (3,4)

X(4,:) = ones(1,size(X, 2));
A = [];

for i = 1:size(X, 2)
    x_i = x(1,i);
    y_i = x(2,i);
    X_Y_i = X(:,i);
    A = [A; X_Y_i' 0 0 0 0 (-x_i*X_Y_i)'; 0 0 0 0 X_Y_i' (-y_i*X_Y_i)'];
end

[U, S, V] = svd(A);
P = V(:,end);
P = reshape(P, [4,3])';

end