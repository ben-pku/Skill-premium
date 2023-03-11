function [Y1, Y2] = production(L, K, W_new, R_new, P1_new, P2_new, S1_new, S2_new, pa)

    % initial guess
    Y1 = ones(3,1);
    Y2 = ones(3,1);

    dif = 10;
    iter = 0;

    while dif > 1e-3

        iter = iter + 1;

        X1 = pa.gamma(1).*(W_new.*L + R_new.*K) + pa.mu_m1(1).*P1_new.*Y1 + pa.mu_m2(1).*P2_new.*Y2;
        X2 = pa.gamma(1).*(W_new.*L + R_new.*K) + pa.mu_m1(2).*P1_new.*Y1 + pa.mu_m2(2).*P2_new.*Y2;

        a1 = sum(repmat(X1,1,3).*S1_new,1)';
        a2 = sum(repmat(X2,1,3).*S2_new,1)';

        Y1_new = (pa.mu_m1(1).*a1 + pa.mu_m1(2).*a2)./P1_new;
        Y2_new = (pa.mu_m2(1).*a1 + pa.mu_m2(2).*a2)./P2_new;

        dif = max(abs(([Y1_new;Y2_new]-[Y1;Y2])./[Y1;Y2]));

        smooth = .9 * rand + .1;
        Y1 = smooth .* Y1_new + (1 - smooth) .* Y1;
        Y2 = smooth .* Y2_new + (1 - smooth) .* Y2;
    end

end