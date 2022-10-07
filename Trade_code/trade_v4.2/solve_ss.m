function [p, Q, para] = solve_ss(para)
%% SOLVE_SS solve steady state
% solve steady state of the trade model with given parameters
% guess the w_l w_h r together and then update them together

    %% 1 guess the w_l
    p.w_l = 1 * ones(para.num, 1);
    p.w_l = p.w_l ./ sum(p.w_l.*para.L);  % numeraire  
    Q.num = para.num;
    
    %solve skilled labor's wage
    [p, Q] = ss_skilled(p, Q, para);
    
    
    iter = 0;
    dif = 10;
    
    while dif > 1e-8 && iter <1e6
        iter = iter + 1;
        %% 2 solve r, p_m and other price indexes
%         p = ss_price(p, para);

        %% 3 solve C, consumption 
%             [p, Q] = ss_C(p, para);
            
            %[p, Q] = ss_skilled(p, Q, para);
%             YM = p.p_ms .* Q.sm ./ (para.v1* p.p_m);  % not really clear
%             Q.M = (1-para.v1) * YM;
%             Q.i = para.delta * Q.K;
%             % demand
%             Q.YM = Q.M + Q.Cm + Q.i;
% 
%             %% update w_h
%             % 
%             omega = 9e-1; 
%             neww_h = p.w_h .* (1+ omega * (Q.Hm + Q.Hsh + Q.Hsl -Q.H) ./Q.H .*p.w_h );
%             dif_w_h =  max( abs(  (neww_h - p.w_h)./ p.w_h)  ) ; 
%             smooth = .1*rand + .9;
%             p.w_h = smooth*neww_h + (1-smooth)*p.w_h;
            

            %  calculate the trade flow
            [p, Q] = trade_flow(p, Q, para);

            % gross spending on each sector
            Spnd_m = p.p_m .* Q.YM;

            % gross output
            Sales_m = repmat(Spnd_m, 1, para.num ) .* Q.pi;
            Q.Y_m = (sum(Sales_m, 1))' ./p.p_m;  % output
%             % verify the Y_m
%             Q.Ym = Q.M ./ (1-para.v_m);

            % trade deficit
            Q.F = Spnd_m - p.p_m .* Q.Y_m;
            
            %% update w_l
            % using trade balance condition
            % excess demand
            Zl = - Q.F ./p.w_l;
            % update unskilled wages
            phi = 9e-1;
            neww_l = p.w_l .* (1+ phi* Zl./para.L);

            %unit =sum( neww_l .* para.L)

            dif_w_l =  max( abs( (neww_l-p.w_l)./p.w_l  )  )  ;

            smooth = 0.1*rand + 0.9;
            p.w_l = smooth* neww_l + (1- smooth)* p.w_l;
            
            dif = max(dif_w_h, dif_w_l);
            
    end
    
       
    if iter >=10000
        disp('solve_ss fails to solve the steady state.');
     end
    
end
