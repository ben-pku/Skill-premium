function omega = share1(p1, p2, p3, p4, exp, pa)
%SHARE  expenditure share


a =zeros(pa.num, 1);
b =ones(pa.num, 1);
maxit = 1e4;
tol = 1e-15;
dif = max(b-a);
for iter = 1: maxit
    x = (a+b)/2;
    if dif < tol
        break
    end
    % other share
    omega1 = pa.Omega(1) * ( p1 ./ p2  ).^(1-pa.sigma) .* ( exp ./ p2 ).^((1-pa.sigma)*(pa.epsilon(1)-1)) .* x.^(pa.epsilon(1));
    omega3 = pa.Omega(3) * ( p3 ./ p2  ).^(1-pa.sigma) .* ( exp ./ p2 ).^((1-pa.sigma)*(pa.epsilon(3)-1)) .* x.^(pa.epsilon(3));
    omega4 = pa.Omega(4) *( p4 ./ p2  ).^(1-pa.sigma) .* ( exp ./ p2 ).^((1-pa.sigma)*(pa.epsilon(4)-1)) .* x.^(pa.epsilon(4));
    all = omega1 + x + omega3 + omega4;
    I = all > 1;
    b(I) = x(I);
    a(~I) = x(~I);

    dif = (1/2)^iter;
    
end
omega.s1 = omega1;
omega.s2 = x;
omega.s3 = omega3;
omega.s4 = omega4;





end

