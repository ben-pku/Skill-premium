function [p, Q] = ss_skilled(p, Q , para)
%SS_SKILLED wage of skilled labor in loop
%   given unskilled wage, calculate the skilled labor's wage 
    
    p.w_h = 1.5 * p.w_l;
    
    iter = 0;
    dif = 100;
    
    while dif > 1e-6 & iter<10000
            iter = iter +1 ;
            
            % solve r and p_m
            p = ss_price(p, para);  
            % solve allocation problem
            [p, Q] = ss_C(p, para);
            
            YM = p.p_ms .* Q.sm ./ (para.v1* p.p_m);  % not really clear
            Q.M = (1-para.v1) * YM;
            Q.i = para.delta * Q.K;
            % demand
            Q.YM = Q.M + Q.Cm + Q.i;

            %% update w_h
            % 
            omega = 9e-1; 
            neww_h = p.w_h .* (1+ omega * (Q.Hm + Q.Hsh + Q.Hsl -Q.H) ./Q.H .*p.w_h );
            dif =  max( abs(  (neww_h - p.w_h)./ p.w_h)  ) ; 
            smooth = .1*rand + .9;
            p.w_h = smooth*neww_h + (1-smooth)*p.w_h;
        
    end
    
    if iter >= 10000
        display("ss_skilled fails. \n");
        return
    end
    
end

