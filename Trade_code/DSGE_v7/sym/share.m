function omega = share(p1, p2, p3, p4, exp, pa)
%SHARE  expenditure share -- bisection
% input
% p1, p2, p3, p4 country * 1
% exp: total expenditure country * 1
% pa parameters

maxit = 1e4;
tol = 1e-5;
dif = 1;
a =  zeros(pa.num, 1);  b = ones(pa.num, 1);
for iter = 1: maxit
    m = (a+b) /2;
    if dif < tol
        break
    end
    fm = sum_omega(p1, p2, p3, p4, exp, pa, m);

    I = fm > 0;
    b(I) = m(I);
    a(~I) = m(~I);
    dif = dif * 1/2;
    
end

omega1 = pa.Omega(1) * ( p1 ./ p2  ).^(1-pa.sigma) .* ...
    ( exp ./ p2 ).^((1-pa.sigma)*(pa.epsilon(1)-1)) .* m.^(pa.epsilon(1));
omega3 = pa.Omega(3) * ( p3 ./ p2  ).^(1-pa.sigma) .* ...
    ( exp ./ p2 ).^((1-pa.sigma)*(pa.epsilon(3)-1)) .* m.^(pa.epsilon(3));
omega4 = pa.Omega(4) *( p4 ./ p2  ).^(1-pa.sigma) .* ...
    ( exp ./ p2 ).^((1-pa.sigma)*(pa.epsilon(4)-1)) .* m.^(pa.epsilon(4));

% omega = [omega1, m, omega3, omega4];
u =   ones(pa.num, 1);
omega = [0.2 * u, 0.55* u, 0.25* u, 0* u ];

end

