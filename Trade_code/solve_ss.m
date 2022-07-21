function [p, Q, para] = solve_ss(para)
%% SOLVE_SS solve steady state
% solve steady state of the trade model with given parameters

    %% 1 guess the w_L 
    p.w_l = 1e-3 * ones(para.num, 1);
    p.w_l = p.w_l ./ sum(p.w_l.*para.L);  % numeraire
    scl = 1e-1;
    
    
    %% 2 iteration for the wage of unskilled labor
    dif = 10;
    iter=0;

    while dif>=1e-6 && iter <10000 
        iter = iter+1;
        
        %% 3 get the corresponding skilled labor's wage
        [p, Q] = ss_skilled(p.w_l, para);
        
        % calculate the capital 
        % 7 agriculture
        Q.K_a = (1-para.alpha1)*p.p_a .* Q.YA ./p.r;
        % 9 10 manufacturing
        Q.K_m = (1-para.alpha2 - para.beta2)/para.alpha2 .* p.w_l .* Q.L_m ./p.r;
        % 13 low skill service
        Q.K_l = (1-para.alpha3-para.beta3) * p.p_l .* Q.YS_l ./p.r;
        % 16 high skill service
        Q.K_h = (1-para.alpha4-para.beta4) * p.p_h .* Q.YS_h ./ p.r;  
        % 10 12
        Q.M = (1-para.v_m) ./ (para.alpha2 * para.v_m) .* p.w_l .* Q.L_m ./ p.p_m ;
        % 5
        Q.CM = para.gamma1/para.gamma2 * p.p_l./p.p_m .*(Q.CS_l + para.theta_l);
        
        % 2
        Q.K = Q.K_a + Q.K_m + Q.K_h + Q.K_l;
        Q.i = para.delta * Q.K;
        % 20
        Q.YM = Q.M + Q.CM + Q.i;
        
        %% 4 calculate the trade flow
        [p, Q] = trade_flow(p, Q, para);
        
        % gross spending on each sector
        Spnd_m = p.p_m .* (Q.YM);
        
        % gross output
        Sales_m = repmat(Spnd_m, 1, para.num ) .* Q.pi;
        Q.Y_m = (sum(Sales_m, 1))' ./p.p_m;
        % verify the Y_m
        Q.Ym = Q.M ./ (1-para.v_m);

        
        % trade deficit
        Q.F = Spnd_m - p.p_m .* Q.Y_m;


        %% 5 update wage vectors
        % excess demand
        Zl = - Q.F ./p.w_l;
        % update unskilled wages
        neww_l = p.w_l .* (1+ scl* Zl./para.L);
        
        %unit =sum( neww_l .* para.L)

        dif = 1/scl * max(max( abs( (neww_l-p.w_l)./p.w_l  )  )  ) ;

        smooth = 0.2*rand + 0.8;
        p.w_l = smooth* neww_l + (1- smooth)* p.w_l;

    end

    
    if iter >=10000
        display('Fail to solve the steady state.');
     end
    
end
