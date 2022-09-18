function [p] = t_price(p, para, ssp)
%T_PRICE Calculate price indexes given w_l, w_h, r
%   calculate price indexes, p_m, p_a, p_l, and p_h, given w_l, w_h, r.


    %% guess initial price indexes
    p.p_m = repmat(ssp.p_m, 1, para.TT); % for each t
    
    iter = 0;
    dif = 1000;
    xi=gamma(1+(1-para.eta)./para.theta).^(1./(1-para.eta));
    xi = repmat(xi, 1, para.TT); % for each t
    v_m = repmat(para.v_m, 1, para.TT); % for each t
    
    
%     phi_s = zeros(para.num, para.TT);
    %% iterate to solve the solution
    while max(dif) >= 1e-6 && iter< 10000
        iter = iter+1;
        
        p.u = (p.r ./ ((1-para.alpha2)*v_m)  ).^((1-para.alpha2)*v_m) .*...
            (p.w_l ./ (para.alpha2*v_m) ).^(para.alpha2*v_m ) .*...
            (p.w_h ./((1-para.beta2)*(1-v_m) ) ).^(  (1-para.beta2)*(1-v_m) ) .*...
            (p.p_m ./(para.beta2 * (1-v_m)) ).^(para.beta2 * (1-v_m)) ;

        [~, phi_s] = dy_phi(p.u, para);
        
        p_mnew = xi .* phi_s.^(-1./repmat(para.theta,1,para.TT)) ;

        dif = max( abs( p_mnew-p.p_m ) ./p.p_m  );
        smooth=.1*rand+.9;
        p.p_m = smooth * p_mnew + (1-smooth)*p.p_m;
 
    end
        
    if iter >=10000
        disp("t_price falied. \n");
        return
    end

    p.p_a = (p.r/(1-para.alpha1)) .^ (1-para.alpha1) .* ( p.w_l/para.alpha1) .^ (para.alpha1) ./ repmat(para.A_a, 1 , para.TT);
    p.p_l = (p.r/(1-para.alpha3-para.beta3)) .^(1-para.alpha3-para.beta3) .* ( p.w_l/para.alpha3).^(para.alpha3)...
            .* ( p.w_h/para.beta3).^(para.beta3)  ./ repmat(para.A_l, 1 , para.TT);
    p.p_h = (p.r/(1-para.alpha4-para.beta4)) .^(1-para.alpha4-para.beta4) .* ( p.w_l/para.alpha4).^(para.alpha4)...
            .* ( p.w_h/para.beta4).^(para.beta4)  ./ repmat(para.A_h, 1 , para.TT);
    g0 = 1-para.gamma1-para.gamma2-para.gamma3;
    p.p_c  = (p.p_a / g0).^g0 .* (p.p_m / para.gamma1) .^ para.gamma1 .* (p.p_l / para.gamma2) .^ para.gamma2.* (p.p_h / para.gamma3) .^ para.gamma3 ;
    
end

