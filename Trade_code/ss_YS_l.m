function [p,Q] = ss_YS_l(p, para)
%SS_YS_L calculate the corresponding production in low-skill service
%   calculate by combining 12 formulas  
%   F .* Q.YS_l = E

     A = p.p_a .* (1 - (p.r-para.delta*p.p_m) ./ p.r *( 1-para.alpha1 - para.alpha1*(1-para.alpha2-para.beta2)/para.alpha2 ) );
     B = p.p_l .* ( para.gamma1/para.gamma2 + 1 - (p.r-para.delta*p.p_m) ./ p.r *(1-para.alpha3-para.beta3 - para.alpha3/para.alpha2 *(1-para.alpha2-para.beta2) ) );
     C = p.p_h .* (1 - (p.r-para.delta*p.p_m) ./ p.r * (1-para.alpha4-para.beta4- para.alpha4/para.alpha2 *(1-para.alpha2-para.beta2) ));
     D = p.w_l .* para.L  .* ( 1 + (p.r-para.delta*p.p_m) ./ p.r * (1-para.alpha2-para.beta2)/para.alpha2 ) + p.w_h .* para.H - para.theta_l * para.gamma1/para.gamma2 * p.p_l ;

     E = D - C .* ( para.gamma3/para.gamma2 *para.theta_l .* p.p_l ./ p.p_h - para.theta_h) -...
                    A .* (para.theta_a + (1-para.gamma1-para.gamma2-para.gamma3)/para.gamma1 * para.theta_l * p.p_l./p.p_a );
    
     F = A .* (1-para.gamma1-para.gamma2-para.gamma3)/para.gamma1 .* p.p_l./p.p_a + B + para.gamma3/para.gamma2* C .* p.p_l./p.p_h;
     Q.YS_l = E./F;

%     %% guess the capital low-skill service
%     Q.K_l = 1e-5*ones(para.num, 1);
%     iter = 0;
%     dif = 100;
%     
%     while dif > 1e-6 && iter<=10000
%         iter = iter + 1;
%         %% Low skill service
%         % 13
%         Q.YS_l = 1/(1-para.alpha3 - para.beta3) * p.r .* Q.K_l ./p.p_l;
%         % 14
%         Q.L_l = para.alpha3 * Q.YS_l .*p.p_l ./p.w_l;
%         % 15
%         Q.H_l = para.beta3 * Q.YS_l .*p.p_l ./p.w_h;
%         % 22
%         Q.CS_l = Q.YS_l;
% 
%         %% High skill service
%         % 5 6
%         Q.CS_h = para.gamma3/para.gamma2 * p.p_l ./p.p_h .* (Q.CS_l + para.theta_l) - para.theta_h;
%         % 23
%         Q.YS_h = Q.CS_h;
%         % 16
%         Q.K_h = (1-para.alpha4 - para.beta4) * p.p_h .* Q.YS_h ./ p.r;
%         % 18
%         Q.H_h = para.beta4 * p.p_h .* Q.YS_h ./ p.w_h;
%         % 17
%         Q.L_h = para.alpha4 * p.p_h .* Q.YS_h ./ p.w_l;
% 
%         %% agriculture
%         % 4 5
%         Q.CA = para.theta_a + (1-para.gamma1 - para.gamma2 - para.gamma3)/para.gamma2 * p.p_l ./p.p_a .* (Q.CS_l + para.theta_l);
%         % 19
%         Q.YA = Q.CA;
%         % 7
%         Q.K_a = (1-para.alpha1)*p.p_a .*Q.YA ./p.r;
%         % 8
%         Q.L_a = para.alpha1 * p.p_a .* Q.YA ./ p.w_l;
% 
%         %% manufacturing
%         % 5 
%         Q.CM =para.gamma1 / para.gamma2 * p.p_l ./ p.p_m .* (Q.CS_l + para.theta_l)  ;
%         % unskilled labor mkt clearing 25
%         Q.L_m = para.L - (Q.L_l + Q.L_h + Q.L_a);
%         Q.L = para.L;
%         % 9  10
%         Q.K_m = (1-para.alpha2 - para.beta2)/ para.alpha2 *p.w_l .* Q.L_m ./p.r ;
%         
%         % budget constraint 1
%         Q.K = ( p.p_a .* Q.CA + p.p_m .* Q.CM + p.p_l .* Q.CS_l + p.p_h .* Q.CS_h - (p.w_l .* Q.L + p.w_h .* para.H)  ) ./ ( p.r - para.delta* p.p_m ) ;
%         % update the Q.K_l 
%         newK_l = Q.K - (Q.K_a + Q.K_m + Q.K_h);
%         
%         dif = max( abs( (newK_l - Q.K_l ) ./ Q.K_l ) );
%         smooth=.1*rand+.9;
%         Q.K_l = smooth * newK_l + (1-smooth)*Q.K_l;
%         
%     end
    
%     if iter >= 10000
%         display("ss_YS_l fails. \n");
%         return
%     end

    
end

