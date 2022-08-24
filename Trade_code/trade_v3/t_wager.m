function [p, Q] = t_wager(p, Q, para, ssp, ssQ)
%% T_WAGER  solve right w_l, w_h, r, given K
%   given rho, calculate the wages and r, and allocation

    iter = 0;
    dif = 10;
    
    
    while dif>1e-5  && iter< 1e4
            iter = iter + 1;
            % solve the right interest rate r 
            p.r = (1-para.alpha1)/para.alpha1 * p.w_l .* para.Lt ./ Q.K;
            % solve the skilled labor's wage w_h
            [p, Q] = t_skilled(p, Q, para, ssp, ssQ);
            
            % quantity        
            % M 13 11
            Q.M = repmat( para.beta2 * (1-para.v_m) ./ (para.alpha2 * para.v_m) , 1 , para.TT ) .* p.w_l .* Q.L_m ./ p.p_m;
            % calculate the YM
            K1 = Q.K;
            K1(:, 1)= [ ];
            K1(:, para.TT) = ssQ.K;
            Q.i = K1 - (1-para.delta) * Q.K;
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
           % dif_w_l =  max(max( abs( (neww_l-p.w_l)./p.w_l  )  )  ) ;
            dif = max( max(Zl) );
            smooth = 0.2*rand + 0.8;
            p.w_l = smooth* neww_l + (1- smooth)* p.w_l;
            
      
            
    end
    
    %fprintf('\t t_wager Iterations completed: %6.0f, and the dif is %e.\n',iter, max(dif));
    if iter >=1e4
        disp('t_wager fails./n');
    end
end

