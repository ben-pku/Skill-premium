function [p, Q] = t_invest(para, ssp, ssQ)
%T_INVEST calculate the whole transition path
%   Guess investment rate, update investment rate by Euler Equation
    
    t_invest = tic;
    %% Guess investment rate \rho in each time 
    Q.rho = 0.5 * ones(para.num, para.TT);
    
    % make sure the K_T+1 = K*
    KT1 = ssQ.K;
    
    iter = 0;
    dif = 10;
    while dif > 1e-3 && iter <10000 
        iter = iter + 1;
        
        % calculate the unskilled labor's wage
        [p, Q] = t_unskilled(Q, para, ssp, ssQ);
        
        filename = 'test.mat';
        save(filename)
       
        % Euler residual
        Zr = 1/para.beta * 1./ ( 1- para.delta + [p.r(:, 2: para.TT), ssp.r]./[p.p_m(:, 2:para.TT), ssp.p_m] ) ...
                -   ( ( [Q.CA(:, 2: para.TT), ssQ.CA] - para.theta_a ) ./(Q.CA - para.theta_a)  ) .^(1-para.gamma1-para.gamma2-para.gamma3) ...
                .* ([Q.CM(:, 2:para.TT), ssQ.CM] ./ Q.CM ) .^(para.gamma1 - 1) ...
                .* ( ( [Q.CS_l(:, 2: para.TT), ssQ.CS_l] + para.theta_l )./( Q.CS_l + para.theta_l ) )  .^ para.gamma2 ... 
                .* ( ( [Q.CS_h(:, 2: para.TT), ssQ.CS_l] + para.theta_h )./( Q.CS_h + para.theta_h ) )  .^ para.gamma3;
        
        % update the investment rate
        tau = 1e-1; %scale factor
        new_rho = Q.rho .* (1 + tau * Zr) ;
        dif = 1/tau * max(  max( abs( Zr ) )   ) ;
        smooth = 0.2*rand + 0.8;
        Q.rho = smooth * new_rho + (1-smooth) * Q.rho;
        
        telapsed=toc(t_invest); sec=mod(telapsed,60); mnt=floor(telapsed/60);
        fprintf('\t t_invest Iterations completed: %6.0f\n',iter);
        fprintf('\t\t time elapsed: %6.0f min, %2.0f sec\n',mnt,sec);
        fprintf('\t\t dif inv rate: %3.10f\n',dif);
    end

    if iter >= 1e-4
        disp('t_invest fails.\n');
        return
    end
    
    

    


end

