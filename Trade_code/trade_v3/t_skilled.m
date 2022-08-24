function [p, Q] = t_skilled(p, Q, para, ssp, ssQ)
%T_SKILLED Calculate right skilled labor's wage
%  Guess and update skilled labor's wage by skilled labor market clearing
%  condition


    
    iter = 0;
    dif = 10;
    
    while max(dif)>1e-4 && iter<10000
        iter = iter + 1;
        [p] = t_price(p, para, ssp);
        
        Q.C = (p.w_l .* para.Lt + p.w_h .* para.Ht + Q.K .*( p.r - para.delta* p.p_m ) ) ./ p.p_c;
         %% solve quantity
         
        % agriculture
        % 4
        Q.YA =  ((1-para.gamma1-para.gamma2-para.gamma3)* p.p_c .* Q.C+p.p_a .* para.theta_a ) ./p.p_a ;
        % 9
        Q.L_a = para.alpha1 * Q.YA .* p.p_a ./p.w_l;
        % 20
        Q.CA = Q.YA;

        % low skill service
        % 6
        Q.CS_l = ( para.gamma2* p.p_c .* Q.C - p.p_l * para.theta_l ) ./ p.p_l;
        % 23
        Q.YS_l = Q.CS_l;
        % 16
        Q.H_l = para.beta3* p.p_l .* Q.YS_l ./p.w_h;
        % 15
        Q.L_l = para.alpha3* p.p_l .* Q.YS_l ./p.w_l;


        % high skill service 
        % 7
        Q.YS_h = ( para.gamma3 * p.p_c .* Q.C - p.p_h * para.theta_h  ) ./ p.p_h;
        % 18
        Q.L_h = para.alpha4* p.p_h .* Q.YS_h ./p.w_l;
        % 19
        Q.H_h = para.beta4* p.p_h .* Q.YS_h ./p.w_h;
        Q.CS_h = Q.YS_h;

        % manufacturing 
        % 5
        Q.CM = para.gamma1 * p.p_c .* Q.C ./ p.p_m;
        % unskilled labor mkt clearing 26
        Q.L_m = para.L - Q.L_h - Q.L_l - Q.L_a;
        % 11 12
        Q.H_m = (1-para.beta2)*(1-para.v_m) ./(para.alpha2 * para.v_m) .* p.w_l./p.w_h .* Q.L_m;
        
        
        
        % excess demand for skilled labor
        ZH = Q.H_l + Q.H_h + Q.H_m - para.Ht;
        % update skilled labor's wage
        omega = 1e-1; % scale factor
        neww_h  = p.w_h .* (1+ omega * ZH ./ para.Ht );
        dif = 1/omega * max( abs(  (neww_h - p.w_h)./ p.w_h)  ); 
        smooth = .2*rand + .8;
        p.w_h = smooth*neww_h + (1-smooth)*p.w_h;

            
        
        
        
    end
    
    if iter >= 10000
        disp("t_skilled fails. \n");
        return
    end
    
    %fprintf('\t\t t_skilled Iterations completed: %6.0f, and the dif is %e.\n',iter, max(dif));
     
    
    
end

