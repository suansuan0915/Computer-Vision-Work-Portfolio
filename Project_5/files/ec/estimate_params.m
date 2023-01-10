function [K, R, t] = estimate_params(P)
% ESTIMATE_PARAMS computes the intrinsic K, rotation R and translation t from
% given camera matrix P.
% P: (3,4)

%% Get camera centor c
[U,S,V] = svd(P);
% disp(size(V)); % (4,4)
c_vector = V(:,end);
c_vector = c_vector / c_vector(end);
c = c_vector(1:3); %(3,1)

%% QR decomposition
% According to stackexchange reference link
A = P(:, 1:3);
T = [0 0 1;0 1 0; 1 0 0];
M = T * A;
[Q, R] = qr(M');  % note Q,R meanings

Q = A * Q';
R = T * R' * T;
K = R;
R = Q;

t = -R * c;

end