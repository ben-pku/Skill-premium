function [w_o,r_u] = initial(l,S,stigma,pa,N,O,J)

    % 5.a guess the wage and rental price at t = 0
    w_o = ones(N,O);
    r_u = ones(N,1);

    iter = 0;
    dif = 10;

    while dif > 1e-3

        iter = iter + 1;

        w = [w_o(:,1), repmat(w_o(:,2),1,J-1)];
        r = repmat(r_u,1,J-1);
    
        % 5.b solve the initial price of different sector
        p = ini_price(w, r, pa, N, J) ;
    
        % 5.c solve the investment price
        p_s = prod((p./pa.eta_s').^pa.eta_s',2);
        p_e = prod((p./pa.eta_e').^pa.eta_e',2);
        p_x = (p_s./pa.nu(1)).^pa.nu(1).*(p_e./pa.nu(2)).^pa.nu(2);

%         numer = p_x(2);
%         w = w_o./numer;
%         r = r_u./numer;
%         p = p./numer;
%         p_x = p_x./numer;
    
        % 5.d solve the nominal saving rate zeta
        zeta = 1 - (p_x./r(:,1).*(1-pa.delta)+1).*stigma(:,1);
        for n = 1:N
            if zeta(n,1) < 0
                zeta(n,1) = 0.0001;
            end
        end
    
        % 5.e given S l w r k p, solve the total expenditure pf each industry x
        x = expenditure(l,S,w,r,pa.k_0,p,zeta,pa,N,J);
    
        % 5.f solve the total revenue of each industry py
        py = NaN(N,J);
        for j = 1:J
            py(:,j) = sum(repmat(x(:,j),1,3).*S(:,1+(j-1)*J:J+(j-1)*J),1)';
        end
    
        % 5.g recover the new wage and rental price
        w_new_u = sum(pa.alpha_l(2:J)'.*py(:,2:J),2)./l(:,2);
        w_new_r = pa.alpha_l(1)'.*py(:,1)./l(:,1);
        r_u_new = sum(pa.alpha_k'.*py,2)./pa.k_0;
        w_o_new = [w_new_r,w_new_u];

        numer = w_o_new(1);
        w_o_new = w_o_new /numer;
        r_u_new = r_u_new /numer;
    
        difference = [w_o_new,r_u_new] - [w_o,r_u];
        dif = max(max(abs(difference)));
            
        smooth = .9 * rand + .1;
        w_o = smooth .* w_o_new + (1 - smooth) .* w_o;
        r_u = smooth .* r_u_new + (1 - smooth) .* r_u;
    end

end