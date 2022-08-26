function [p, Q] = ss_skilled(w_l, para)
%SS_SKILLED wage of skilled labor in loop
%   given unskilled wage, calculate the skilled labor's wage 
    
%% guess the wage of skilled labor
    p.w_l = w_l;
    p.w_h = w_l;
    
    iter = 0;
    dif = 100;
    omega = 1e-1; % Scale factor used to ensure that neww_h > 0.
    
    while dif > 1e-8 & iter<10000
        iter = iter +1 ;
        p = ss_price(p.w_l, p.w_h, para);
        
        %% caluculte production of low-skill service
        [p, Q] = ss_YS_l(p, para);
        
        %% solve quantity
        % low skill service
        % 22
        Q.CS_l = Q.YS_l;
        % 15
        Q.H_l = para.beta3* p.p_l .* Q.YS_l ./p.w_h;
        % 14
        Q.L_l = para.alpha3* p.p_l .* Q.YS_l ./p.w_l;
        
        % agriculture
        % 4 5
        Q.YA = para.theta_a + (1-para.gamma1-para.gamma2-para.gamma3)/para.gamma1 * p.p_l./p.p_a.*(Q.YS_l + para.theta_l);
        % 8
        Q.L_a = para.alpha1 * Q.YA .* p.p_a ./p.w_l;
        % 19
        Q.CA = Q.YA;
        
        % high skill service 
        % 5 6
        Q.YS_h = para.gamma3/para.gamma2 * p.p_l./p.p_h .* (Q.YS_l + para.theta_l) - para.theta_h;
        % 17
        Q.L_h = para.alpha4* p.p_h .* Q.YS_h ./p.w_l;
        % 18
        Q.H_h = para.beta4* p.p_h .* Q.YS_h ./p.w_h;
        Q.CS_h = Q.YS_h;

        % manufacturing 
        % unskilled labor mkt clearing 25
        Q.L_m = para.L - Q.L_h - Q.L_l - Q.L_a;
        % 10  11
        Q.H_m = para.beta2/para.alpha2 * p.w_l./p.w_h .* Q.L_m;
        
        
        
        %% update p.w_h
        neww_h = p.w_h .* (1+ omega * (Q.H_m + Q.H_h + Q.H_l -para.H) ./ para.H );
        dif = 1/omega * max( abs(  (neww_h - p.w_h)./ p.w_h)  ); 
        smooth = .2*rand + .8;
        p.w_h = smooth*neww_h + (1-smooth)*p.w_h;
        
    end
    
    if iter >= 10000
        display("ss_skilled fails. \n");
        return
    end
    
end

