function x = expenditure(l,S,w,r,k,p,zeta,pa,N,J)

    % initial guess
    x = ones(N,J);
    
    dif = 10;
    iter = 0;

    pc_w = ones(N,J);
    pc_k = ones(N,J);
    pi_k = ones(N,J);
    
    p_a = p(:,1);
    p_na = prod((p(:,2:J)./pa.gamma).^pa.gamma, 2);

    for j = 1:J
        if j == 1
            pc_w(:,j) = (pa.xi.*w(:,1) + (1-pa.xi).*pa.Lambda_a.*p_a + pa.xi.*pa.Lambda_na.*p_na).*l(:,1) + (pa.xi .* w(:,2) + (1-pa.xi).*pa.Lambda_a.*p_a + pa.xi.*pa.Lambda_na.*p_na).*l(:,2);
            for n = 1:N
                if pc_w(n,j) < 0
                    pc_w(n,j) = 0.0001;
                end
            end
            pc_k(:,j) = (pa.xi.*(1-zeta).*r(:,1).*k + (1-pa.xi).*pa.Lambda_a.*p_a + pa.xi.*pa.Lambda_na.*p_na);
            for n = 1:N
                if pc_k(n,j) < 0
                    pc_k(n,j) = 0.0001;
                end
            end
            pi_k(:,j) = (pa.nu(1).*pa.eta_s(j) + pa.nu(2).*pa.eta_e(j)).*zeta.*r(:,1).*k;
            for n = 1:N
                if pi_k(n,j) < 0
                    pi_k(n,j) = 0.0001;
                end
            end        
        else
            pc_w(:,j) = pa.gamma(j-1).*((1-pa.xi).*w(:,1) - (1-pa.xi).*pa.Lambda_a.*p_a - pa.xi.*pa.Lambda_na.*p_na).*l(:,1) + pa.gamma(j-1).*((1-pa.xi).* w(:,2) - (1-pa.xi).*pa.Lambda_a.*p_a - pa.xi.*pa.Lambda_na.*p_na).*l(:,2);
            for n = 1:N
                if pc_w(n,j) < 0
                    pc_w(n,j) = 0.0001;
                end
            end
            pc_k(:,j) = pa.gamma(j-1).*((1-pa.xi).*(1-zeta).*r(:,1).*k - (1-pa.xi).*pa.Lambda_a.*p_a - pa.xi.*pa.Lambda_na.*p_na);
            for n = 1:N
                if pc_k(n,j) < 0
                    pc_k(n,j) = 0.0001;
                end
            end
            pi_k(:,j) = (pa.nu(1).*pa.eta_s(j) + pa.nu(2).*pa.eta_e(j)).*zeta.*r(:,1).*k; 
            for n = 1:N
                if pi_k(n,j) < 0
                    pi_k(n,j) = 0.0001;
                end
            end   
        end
    end

    while dif > 1e-3

        iter = iter + 1;

        a = NaN(N,J);
        b = NaN(N,J);

        for j = 1:J
            a(:,j) = sum(repmat(x(:,j),1,3).*S(:,1+(j-1)*J:J+(j-1)*J),1)';
        end

        for j = 1:J
            b(:,j) = sum(pa.alpha_m(:,j)' .* a,2);
        end

        x_new = pc_w + pc_k + pi_k + b;
% 
%         a1 = sum(repmat(X1,1,3).*S1_1,1)';
%         a2 = sum(repmat(X2,1,3).*S2_1,1)';
% 
%         b1 = pa.alpha_m1(1) .* a1 + pa.alpha_m1(2) .* a2;
%         b2 = pa.alpha_m2(1) .* a1 + pa.alpha_m2(2) .* a2;
% 
%         X1_new = pa.gamma1 .* (W_1.*L_1+R_1.*K_1) + b1;
%         X2_new = pa.gamma2 .* (W_1.*L_1+R_1.*K_1) + b2;

        difference = x_new - x;
        dif = max(max(abs(difference)));
        
        smooth = .9 * rand + .1;
        x = smooth .* x_new + (1 - smooth) .* x;
        
    end    

end