function [p, Q, para] = solve_ss(para)
%% SOLVE_SS solve steady state
% solve steady state of the trade model with given parameters
% guess the w_l w_h r together and then update them together

    %% 1 guess the w_l, w_h
    p.w_l = 1e-3 * ones(para.num, 1);
    p.w_l = p.w_l ./ sum(p.w_l.*para.L);  % numeraire
    
    
    p.w_h = 1.5 * p.w_l;
    
    iter = 0;
    dif = 10;
    
    while dif > 1e-8 && iter <1e6
        iter = iter + 1;
        %% 2 solve r, p_m and other price indexes
        p = ss_price(p.w_l, p.w_h, para);

        %% 3 solve C, consumption
            [p, Q] = ss_C(p, para);

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
            
            
            %% update w_h
            % 
            omega = 1e-1; 
            neww_h = p.w_h .* (1+ omega * (Q.H_m + Q.H_h + Q.H_l -para.H) ./ para.H );
            dif_w_h =  max(max( abs(  (neww_h - p.w_h)./ p.w_h)  ) ); 
            smooth = .2*rand + .8;
            p.w_h = smooth*neww_h + (1-smooth)*p.w_h;
            
            
            % calculate the capital 
            % 8 agriculture
            Q.K_a = (1-para.alpha1)*p.p_a .* Q.YA ./p.r;
            % 10 11 manufacturing
            Q.K_m = (1-para.alpha2 )/para.alpha2 .* p.w_l .* Q.L_m ./p.r;
            % 14 low skill service
            Q.K_l = (1-para.alpha3-para.beta3) * p.p_l .* Q.YS_l ./p.r;
            % 17 high skill service
            Q.K_h = (1-para.alpha4-para.beta4) * p.p_h .* Q.YS_h ./ p.r;  
            % 11 13
            Q.M = (1-para.v_m) ./ (para.alpha2 * para.v_m) .* p.w_l .* Q.L_m ./ p.p_m ;
            

            % 2 for verification
            Q.K1 = Q.K_a + Q.K_m + Q.K_h + Q.K_l;
            Q.i = para.delta * Q.K;
            % 20
            Q.YM = Q.M + Q.CM + Q.i;
            
            %  calculate the trade flow
            [p, Q] = trade_flow(p, Q, para);

            % gross spending on each sector
            Spnd_m = p.p_m .* (Q.YM);

            % gross output
            Sales_m = repmat(Spnd_m, 1, para.num ) .* Q.pi;
            Q.Y_m = (sum(Sales_m, 1))' ./p.p_m;
%             % verify the Y_m
%             Q.Ym = Q.M ./ (1-para.v_m);


            % trade deficit
            Q.F = Spnd_m - p.p_m .* Q.Y_m;
            
            %% update w_l
            % using trade balance condition
            % excess demand
            Zl = - Q.F ./p.w_l;
            % update unskilled wages
            phi = 1e-1;
            neww_l = p.w_l .* (1+ phi* Zl./para.L);

            %unit =sum( neww_l .* para.L)

            dif_w_l =  max(max( abs( (neww_l-p.w_l)./p.w_l  )  )  ) ;

            smooth = 0.2*rand + 0.8;
            p.w_l = smooth* neww_l + (1- smooth)* p.w_l;
            
            dif = max(dif_w_h, dif_w_l);
            
    end
    
       
    if iter >=10000
        disp('solve_ss2 fails to solve the steady state.');
     end
    
end
