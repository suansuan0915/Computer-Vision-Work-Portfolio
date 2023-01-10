function depthM = get_depth(dispM, K1, K2, R1, R2, t1, t2)
% GET_DEPTH creates a depth map from a disparity map (DISPM).
% FORMULA:  depthM(y, x) = b × f /dispM(y, x)

%% Camera center c1, c2
KR1 = K1 * R1; %(3,3)
Kt1 = K1 * t1;
c1 = -inv(KR1) * Kt1;  %(3,1)
KR2 = K2 * R2; %(3,3)
Kt2 = K2 * t2;
c2 = -inv(KR2) * Kt2;

b = sqrt(sum((c2 - c1).^2, 'all'));
f = K1(1,1);
depthM = zeros(size(dispM));

for y = 1: size(dispM, 1)
    for x = 1: size(dispM, 2)
        d = dispM(y,x);
        if d == 0
            depthM(y, x) = 0;
        else
        depthM(y, x) = b * f / d; 
        end
    end
end

end