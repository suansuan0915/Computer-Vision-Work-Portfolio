function [M1, M2, K1n, K2n, R1n, R2n, t1n, t2n] = ...
                        rectify_pair(K1, K2, R1, R2, t1, t2)
% RECTIFY_PAIR takes left and right camera paramters (K, R, T) and returns left
%   and right rectification matrices (M1, M2) and updated camera parameters. You
%   can test your function using the provided script q4rectify.m

%% Camera center c1, c2
KR1 = K1 * R1; %(3,3)
Kt1 = K1 * t1;
c1 = -inv(KR1) * Kt1;  %(3,1)
KR2 = K2 * R2; %(3,3)
Kt2 = K2 * t2;
c2 = -inv(KR2) * Kt2;

%% New Rotation matrix (r1;r2;r3)
% for both images
r1 = (c2 - c1) / sqrt(sum((c2 - c1).^2, 'all')); %(3,1)
r2 = cross(R1(3,:), r1); %(1,3)
r3 = cross(r2, r1); %(1,3)
R = [r1'; r2; r3]; %(3,3)
R1n = R;
R2n = R; 

%% New Intrinsic matrix K
K = K2; %(3,3)
K1n = K;
K2n = K;

%% New Translation matrix t
t1n = -R * c1; %(3,1)
t2n = -R * c2; %(3,1)

%% Rectification matrix M
M1 = (K * R) * inv(K1 * R1); %(3,3)
M2 = (K * R) * inv(K2 * R2);



