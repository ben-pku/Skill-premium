function [p, Q] = t_path(para, ssp, ssQ)
%% T_PATH Solve the transition path for all economies
%   Solve the transitional path in algorithm II 
%   Guess rho, w_l, w_h, and r altogether, update the four altogether
        
        t_path = tic;
        
        %%  guess rho, w_l, w_h, and r
        
        % Guess investment rate \rho in each time 
        Q.rho = 0.5 * ones(para.num, para.TT);
        % make sure the K_T+1 = K*
        KT1 = ssQ.K;
        
        p.w_l =zeros(para.num, para.TT);
        
        iter = 0;  % number of iterations
        dif = 10; % convergent indicator
        
        while dif > 1e-3 && iter <1e6
            iter = iter + 1;
            
            % solve right w_l, w_h, r, given rho
            [p, Q] = t_wager(p, Q, para, ssp, ssQ);

%             % calculate all price indexes
%             p = t_price(p, para, ssp);
% 
%             % locus of capital
%             Q.K = repmat(para.K1, 1, para.TT);
%             for t = 1: (para.TT-1)
%                 Q.K(:, t+1)  =  (1- para.delta) * Q.K(:, t) + Q.rho(:, t) .* ( p.r(:, t) .* Q.K(:, t) + p.w_l(:, t) .* para.Lt(:, t) + p.w_h(:, t) .* para.Ht(:, t) );
%             end
%             
%             % quantity
%             [p, Q] = t_alloc(p, Q, para, ssp, ssQ);
%             
%             %% update r, w_h, w_l, and rho
%             % update r
%             % excess demand for capital
%             ZK =  Q.K_m + Q.K_l + Q.K_h + Q.K_l - Q.K;
%             % update interest rate
%             phi = 1e-1; % Scale factor
%             newr= p.r .* (1+ phi * ZK ./ Q.K );
%             dif_r = max( max( abs(ZK ./ Q.K)  ) );
%             smooth = .2*rand + .8;
%             p.r = smooth*newr + (1-smooth)*p.r;
%             
%             % update w_h
%             % excess demand for skilled labor
%             ZH = Q.H_l + Q.H_h + Q.H_m - para.Ht;
%             % update skilled labor's wage
%             omega = 1e-1; % scale factor
%             neww_h  = p.w_h .* (1+ omega * ZH ./ para.Ht );
%             dif_w_h =  max( max( abs(ZH ./ para.Ht) )  ); 
%             smooth = .2*rand + .8;
%             p.w_h = smooth*neww_h + (1-smooth)*p.w_h;
%             
%             % quantity        
%             % CM 5
%             Q.CM = para.gamma1 / para.gamma2 * p.p_l ./ p.p_m .* ( Q.CS_l + para.theta_l );
%             % M 12 10
%             Q.M = repmat( (1-para.v_m) ./ (para.alpha2 * para.v_m) , 1 , para.TT ) .* p.w_l .* Q.L_m ./ p.p_m;
%             % calculate the YM
%             Q.i = Q.rho .* (p.r .* Q.K + p.w_l .* para.Lt + p.w_h .* para.Ht);
%             Q.YM = Q.CM + Q.i + Q.M;
% 
% 
%             %%  calculate the trade flow
%             [p, Q] = trade_dy_flow(p, Q, para); % dynamic trade flow
% 
%             % gross spending on each sector
%             Spnd_m = p.p_m .* (Q.YM);
%             Spnd_m = reshape(Spnd_m, [para.num, 1 , para.TT]) ;
%             Sales_m = repmat(Spnd_m, 1, para.num, 1 ) .* Q.pi;
%             Q.Y_m = reshape( sum(Sales_m, 1), para.num, para.TT ) ./ p.p_m;
% 
%             % verify the Y_m %
%             Q.Y_m = Q.M ./ repmat(1-para.v_m, 1, para.TT);
% 
%             % trade deficit
%             Spnd_m = reshape(Spnd_m, [para.num , para.TT]) ;
%             Q.F = Spnd_m - p.p_m .* Q.Y_m;
% 
%             % update w_l
%             % excess demand
%             Zl = - Q.F ./p.w_l;
%             % update unskilled wages
%             psi = 1e-1; % scale factor
%             neww_l = p.w_l .* (1+ psi* Zl./para.Lt);
%             dif_w_l =  max(max( abs( (neww_l-p.w_l)./p.w_l  )  )  ) ;
%             smooth = 0.2*rand + 0.8;
%             p.w_l = smooth* neww_l + (1- smooth)* p.w_l;



%%%%%%%%%%%%%%%%%%%%%%%%%%
                Q.C = (Q.CA - para.theta_a) .^ (1-para.gamma1 - para.gamma2-para.gamma3 ) .* Q.CM .^para.gamma1 .* (Q.CS_l +para.theta_l).^para.gamma2 .* (Q.CS_h + para.theta_h).^para.gamma3  ;
                
                %p.p_c = ( p.p_a .* (Q.CA - para.theta_a)+ p.p_m .* Q.CM  + p.p_l .* (Q.CS_l + para.theta_l) + p.p_h .* (Q.CS_h+para.theta_h)) ./ Q.C ;
                
                    p.p_c = (p.p_a/( 1-para.gamma1 - para.gamma2-para.gamma3 )) .^ (1-para.gamma1 - para.gamma2-para.gamma3 ) .* ...
            ( p.p_m/para.gamma1 ) .^para.gamma1 .* ( p.p_l/para.gamma2 ).^para.gamma2 .* ( p.p_h/para.gamma3).^para.gamma3  ;
                
                Zeuler = para.beta.^para.sigma * ...
                    (p.p_c./ [p.p_c(:, 2 : para.TT), ssp.p_c]).^para.sigma .* ...
                    ( ([p.r(:, 2:para.TT), ssp.r] + (1-para.delta)* [p.p_m(:, 2:para.TT), ssp.p_m] )./p.p_m ) .^para.sigma - ...
                    Q.C ./ [Q.C(:, 2 : para.TT), ssQ.C];
%%%%%%%%%%%%%%%%

            % update the investment rate
            tau = 1e-1; %scale factor
            new_rho = Q.rho .* (1 + tau * Zeuler) ;
            % update -- locus of capital
            Q.K = repmat(para.K1, 1, para.TT);
            for t = 1: (para.TT-1)
                Q.K(:, t+1)  =  (1- para.delta) * Q.K(:, t) + new_rho(:, t) .* ( p.r(:, t) .* Q.K(:, t) + p.w_l(:, t) .* para.Lt(:, t) + p.w_h(:, t) .* para.Ht(:, t) );
            end
            new_rho(:, para.TT) = (KT1 - (1- para.delta) * Q.K(:, para.TT)) ./ ( p.r(:, para.TT) .* Q.K(:, para.TT) + p.w_l(:, para.TT) .* para.Lt(:, para.TT) + p.w_h(:, para.TT) .* para.Ht(:, para.TT) ) ;
            dif_rho = max(abs( (new_rho-Q.rho)./ new_rho ) ) ;
            smooth = 0.2*rand + 0.8;
            Q.rho = smooth * new_rho + (1-smooth) * Q.rho;
            
            dif = max(dif_rho);

            telapsed=toc(t_path); sec=mod(telapsed,60); mnt=floor(telapsed/60);
            fprintf(' t_path Iterations completed: %6.0f\n',iter);
            fprintf('\t\t time elapsed: %6.0f min, %2.0f sec\n',mnt,sec);
            fprintf('\t\t dif rho: %e\n',dif);
%             fprintf('\t\t dif w_l: %e\n',dif_w_l);
%             fprintf('\t\t dif w_h: %e\n',dif_w_h);
%             fprintf('\t\t dif r: %e\n',dif_r);
        end
        
end

