function [p, Q] = t_skilled(p, Q, para, ssp, ssQ)
%T_SKILLED Calculate right skilled labor's wage
%  Guess and update skilled labor's wage by skilled labor market clearing
%  condition

    %% Guess skilled labor's wage w_h
    p.w_h = p.w_l;
    
    iter = 0;
    dif = 10;
    
    while max(dif)>1e-5 && iter<10000
        iter = iter + 1;
        
        % calculate interest rate in each country
        [p, Q] = t_interest(p, Q, para, ssp, ssQ);
        
        % excess demand for skilled labor
        ZH = Q.H_l + Q.H_h + Q.H_m - para.Ht;
        % update skilled labor's wage
        omega = 1e-1; % scale factor
        neww_h  = p.w_h .* (1+ omega * ZH ./ para.Ht );
        dif = 1/omega * max( abs(  (neww_h - p.w_h)./ p.w_h)  ); 
        smooth = .2*rand + .8;
        p.w_h = smooth*neww_h + (1-smooth)*p.w_h;
        
        if mod(iter, 1) ==0
            fprintf('\t\t t_skilled Iterations completed: %6.0f, and the dif is %e.\n',iter, max(dif));
        end
        
        
    end
    
    if iter >= 10000
        display("t_skilled fails. \n");
        return
    end
    
     
    
    
end

