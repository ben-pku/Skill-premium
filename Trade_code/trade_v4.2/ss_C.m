function [p,Q] = ss_C(p, para)
%   SS_C calculate the corresponding C, consumption
%   solve by iterating budget constraint

     Q.D = para.H+para.L;
     Q.H = para.H;
     Q.L = para.L;
     
     %guess aggregate consumption
     Q.C = 1e-2 * Q.D;
     iter = 0;
     dif = 10;
     
     while dif>1e-6 && iter< 1e4
         iter = iter + 1;
         Q.E = ( para.Omega_a * (p.p_a).^(1-para.sigma) .* (  ( Q.C./Q.D ).^para.eps_a .* Q.D  ).^(1-para.sigma) +...
             para.Omega_m * (p.p_m).^(1-para.sigma) .* (  ( Q.C./Q.D ).^para.eps_m .* Q.D  ).^(1-para.sigma) +...
             para.Omega_sl * (p.p_l).^(1-para.sigma) .* (  ( Q.C./Q.D ).^para.eps_sl .* Q.D  ).^(1-para.sigma) +...
             para.Omega_sh * (p.p_h).^(1-para.sigma) .* (  ( Q.C./Q.D ).^para.eps_sh .* Q.D  ).^(1-para.sigma)...
             ).^(1/(1-para.sigma)); 
         Q.Ca = para.Omega_a * ( p.p_a./Q.E ).^(-para.sigma) .* (  ( Q.C./Q.D ).^para.eps_a .* Q.D  ).^(1-para.sigma) ;
         Q.Cm = para.Omega_m * ( p.p_m./Q.E ).^(-para.sigma) .* (  ( Q.C./Q.D ).^para.eps_m .* Q.D  ).^(1-para.sigma) ;
         Q.Csl = para.Omega_sl * ( p.p_l./Q.E ).^(-para.sigma) .* (  ( Q.C./Q.D ).^para.eps_sl .* Q.D  ).^(1-para.sigma) ;
         Q.Csh = para.Omega_sh * ( p.p_h./Q.E ).^(-para.sigma) .* (  ( Q.C./Q.D ).^para.eps_sh .* Q.D  ).^(1-para.sigma) ;
         
         % allocation problem
         Q.Ya = Q.Ca;
         Q.Ka = para.alpha1 * ( para.A_a .* p.p_a ./p.r ).^para.phi .* Q.Ya;
         Q.La = (1- para.alpha1) * ( para.A_a .* p.p_a ./p.r ).^para.phi .* Q.Ya;
         
         Q.Ysl = Q.Csl ;
         Q.Lsl = (1-para.beta3) * ( p.p_l .* para.A_l ./p.w_l ).^para.phi .* Q.Ysl;
         Q.hsl = para.beta3 * ( p.p_l .* para.A_l ./p.p_lh ).^para.phi .* Q.Ysl;
         Q.Hsl = (1-para.alpha3) * ( p.p_lh  ./p.w_h ).^para.rho .* Q.hsl;
         Q.Ksl = para.alpha3 * ( p.p_lh  ./p.r ).^para.rho .* Q.hsl;
         
         Q.Ysh = Q.Csh ;
         Q.Lsh = (1-para.beta4) * ( p.p_h .* para.A_h ./p.w_l ).^para.phi .* Q.Ysh;
         Q.hsh = para.beta4 * ( p.p_h .* para.A_h ./p.p_hh ).^para.phi .* Q.Ysh;
         Q.Hsh = (1-para.alpha4) * ( p.p_hh  ./p.w_h ).^para.rho .* Q.hsh;
         Q.Ksh = para.alpha4 * ( p.p_hh  ./p.r ).^para.rho .* Q.hsh;
         
         Q.Lm = Q.L - (Q.La + Q.Lsh + Q.Lsl);
         Q.sm = (p.w_l ./ p.p_ms) .^para.phi .* Q.Lm /(1-para.beta2);
         Q.hm = para.beta2 * ( p.p_ms./ p.p_mh ) .^para.phi .* Q.sm;
         Q.Hm = (1-para.alpha2) * ( p.p_mh./p.w_h ).^ para.rho .* Q.hm;
         Q.Km = para.alpha2 * ( p.p_mh./p.r ).^ para.rho .* Q.hm;
         
         Q.K = Q.Km+ Q.Ka + Q.Ksh + Q.Ksl;
         
         % excessive demand revealed by budget constraint
         ed = Q.E - ( p.w_l .* Q.L + p.w_h .* Q.H + (p.r- para.delta * p.p_m).* Q.K  );
         p.pc = (  para.Omega_a * (p.p_a).^(1-para.sigma) .*   ( Q.C./Q.D ) .^((1-para.sigma)*(para.eps_a-1)) +...
             para.Omega_m * (p.p_m).^(1-para.sigma) .*   ( Q.C./Q.D ).^((1-para.sigma)*(para.eps_m-1)) +...
             para.Omega_sl * (p.p_l).^(1-para.sigma) .*   ( Q.C./Q.D  ).^((1-para.sigma)*(para.eps_sl-1)) +...
             para.Omega_sh * (p.p_h).^(1-para.sigma) .* ( Q.C./Q.D  ).^((1-para.sigma)*(para.eps_sh-1)) ...
             ) .^(1/(1-para.sigma));
         ph = 9e-1;
         newC = Q.C .*( 1 - ph * ed./p.pc  );
         
         dif = max( abs( (newC - Q.C)./Q.C ));
         smooth=.1*rand+.9;
         Q.C = (1-smooth) * Q.C + smooth * newC;
         
         
     end
     
     if iter >=10000
        display("ss_C falied. \n");
        return
    end
     
end