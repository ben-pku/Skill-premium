function [p] = ss_price(p, para)
%% SS_PRICE solve other price indexes
%   given w_l, w_h and solve r, p_a, p_m, p_l, p_h -- five price indexes
        
    %% guess initial price indexes
    p.p_m = 1e-1 * ones(para.num, 1);
    p.r = (1/para.beta+ para.delta -1)* p.p_m;
    
    iter = 0;
    dif = 1000;
    xi=gamma(1+(1-para.e)./para.theta).^(1./(1-para.e));

    %% iterate to solve the solution
    while max(dif) >= 1e-6 && iter< 10000
        iter = iter+1;
        p.p_a = ( para.alpha1* p.r .^(1-para.rho) + (1-para.alpha1)* p.w_l .^(1-para.rho)  ).^(1/(1-para.rho)) ./ para.A_a;
        p.p_h = p.p_a .* para.A_a;
        p.p_s = ( para.beta2* p.p_h.^(1-para.phi) +(1-para.beta2)* p.w_h.^(1-para.phi) ).^( 1/(1-para.phi) )  ; 
        
        p.u = (para.tau* p.p_s.^(1-para.eta) +(1-para.tau)* p.p_m.^(1-para.eta) ) .^(1/(1-para.eta)) ;
       
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
    
    p.p_ol = p.p_h;
    p.p_sl = ( para.alpha_l * p.p_ol.^(1-para.chi_l) + (1-para.alpha_l)* p.w_h.^(1-para.chi_l)  ).^(1./(1-para.chi_l)) ./ para.A_l;
    p.p_oh = p.p_h;
    p.p_sh = ( para.alpha_h * p.p_oh.^(1-para.chi_h) + (1-para.alpha_h)* p.w_h.^(1-para.chi_h)  ).^(1./(1-para.chi_h)) ./ para.A_h;

     
end




