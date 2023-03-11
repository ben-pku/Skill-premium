function de = d_sumo(p1, p2, p3, p4, exp, pa, x)
%D_SUMO derivative of the sum omega
% to solve the solution by Newton's method
% input
% x : omega_b expenditure share of the base good, country* 1
% output
% de: the 1st derivative of the sum of expenditure shares, country * 1

omega1 = pa.epsilon(1) * pa.Omega(1) * ( p1 ./ p2  ).^(1-pa.sigma) .* ...
    ( exp ./ p2 ).^((1-pa.sigma)*(pa.epsilon(1)-1)) .* x.^(pa.epsilon(1)-1);
omega3 = pa.epsilon(3) * pa.Omega(3) * ( p3 ./ p2  ).^(1-pa.sigma) .* ...
    ( exp ./ p2 ).^((1-pa.sigma)*(pa.epsilon(3)-1)) .* x.^(pa.epsilon(3)-1);
omega4 = pa.epsilon(4) * pa.Omega(4) *( p4 ./ p2  ).^(1-pa.sigma) .* ...
    ( exp ./ p2 ).^((1-pa.sigma)*(pa.epsilon(4)-1)) .* x.^(pa.epsilon(4)-1);
de = omega1 + 1 + omega3 + omega4;

end