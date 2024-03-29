function [p, Q] = t_path(para, ssp, ssQ)
%% T_PATH Solve the transition path for all economies
%   Solve the transitional path
%   Guess locus of capital, w_l, and w_h altogether, update the 3
        
        t_path = tic;
        
        %%  guess the locus of capital, w_l, w_h
        % Guess the locus of capital
        Q.K = repmat(para.K1, 1, para.TT);       
        KT1 = ssQ.K; % make sure the K_T+1 = K*       
        grow = ( KT1 ./ para.K1 ) .^ (1/(para.TT-1)) ;
        
        time = linspace(0, para.TT-1, para.TT);
        Q.K = Q.K .* (repmat(grow, 1, para.TT) .^ time);

         % guess unskilled labor's wage in each time 
        p.w_l = repmat(ssp.w_l, 1, para.TT) ;
        wwl = sum(p.w_l .* para.Lt ,  1) ; % world labor return
        p.w_l = p.w_l ./ repmat(wwl, para.num, 1); % normalized w_l
        
        % Guess skilled labor's wage w_h
        p.w_h = p.w_l ;
        
        iter = 0;  % number of iterations
        dif = 10; % convergent indicator
        
        while dif > 1e-5 && iter <1e6
            iter = iter + 1;
            
            % solve right w_l, w_h, r, given K
            [p, Q] = t_wager(p, Q, para, ssp, ssQ);

            Q.C = (Q.CA - para.theta_a) .^ (1-para.gamma1 - para.gamma2-para.gamma3 ) .* Q.CM .^para.gamma1 .* (Q.CS_l +para.theta_l).^para.gamma2 .* (Q.CS_h + para.theta_h).^para.gamma3  ;
             
            %% update the locus of capital
            RHS3 =  (  p.p_c ./[ p.p_c(:, 2:para.TT), ssp.p_c] ) .^(para.sigma-1) .* (para.beta * ( [p.r(:, 2:para.TT) , ssp.r] +(1-para.delta)* [ p.p_m(:, 2:para.TT), ssp.p_m] ) ./ p.p_m ) .^para.sigma ;
            Kn = Q.K;
            for t = 1:para.TT-2
                % update K_t+1
                Kn(:, t+1) = ...
                    (  p.p_m(:, t+1) .* Q.K(:, t+2) - ( p.w_l(:, t+1).*para.Lt(:, t+1) + p.w_h(:, t+1) .* para.Ht(:, t+1) ) + RHS3(:, t)  .* ( p.w_l(:, t).* para.Lt(:, t) + p.w_h(:, t).* para.Ht(:, t) + ( p.r(:, t) + (1-para.delta)*p.p_m(:, t) ).*Q.K(:, t) ) )...
                    ./ ...
                    ( p.r(:, t+1) + (1-para.delta)*p.p_m(:, t+1) + RHS3(:, t) .* p.p_m(:, t)  );
            end
            dif_k = Kn-Q.K;
            dif = max( max( abs( dif_k ) ) );
            smooth = .2*rand + .8;
            Q.K = (1-smooth)*Q.K+smooth * Kn;

            if mod(iter, 20)==0
                telapsed=toc(t_path); sec=mod(telapsed,60); mnt=floor(telapsed/60);
                fprintf(' t_path Iterations completed: %6.0f\n',iter);
                fprintf('\t\t time elapsed: %6.0f min, %2.0f sec\n',mnt,sec);
                fprintf('\t\t distence of two locus of K: %e\n',dif);
    %             fprintf('\t\t dif w_l: %e\n',dif_w_l);
    %             fprintf('\t\t dif w_h: %e\n',dif_w_h);
    %             fprintf('\t\t dif r: %e\n',dif_r);
            end
            
            if min(min(Q.i)) <0
                disp("stop");
            end
        end
        
        if iter <= 1e4
            disp('---------------------------------------------------------------');
            disp('transition path solved');
        end
        
end

