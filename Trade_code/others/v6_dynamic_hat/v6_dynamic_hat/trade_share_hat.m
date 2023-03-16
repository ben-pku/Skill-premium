function s_hat = trade_share_hat(S_0,w_o_hat,r_u_hat,p_hat,pa,N,J,tt)

    w_hat = [w_o_hat(:,1), repmat(w_o_hat(:,2),1,J-1)];
    r_hat = repmat(r_u_hat,1,J-1);
    z_hat = pa.z_hat(:,:,tt);
    tau_hat = pa.tau_hat(:,:,tt);
    s_hat = NaN(N,N.*J);

        % cost_hat bundle (有问题)
        for j = 1:J
            if j == 1
                c_hat(:,j) = w_hat(:,j).^pa.alpha_l(j) .* prod(p_hat.^pa.alpha_m(j,:),2) ./ z_hat(:,j);
            else
                c_hat(:,j) = w_hat(:,j).^pa.alpha_l(j) .* r_hat(:,j-1).^pa.alpha_k(j) .* prod(p_hat.^pa.alpha_m(j,:),2) ./ z_hat(:,j);
            end
        end

    % new price_hat
    for j = 1:J
        c_hat_j = c_hat(:,j);
        a_j = (repmat(c_hat_j',N,1).*tau_hat).^(-pa.theta);
        s_j0 = S_0(:,1+(j-1)*N:N+(j-1)*N);
        s_hat_j = a_j./sum(s_j0.*a_j,2);
        s_hat(:,1+(j-1)*N:N+(j-1)*N) = s_hat_j;
    end

end