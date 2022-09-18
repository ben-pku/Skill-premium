function [p,Q] = ss_C(p, para)
%   SS_C calculate the corresponding C, consumption
%   calculate by budget constraint

     Q.D = para.H+para.L;
     p.p_c = ones(para.num, 1);
     iter = 0;
     dif = 10;
     while dif>1e-6 && iter< 1e4
         iter = iter + 1;
         Q.C = Q.E ./ p.p_c;
         newp_c = para.Omega_a * p.p_a.^(1-para.sigma) .* ( Q.C./Q.D ).^((1-para.sigma)*(para.eps_a - 1) ) ...
             + para.Omega_m * p.p_m.^(1-para.sigma) .* ( Q.C./Q.D ).^((1-para.sigma)*(para.eps_m - 1) ) ...
             + para.Omega_sl * p.p_a.^(1-para.sigma) .* ( Q.C./Q.D ).^((1-para.sigma)*(para.eps_sl - 1) ) ...
             + para.Omega_sh * p.p_a.^(1-para.sigma) .* ( Q.C./Q.D ).^((1-para.sigma)*(para.eps_sh - 1) );
        newC = Q.E./newp_c;
         dif = max(max( abs(  [newp_c newC]./[p.p_c Q.C] -1 ) ));
         smooth=.1*rand+.9;
         Q.C = (1-smooth) * Q.C + smooth * newC;
         p.p_c = (1-smooth) * p.p_c + smooth * newp_c;
         
     end
     
     if iter >=10000
        display("ss_C falied. \n");
        return
    end
     
end