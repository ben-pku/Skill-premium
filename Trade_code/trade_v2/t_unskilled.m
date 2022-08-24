function [p, Q] = t_unskilled(Q, para, ssp, ssQ)
%T_UNSKILLED Calculate the right unskilled labor wage
%   Guess and update the unskilled labor wage
    t_unskilled = tic;
    %% Guess the unskilled labor wage w_l
    p.w_l = 1e-3 * ones(para.num, para.TT);
    wwl = sum(p.w_l .* para.Lt ,  1) ; % world labor return
    p.w_l = p.w_l ./ repmat(wwl, para.num, 1); % normalized w_l
    
    % capital in each period
    Q.K = para.K1;
    
    iter = 0;
    dif = 10;
    
    while max(dif) > 1e-3 && iter<= 10000

        iter = iter + 1;
        % calculte the skilled labor's wage
        [p, Q] = t_skilled(p, Q, para, ssp, ssQ);
        
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
        
        % gross output
%         for t = 1: para.TT
%             Sales_m = repmat(Spnd_m(:, t), 1, para.num ) .* Q.pi(:, :, t);
%             Q.Y_m(:, t) = (sum(Sales_m, 1))' ./p.p_m(:, t);
%         end
        Spnd_m = reshape(Spnd_m, [para.num, 1 , para.TT]) ;
        Sales_m = repmat(Spnd_m, 1, para.num, 1 ) .* Q.pi;
        Q.Y_m = reshape( sum(Sales_m, 1), para.num, para.TT ) ./ p.p_m;
        
        
        % verify the Y_m %
        Q.Y_m = Q.M ./ repmat(1-para.v_m, 1, para.TT);

        
        % trade deficit
        Spnd_m = reshape(Spnd_m, [para.num , para.TT]) ;
        Q.F = Spnd_m - p.p_m .* Q.Y_m;


        %%  update wage vectors
        % excess demand
        Zl = - Q.F ./p.w_l;
        % update unskilled wages
        psi = 1e-1; % scale factor
        neww_l = p.w_l .* (1+ psi* Zl./para.Lt);
        
        %unit =sum( neww_l .* para.L)

        dif = 1/psi * max(max( abs( (neww_l-p.w_l)./p.w_l  )  )  ) ;

        smooth = 0.2*rand + 0.8;
        p.w_l = smooth* neww_l + (1- smooth)* p.w_l;

        
        telapsed=toc(t_unskilled); sec=mod(telapsed,60); min=floor(telapsed/60);
        fprintf('\t t_unskillled Iterations completed: %6.0f\n',iter);
        fprintf('\t\t\t time elapsed: %6.0f min, %2.0f sec\n',min,sec);
        fprintf('\t\t\t dif w_l: %e\n',max(dif));
        
        end
    
    if iter >= 1e4
        disp('t_unskilled fails.\n');
        return
    end
    

end

