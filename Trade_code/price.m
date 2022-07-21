function [m, n] = price(r_p_m, w_l, w_h, para)
%% fsolve function
        r = r_p_m(: , 1);
        p_m = r_p_m( : , 2);
        u = (r ./ ((1-para.alpha2-para.beta2)*para.v_m)  ).^((1-para.alpha2-para.beta2)*para.v_m) .*...
            (w_l ./ (para.alpha2*para.v_m) ).^(para.alpha2*para.v_m ) .*...
            (w_h ./(para.beta2*para.v_m ) ).^(para.beta2*para.v_m ) .*...
            (p_m ./(1-para.v_m) ).^(1-para.v_m) ;
        [element, phi_s] = phi(u, para);
    m = p_m - para.xi .* phi_s.^(-1./para.theta) ;
    n = p_m * ( 1/para.beta+ para.delta -1) -r ;
end

