function [p] = ss_price(w_l, w_h, para)
%% SS_PRICE solve other price indexes
%   given w_l, w_h and solve r, p_a, p_m, p_l, p_h -- five price indexes
        
    %% guess initial price indexes
    p.p_m = 1e-1 * ones(para.num, 1);
    p.r = (1/para.beta+ para.delta -1)* p.p_m;
    p.w_l = w_l;
    p.w_h = w_h;
    iter = 0;
    dif = 1000;
    xi=gamma(1+(1-para.eta)./para.theta).^(1./(1-para.eta));

    %% iterate to solve the solution
    while max(dif) >= 1e-6 && iter< 10000
        iter = iter+1;
       
        p.u = (p.r ./ ((1-para.alpha2-para.beta2)*para.v_m)  ).^((1-para.alpha2-para.beta2)*para.v_m) .*...
            (p.w_l ./ (para.alpha2*para.v_m) ).^(para.alpha2*para.v_m ) .*...
            (p.w_h ./(para.beta2*para.v_m ) ).^(para.beta2*para.v_m ) .*...
            (p.p_m ./(1-para.v_m) ).^(1-para.v_m) ;
        [~, phi_s] = phi(p.u, para);
        
        p_mnew = xi .* (phi_s.^(-1./para.theta) );
        rnew = (1/para.beta+ para.delta -1)* p_mnew;
        
        dif = max( abs( [p_mnew rnew]-[p.p_m p.r] ) ./[p.p_m p.r] );
        smooth=.1*rand+.9;
        p.p_m = smooth * p_mnew + (1-smooth)*p.p_m;
        p.r = smooth * rnew + (1-smooth)*p.r;
        
    end
    
    if iter >=10000
        display("ss_price falied. \n");
        return
    end
    
    
     p.p_a = (p.r/(1-para.alpha1)).^(1-para.alpha1) .* ( w_l/para.alpha1).^(para.alpha1) ./ para.A_a;
     p.p_l = (p.r/(1-para.alpha3-para.beta3)) .^(1-para.alpha3-para.beta3) .* ( w_l/para.alpha3).^(para.alpha3)...
            .* ( w_h/para.beta3).^(para.beta3)  ./ para.A_l;
     p.p_h = (p.r/(1-para.alpha4-para.beta4)) .^(1-para.alpha4-para.beta4) .* ( w_l/para.alpha4).^(para.alpha4)...
            .* ( w_h/para.beta4).^(para.beta4)  ./ para.A_h;

     p.w_l = w_l;
     p.w_h = w_h;
     g0 = 1-para.gamma1-para.gamma2-para.gamma3;
     p.p_c  = (p.p_a / g0).^g0 .* (p.p_m / para.gamma1) .^ para.gamma1 .* (p.p_l / para.gamma2) .^ para.gamma2.* (p.p_h / para.gamma3) .^ para.gamma3 ;
    
     
end




