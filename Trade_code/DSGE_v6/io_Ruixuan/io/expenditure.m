function [X1, X2] = expenditure(L_1, K_1, W_1, R_1, S1_1, S2_1, pa)

    % initial guess
    X1 = ones(3,1);
    X2 = ones(3,1);

    dif = 10;
    iter_x = 0;

    while dif > 1e-3

        iter_x = iter_x + 1;
        
        a1 = sum(repmat(X1,1,3).*S1_1,1)';
        a2 = sum(repmat(X2,1,3).*S2_1,1)';

        b1 = pa.mu_m1(1) .* a1 + pa.mu_m1(2) .* a2;
        b2 = pa.mu_m2(1) .* a1 + pa.mu_m2(2) .* a2;

        c1 = pa.mu_m1(1) .* b1 + pa.mu_m2(1) .* b2;
        c2 = pa.mu_m1(2) .* b1 + pa.mu_m2(2) .* b2;

        X1_new = pa.gamma(1) .* (W_1.*L_1+R_1.*K_1) + c1;
        X2_new = pa.gamma(2) .* (W_1.*L_1+R_1.*K_1) + c2;

        difference = ([X1_new;X2_new] - [X1;X2])./[X1;X2];
        dif = max(abs(difference));
        
        smooth = .9 * rand + .1;
        X1 = smooth .* X1_new + (1 - smooth) .* X1;
        X2 = smooth .* X2_new + (1 - smooth) .* X2;
        
    end    

end