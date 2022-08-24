function [p, Q] = t_wager(p, Q, para, ssp, ssQ)
%% T_WAGER  solve right w_l, w_h, r, given rho
%   given rho, calculate the wages and r, and allocation

    iter = 0;
    dif = 10;
    
    % guess unskilled labor's wage in each time 
    p.w_l = repmat(ssp.w_l, 1, para.TT) ;
    wwl = sum(p.w_l .* para.Lt ,  1) ; % world labor return
    p.w_l = p.w_l ./ repmat(wwl, para.num, 1); % normalized w_l

%     % guess skilled labor's wage in each time
%     p.w_h =  repmat(ssp.w_h, 1, para.TT);

%     % guess interest rate r
%     p.r = repmat(ssp.r, 1, para.TT);
    
    while dif>1e-3  && iter< 1e4
            iter = iter + 1;
            % solve the right interest rate r ,and skilled labor's wage w_h
            [p, Q] = t_interest(p, Q, para, ssp, ssQ);

%     % calculate all price indexes
%             p = t_price(p, para, ssp);
% 
%             % locus of capital
%             Q.K = repmat(para.K1, 1, para.TT);
%             for t = 1: (para.TT-1)
%                 Q.K(:, t+1)  =  (1- para.delta) * Q.K(:, t) + Q.rho(:, t) .* ( p.r(:, t) .* Q.K(:, t) + p.w_l(:, t) .* para.Lt(:, t) + p.w_h(:, t) .* para.Ht(:, t) );
% 
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
%             newr= p.r .* (1- phi * ZK ./ Q.K );
%             dif_r = max( max( abs(ZK ./ Q.K)  ) );
%             smooth = .2*rand + .8;
%             p.r = smooth*newr + (1-smooth)*p.r;
            
%             % update w_h
%             % excess demand for skilled labor
%             ZH = Q.H_l + Q.H_h + Q.H_m - para.Ht;
%             % update skilled labor's wage
%             omega = 1e-1; % scale factor
%             neww_h  = p.w_h .* (1+ omega * ZH ./ para.Ht );
%             dif_w_h =  max( max( abs( (neww_h - p.w_h)./p.w_h  ) )  ); 
%             smooth = .2*rand + .8;
%             p.w_h = smooth*neww_h + (1-smooth)*p.w_h;
            
            % quantity        
            % CM 5
            Q.CM = para.gamma1 / para.gamma2 * p.p_l ./ p.p_m .* ( Q.CS_l + para.theta_l );
            % M 12 10
            Q.M = repmat( (1-para.v_m) ./ (para.alpha2 * para.v_m) , 1 , para.TT ) .* p.w_l .* Q.L_m ./ p.p_m;
            % calculate the YM
            Q.i = Q.rho .* (p.r .* Q.K + p.w_l .* para.Lt + p.w_h .* para.Ht);
            Q.YM = Q.CM + Q.i + Q.M;


            %%  calculate the trade flow
            [p, Q] = trade_dy_flow(p, Q, para); % dynamic trade flow

            % gross spending on each sector
            Spnd_m = p.p_m .* (Q.YM);
            Spnd_m = reshape(Spnd_m, [para.num, 1 , para.TT]) ;
            Sales_m = repmat(Spnd_m, 1, para.num, 1 ) .* Q.pi;
            Q.Y_m = reshape( sum(Sales_m, 1), para.num, para.TT ) ./ p.p_m;

%             % verify the Y_m %
%             Q.Y_m = Q.M ./ repmat(1-para.v_m, 1, para.TT);

            % trade deficit
            Spnd_m = reshape(Spnd_m, [para.num , para.TT]) ;
            Q.F = Spnd_m - p.p_m .* Q.Y_m;

            % update w_l
            % excess demand
            Zl = - Q.F ./p.w_l;
            % update unskilled wages
            psi = 1e-1; % scale factor
            neww_l = p.w_l .* (1+ psi* Zl./para.Lt);
            dif_w_l =  max(max( abs( (neww_l-p.w_l)./p.w_l  )  )  ) ;
            smooth = 0.2*rand + 0.8;
            p.w_l = smooth* neww_l + (1- smooth)* p.w_l;
            
            dif = max(dif_w_l);
            
    end
    
    if iter >=1e4
        disp('t_wager fails./n');
    end
end

