function p_hat = price_hat(S_0,w_o_hat,r_u_hat,pa,N,J,tt)
        
    w_hat = [w_o_hat(:,1), repmat(w_o_hat(:,2),1,J-1)];
    r_hat = repmat(r_u_hat,1,J-1);
    z_hat = pa.z_hat(:,:,tt);
    tau_hat = pa.tau_hat(:,:,tt);

    % initial guess
    p_hat = ones(N,J);
    p_hat_new = NaN(N,J);
    c_hat = NaN(N,J);

    dif = 10;
    iter = 0;
    
    while dif > 1e-3

        iter = iter + 1;

        % cost_hat bundle
        for j = 1:J
            if j == 1
                c_hat(:,j) = w_hat(:,j).^pa.alpha_l(j) .* prod(p_hat.^pa.alpha_m,2) ./ z_hat(:,j);
            else
                c_hat(:,j) = w_hat(:,j).^pa.alpha_l(j) .* r_hat(:,j-1).^pa.alpha_k(j) .* prod(p_hat.^pa.alpha_m,2) ./ z_hat(:,j);
            end
        end

        % new price_hat
        for j = 1:J
            c_hat_j = c_hat(:,j);
            a_j = (repmat(c_hat_j',N,1).*tau_hat).^(-pa.theta);
            s_j0 = S_0(:,1+(j-1)*J:J+(j-1)*J);
            p_j = sum(s_j0.*a_j,2).^(-1./pa.theta);
            p_hat_new(:,j) = p_j;
        end

        difference = p_hat_new - p_hat;
        dif = max(abs(difference));

        smooth = .9 * rand + .1;        
        p_hat = smooth .* p_hat_new + (1 - smooth) .* p_hat;

    end







end