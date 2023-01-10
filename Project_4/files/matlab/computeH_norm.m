function [H2to1] = computeH_norm(x1, x2)

%% Compute centroids of the points
% (M*1)
x = x1(:, 1);
y = x1(:, 2);
x_ = x2(:, 1);
y_ = x2(:, 2);

% centroid1 = [mean(x), mean(y)];
% centroid2 = [mean(x_), mean(y_)];
centroid1 = [0, 0];
centroid2 = [0, 0];

%% Shift the origin of the points to the centroid
xn = x - centroid1(1);
yn = y - centroid1(2);
xn_ = x_ - centroid2(1);
yn_ = y_ - centroid2(2);

%% Normalize the points so that the average distance from the origin is equal to sqrt(2).
SIGMA = sqrt(2);
xn = xn / SIGMA;
yn = yn / SIGMA;
xn_ = xn_ / SIGMA; 
yn_ = yn_ / SIGMA;
%%% same as:
% xn = normalize(x,'center',centroid1(1),'scale',SIGMA);
% yn = normalize(y,'center',centroid1(2),'scale',SIGMA);
% xn_ = normalize(x_,'center',centroid2(1),'scale',SIGMA);
% yn_ = normalize(y_,'center',centroid2(2),'scale',SIGMA);
% disp([xn_ yn_]);


%% similarity transform 1
% T1 = [];
A = [];
for i = 1:size(x, 1)
top_row = [-x(i) -y(i) -1 0 0 0 x(i)*xn(i) y(i)*xn(i) xn(i)];
bottom_row = [0 0 0 -x(i) -y(i) -1 x(i)*yn(i) y(i)*yn(i) yn(i)];
m_i = [top_row; bottom_row];
A = vertcat(A, m_i);
end
ATA = transpose(A) * A;
[V,D] = eig(ATA);
[e, idx] = sort(diag(D));
% disp('#####');
% disp(ATA);
% disp(size(idx));
min_idx = idx(1);
v_min = V(:, min_idx);
T1 = vertcat(transpose(v_min(1:3,:)), transpose(v_min(4:6,:)), transpose(v_min(7:9,:)));


%% similarity transform 2
% T2 = [];
B = [];
for i = 1:size(x_, 1)
top_row = [-x_(i) -y_(i) -1 0 0 0 x_(i)*xn_(i) y_(i)*xn_(i) xn_(i)];
bottom_row = [0 0 0 -x_(i) -y_(i) -1 x_(i)*yn_(i) y_(i)*yn_(i) yn_(i)];
m_i = [top_row; bottom_row];
B = vertcat(B, m_i);
end
BTB = transpose(B) * B;
[V_B, D_B] = eig(BTB);
[e_B, idx_B] = sort(diag(D_B));
min_idx_B = idx_B(1);
v_min_B = V_B(:, min_idx_B);
T2 = vertcat(transpose(v_min_B(1:3,:)), transpose(v_min_B(4:6,:)), transpose(v_min_B(7:9,:)));

% disp(T1);
% disp(T2);

%% Compute Homography
% x1_ = [xn, yn];
% x2_ = [xn_, yn_];
%%% same result as:
x1_y1_1 = [x1, ones(size(x1,1),1)];  %(11,3)
after = T1 * transpose(x1_y1_1); %(3,11)
x1_res = [];
for i = 1:size(after, 2)
x1_y1_1_n = after(:,i);
x1_y1_1_n = transpose(x1_y1_1_n / x1_y1_1_n(3,:));
x1_res = vertcat(x1_res, x1_y1_1_n(:, 1:2));
end
% disp(x1_res);

x2_y2_1 = [x2, ones(size(x2,1),1)];  %(11,3)
after_ = T2 * transpose(x2_y2_1); %(3,11)
x2_res = [];
for i = 1:size(after_, 2)
x2_y2_1_n = after_(:,i);
x2_y2_1_n = transpose(x2_y2_1_n / x2_y2_1_n(3,:));
x2_res = vertcat(x2_res, x2_y2_1_n(:, 1:2));
end
% disp(x2_res);

x1_res = [xn yn];
x2_res = [xn_ yn_];

H = computeH(x1_res, x2_res);


%% Denormalization
% T1_inv = inv(T1);  % equal to T1\
H2to1 = T1 \ H * T2;

end

