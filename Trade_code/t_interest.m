function [p, Q] = t_interest(p, Q, para, ssp, ssQ)
%T_INTEREST Calculate right interest rate for each country
%   Guess and update interest rate for each country by capital mkt clearing
%   condition
    
    %% guess interest rate r
    p.r = repmat(ssp.r, 1, para.TT);

    iter  = 0;
    dif = 10;
    while max(dif)> 1e-3 && iter <10000
        iter = iter + 1;
        
        % calculate all price indexes
        p = t_price(p, para, ssp);
        
        % locus of capital
        Q.K = repmat(para.K1, 1, para.TT);
        for t = 1: (para.TT-1)
            Q.K(:, t+1)  =  (1- para.delta) * Q.K(:, t) + Q.rho(:, t) .* ( p.r(:, t) .* Q.K(:, t) + p.w_l(:, t) .* para.Lt(:, t) + p.w_h(:, t) .* para.Ht(:, t) );
            
        end
        
     
        % quantity
        % calculate YS_l   A * YS_l = B
        A = p.p_l / para.gamma2;
        B = (1 - Q.rho) .* ( p.w_l .* para.Lt + p.w_h .* para.Ht + p.r .* Q.K) - p.p_a * para.theta_a - 1/para.gamma2 * para.theta_l * p.p_l + para.theta_h * p.p_h;
        Q.YS_l = B./A;
        
        % other quantity
        % low skill service
        % 22
        Q.CS_l = Q.YS_l;
        % 15
        Q.H_l = para.beta3* p.p_l .* Q.YS_l ./p.w_h;
        % 14
        Q.L_l = para.alpha3* p.p_l .* Q.YS_l ./p.w_l;
        % 13
        Q.K_l = (1-para.alpha3 - para.beta3)* p.p_l .* Q.YS_l ./ p.r;
        
        % agriculture
        % 4 5
        Q.YA = para.theta_a + (1-para.gamma1-para.gamma2-para.gamma3)/para.gamma1 * p.p_l ./ p.p_a.*(Q.YS_l + para.theta_l);
        % 8
        Q.L_a = para.alpha1 * Q.YA .* p.p_a ./p.w_l;
        % 19
        Q.CA = Q.YA;
        % 7
        Q.K_a = (1-para.alpha1) * Q.YA .* p.p_a ./ p.r;
        
        % high skill service 
        % 5 6
        Q.YS_h = para.gamma3/para.gamma2 * p.p_l./p.p_h .* (Q.YS_l + para.theta_l) - para.theta_h;
        % 17
        Q.L_h = para.alpha4* p.p_h .* Q.YS_h ./p.w_l;
        % 18
        Q.H_h = para.beta4* p.p_h .* Q.YS_h ./p.w_h;
        Q.CS_h = Q.YS_h;
        % 16
        Q.K_h = (1 - para.alpha4 - para.beta4) * p.p_h .* Q.YS_h ./p.r;

        % manufacturing 
        % unskilled labor mkt clearing 25
        Q.L_m = para.Lt - Q.L_h - Q.L_l - Q.L_a;
        % 10  11
        Q.H_m = para.beta2/para.alpha2 * p.w_l./p.w_h .* Q.L_m;
        % 10 9
        Q.K_m = (1-para.alpha2-para.beta2) / para.alpha2 * p.w_l .* Q.L_m ./ p.r;
        
        % excess demand for capital
        ZK =  Q.K_m + Q.K_l + Q.K_h + Q.K_l - Q.K;
        % update interest rate
        phi = 1e-1; % Scale factor
        newr= p.r .* (1+ phi * ZK ./ Q.K );
        dif = 1/phi * max( abs(  (newr - p.r)./ p.r)  ); 
        smooth = .2*rand + .8;
        p.r = smooth*newr + (1-smooth)*p.r;

        
    end
    
    if iter >= 10000
        display("t_interest fails. \n");
        return
    end
    
end

