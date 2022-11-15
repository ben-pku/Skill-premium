function [p, Q, fl] = temp_e(p, Q, fl, t, pa)
%% TEMP_E solve temporary equilibrium
%   semi dynamic exact-hat algebra, given t-1 solve t

    iter = 0;
    dif = 10;
    tol = 1e-7;
    
    while dif > tol && iter < 1e4
        iter = iter + 1;
        % 5 a | calculate the trade flow and price hat
        
        [p, Q, fl, new] = t_hat(p, Q, fl, t,  pa);
        
        % 5 b | update the factor prices
        
        new1 = factor( p, Q, fl, t,  pa ) ;
        % numeraire
        numeraire = new1.w_Lh(2);
        new1.w_Lh = new1.w_Lh / numeraire;
        new1.r_h = new1.r_h / numeraire;
        new.p1_h = new.p1_h / numeraire;
        new.p2_h = new.p2_h / numeraire;
        
        %
        vfactor = -0.1;
        zw2 = p.w_Lh(: , t) - new1.w_Lh ;
        zw3 = p.r_h(: , t) - new1.r_h  ;
        zw4 = p.p1_h(: , t) - new.p1_h ;
        zw5 = p.p2_h(: , t) - new.p2_h  ;


        adj2 = p.w_Lh(:, t) .*( 1+ vfactor*zw2./  p.w_Lh(:, t)  );
        adj3 = p.r_h(:, t) .*( 1+ vfactor*zw3./  p.r_h(:, t)  );
        adj4 = p.p1_h(:, t) .*( 1+ vfactor*zw4./  p.p1_h(:, t)  );
        adj5 = p.p2_h(:, t) .*( 1+ vfactor*zw5./  p.p2_h(:, t)  );
        
        dif2 = p.w_Lh(:, t) - adj2;
        dif3 = p.r_h(:, t) - adj3;
        dif4 = p.p1_h(:, t) - adj4;
        dif5 = p.p2_h(:, t) - adj5;

        dif = sum(([dif2; dif3; dif4; dif5 ]).^2) ;
        %smooth = 0.9 + 0.1 * rand;
        p.w_Lh(:, t) =adj2; %(1-smooth) * p.w_Lh(:, t) + smooth * new.w_Lh(:, t);
        p.r_h(:, t) = adj3; %(1-smooth) * p.r_h(:, t) + smooth * new.r_h(:, t);
        p.p1_h(:, t) = adj4;
        p.p2_h(:, t) = adj5;

    end
    
    
    if iter==1e4
        disp("temp_e.m Fails to solve the time-t equilibrium (t) -- reach max iter\n");
        pause;
    end
    
    
     % 5 c update gross rental rates R and factor prices
    if t == 1
        p.R(:, t) = 1- pa.delta + p.r_h(:, t)./ ( p.p1_h(:,t).^pa.gamma(1) .*  p.p2_h(:,t).^pa.gamma(2) ) ...
            .*(p.R0-1+ pa.delta) ; 
        p.w_L(:, t) = p.w_Lh(:, t) .* p.w_L0;
        p.r(:, t) = p.r_h(:, t) .* p.r0;
    else
        p.R(:, t) = 1- pa.delta + p.r_h(:, t)./ ( p.p1_h(:,t).^pa.gamma(1) .*  p.p2_h(:,t).^pa.gamma(2) ) ...
            .*(p.R(:,t-1)-1+ pa.delta) ; 
        p.w_L(:, t) = p.w_Lh(:, t) .* p.w_L(:, t-1);
        p.r(:, t) = p.r_h(:, t) .* p.r(:, t-1);
    end
            
    % 5 d update capital t+1
    if t <pa.T+1
        Q.k(:, t+1) = (1- Q.sigma(:, t)) .* p.R(:, t) .* Q.k(:, t);
    end

    

end

