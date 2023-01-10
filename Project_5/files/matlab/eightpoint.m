function F = eightpoint(pts1, pts2, M)
% eightpoint:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.1 - Todo:
%     Implement the eightpoint algorithm
%     Generate a matrix F from correspondence '../data/some_corresp.mat'
% k = randperm(size(pts1, 1), 100);  % k>8, select 100 points
% pts1 = pts1(k, :);
% pts2 = pts2(k, :);
%% normalize points
m1 = mean(pts1);
m2 = mean(pts2);
std1 = std(pts1);
std2 = std(pts2);
T1 = [1/std1(1), 0, -m1(1)/std1(1); 0, 1/std1(2), -m1(2)/std1(2); 0,0,1];
T2 = [1/std2(1), 0, -m2(1)/std2(1); 0, 1/std2(2), -m2(2)/std2(2); 0,0,1];
% if using mean normalization
% T1 = [1/m1(1), 0, 0; 0, 1/m1(2), 0; 0,0,1];
% T2 = [1/m2(1), 0, 0; 0, 1/m2(2), 0; 0,0,1];
pts1_norm = T1 * [pts1.'; ones(1, size(pts1, 1))];  % (3,11) - [x;y;1]
pts2_norm = T2 * [pts2.'; ones(1, size(pts1, 1))];
x = pts1_norm(1, :)';  % (11,1)
y = pts1_norm(2, :)';
x_ = pts2_norm(1, :)';
y_ = pts2_norm(2, :)';
A = [x_.*x, x_.*y, x_, y_.*x, y_.*y, y_, x, y, ones(size(pts1, 1), 1)];
[U, S, V] = svd(A);
entries = V(:, end);
F_pre = reshape(entries, 3,3).';  % reshape array into matrix by column axis

%% Impose 2 constraints on F_pre
[U_, S_, V_] = svd(F_pre);
S_(3, 3) = 0;
F = U_ * S_ * (V_.'); 

%% Un-normalize F
F = T2.' * F * T1;
F = refineF(F,pts1,pts2);
disp('F = ');
disp(F);

end