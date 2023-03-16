function y = sum_omega(p1, p2, p3, p4, exp, pa, x)
%SUM_OMEGA 
% given the share of base good,x, solve the sum of the expenditure share
% input
% x : omega_b expenditure share of the base good, country* 1
% output
% all: the sum of expenditure shares, country * 1
omega1 = pa.Omega(1) * ( p1 ./ p2  ).^(1-pa.sigma) .* ...
    ( exp ./ p2 ).^((1-pa.sigma)*(pa.epsilon(1)-1)) .* x.^(pa.epsilon(1));
omega3 = pa.Omega(3) * ( p3 ./ p2  ).^(1-pa.sigma) .* ...
    ( exp ./ p2 ).^((1-pa.sigma)*(pa.epsilon(3)-1)) .* x.^(pa.epsilon(3));
omega4 = pa.Omega(4) *( p4 ./ p2  ).^(1-pa.sigma) .* ...
    ( exp ./ p2 ).^((1-pa.sigma)*(pa.epsilon(4)-1)) .* x.^(pa.epsilon(4));
y = omega1 + x  + omega3 + omega4 - 1;


end

