function [p, Q, fl] = tran(  pa )
%% TRAN  solve the transitional path
%   Solve the transitional path, given initial migration and population
% By Semi-Dynamic Exact-hat algebra
% p - price, Q - quantity, fl - flows
% from t=0 to t = T+1

%% 1 guess the u_h , sigma
    Q.u_Hh = repmat( logspace(log10(2), 0,  pa.T+1 ), pa.num , 1);
    Q.u_Lh = repmat( logspace(log10(2), 0,  pa.T+1 ), pa.num , 1);
    Q.sigma = (1-pa.beta)*ones(pa.num, pa.T+1); % t=0 - T

    % create other variables
    p.R = [NaN(pa.num, pa.T)  1/pa.beta * ones(pa.num,1)];
    Q.k = [pa.k1 NaN(pa.num, pa.T)] ;  %k1 and kt
    fl.D_H = NaN(pa.num, pa.num, pa.T+1);
    fl.D_Hh = NaN(pa.num , pa.num , pa.T+1);
    fl.D_L = NaN(pa.num, pa.num, pa.T+1);
    fl.D_Lh = NaN(pa.num , pa.num , pa.T+1);

    p.p_h = NaN(pa.num, pa.T+1);

    flag = 1; % nonnegative value
    iter = 0;
    dif = 10;
    tol = 1e-7;
    while (iter <=1e4 && dif >tol && flag)
        iter = iter + 1;
        
        %% 2 Set the gross rental rates in period t = 0
        p.R0 = pa.k1./pa.k0 ./ ( 1 - Q.sigma(:, 1) );
        
        %% 3 get migration rates
        % H and L
        for t = 0 : pa.T
            % solve fl.D_Hh and fl.D_H (t+1)
            if t == 0
                numer = repmat( Q.u_Hh( :, t+2), 1, pa.num) ./ (pa.kappa_h(:, : , t+1).^(1/pa.rho)) ;
                denom = sum(pa.D_H' .* numer , 1); % 1* pa.num
                fl.D_Hh( :, :, t+1) =  ( numer./ repmat(denom, pa.num , 1) )';
                fl.D_H(:, :, t+1) = fl.D_Hh( :, :, t+1) .* pa.D_H;
                
                numer = repmat( Q.u_Lh( :, t+2), 1, pa.num) ./ (pa.kappa_h(:, : , t+1).^(1/pa.rho)) ;
                denom = sum(pa.D_L' .* numer , 1); % 1* pa.num
                fl.D_Lh( :, :, t+1) =  ( numer./ repmat(denom, pa.num , 1) )';
                fl.D_L(:, :, t+1) = fl.D_Lh( :, :, t+1) .* pa.D_L;
            elseif t < pa.T
                numer = repmat( Q.u_Hh( :, t+2), 1, pa.num) ./ pa.kappa_h(:, : , t+1).^(1/pa.rho);
                denom = sum(fl.D_H( :, :, t)' .* numer , 1); % 1* pa.num
                fl.D_Hh( :, :, t+1) =  ( numer./ repmat(denom, pa.num , 1) )';
                fl.D_H(:, :, t+1) = fl.D_Hh( :, :, t+1) .* fl.D_H( :, :, t);
                
                numer = repmat( Q.u_Lh( :, t+2), 1, pa.num) ./ pa.kappa_h(:, : , t+1).^(1/pa.rho);
                denom = sum(fl.D_L( :, :, t)' .* numer , 1); % 1* pa.num
                fl.D_Lh( :, :, t+1) =  ( numer./ repmat(denom, pa.num , 1) )';
                fl.D_L(:, :, t+1) = fl.D_Lh( :, :, t+1) .* fl.D_L( :, :, t);
            else 
                numer = repmat( ones(pa.num,1), 1, pa.num) ./ pa.kappa_h(:, : , t+1).^(1/pa.rho);
                denom = sum(fl.D_H( :, :, t)' .* numer , 1); % 1* pa.num
                fl.D_Hh( :, :, t+1) =  ( numer./ repmat(denom, pa.num , 1) )';
                fl.D_H(:, :, t+1) = fl.D_Hh( :, :, t+1) .* fl.D_H( :, :, t);           
                
                numer = repmat( ones(pa.num,1), 1, pa.num) ./ pa.kappa_h(:, : , t+1).^(1/pa.rho);
                denom = sum(fl.D_L( :, :, t)' .* numer , 1); % 1* pa.num
                fl.D_Lh( :, :, t+1) =  ( numer./ repmat(denom, pa.num , 1) )';
                fl.D_L(:, :, t+1) = fl.D_Lh( :, :, t+1) .* fl.D_L( :, :, t);      
                    
            end

        end
        
        %% 4 population H and L
        Q.L = NaN( pa.num, pa.T+1);
        Q.H = NaN( pa.num, pa.T+1);
        for  t = 1: pa.T+1
            if t == 1
                Q.L(:, t) = (fl.D_L(:, :, t) )' * pa.L;
                Q.H(:, t) = (fl.D_H(:, :, t) )' * pa.H;
            else
                Q.L(:, t) = (fl.D_L(: ,: , t) )' * Q.L(:, t-1);
                Q.H(:, t) = (fl.D_H(: ,: , t) )' * Q.H(:, t-1);
            end
        end
%         H_lag = [ pa.H Q.H(:, 1:pa.T)] ; %[H0 H(1~T)]
%         Q.H_h = Q.H ./ H_lag ;
%         L_lag = [ pa.L Q.L(:, 1:pa.T)] ; %[L0 L(1~T)]
%         Q.L_h = Q.L ./ L_lag ;
        
%% 5 solve wage, trade flow, price, rental rate, capital labor ratio
        % solve w_H, w_L, r (absolute level, t=0) , given S0, l0
        p= ini_price(p, pa, iter) ;
        if (sum(p.w_H0<0) || sum(p.w_L0<0) || sum(p.r0<0) ) 
            disp("Fail to solve the initial factor price (t=0) \n");
            pause;
        end
        
        % 5 (ab)  wage, trade flow
        p.uc_h1 = NaN(pa.num, pa.T+1);  % unit cost ^ hat
        p.uc_h2 = NaN(pa.num, pa.T+1);  % unit cost ^ hat
        p.uc_h3 = NaN(pa.num, pa.T+1);  % unit cost ^ hat
        p.w_Hh = ones(pa.num,pa.T+1) ;  % guess the w_Hh
        p.w_Lh = ones(pa.num,pa.T+1) ; % guess the w_Lh
        p.r_h = ones(pa.num,pa.T+1)  ; % guess the r_h
        p.w_H =NaN(pa.num,pa.T+1) ;
        p.w_L =NaN(pa.num,pa.T+1) ;
        p.r =NaN(pa.num,pa.T+1) ;
        p.p_h1 = NaN(pa.num,pa.T+1)  ;
        p.p_h2 = NaN(pa.num,pa.T+1)  ;
        p.p_h3 = NaN(pa.num,pa.T+1)  ;
        fl.S1 = NaN(pa.num, pa.num, pa.T+1);
        fl.S1_h = NaN(pa.num, pa.num, pa.T+1);
        fl.S2 = NaN(pa.num, pa.num, pa.T+1);
        fl.S2_h = NaN(pa.num, pa.num, pa.T+1);
        fl.S3 = NaN(pa.num, pa.num, pa.T+1);
        fl.S3_h = NaN(pa.num, pa.num, pa.T+1);
        
        for t = 1 : pa.T + 1
        % 5 solve temporary equilibrium
            [p, Q, fl] = temp_e(p, Q, fl, t , pa);
            
        end
        
        
        %% 6 solve backwards for u_Hh u_Lh
        
        newu_Hh = [NaN( pa.num, pa.T), ones(pa.num, 1)]; % updated u hat
        newu_Lh = [NaN( pa.num, pa.T), ones(pa.num, 1)] ; % updated u hat
        
        for t = linspace(pa.T , 1,pa.T) 
           
            if t==1
                u_eleH = pa.D_H' .* repmat(newu_Hh(:,t+1), 1, pa.num ) ./ ( pa.kappa_h(:,:,t).^(1/pa.rho) );
                u_eleL = pa.D_L' .* repmat(newu_Lh(:,t+1), 1, pa.num ) ./ ( pa.kappa_h(:,:,t).^(1/pa.rho) );
            else
                u_eleH = fl.D_H(: ,:, t-1)' .* repmat(newu_Hh(:,t+1), 1, pa.num ) ./ ( pa.kappa_h(:,:,t).^(1/pa.rho) );
                u_eleL = fl.D_L(: , :, t-1)' .* repmat(newu_Lh(:,t+1), 1, pa.num ) ./ ( pa.kappa_h(:,:,t).^(1/pa.rho) );
            end
            p_h = p.p_h1(:, t).^pa.gamma(1) .* p.p_h2(:, t).^pa.gamma(2) ;
            newu_Hh(:, t) = ( pa.b_h(:, t) .* p.w_Hh(: , t) ./ p_h ).^(pa.beta/pa.rho) ...
                    .* (sum(u_eleH, 1 )').^pa.beta ;
            newu_Lh(:, t) = ( pa.b_h(:, t) .* p.w_Lh(: , t) ./ p_h ).^(pa.beta/pa.rho) ...
                    .* (sum(u_eleL , 1 )').^pa.beta ;
        end
        
        %% 7 solve backwards for sigma
        newsigma = (1-pa.beta) * ones( pa.num, pa.T+1 );  % updated sigma
        for t = linspace(pa.T , 1,pa.T)
            newsigma(:, t) = newsigma(:, t+1)./ (newsigma(:, t+1) + pa.beta.^pa.psi .* p.R(:, t+1).^(pa.psi-1)  );     
        end
        
        vfactor = -0.05;
        zw1 = Q.u_Hh - newu_Hh ;
        zw2 =  Q.u_Lh - newu_Lh;
        zw3 = Q.sigma - newsigma;
        adj1 = Q.u_Hh .* (1 + vfactor*zw1./Q.u_Hh );
        adj2 = Q.u_Lh .* (1 + vfactor*zw2./Q.u_Lh );
        adj3 = Q.sigma .* (1 + vfactor*zw3 ./ Q.sigma);
        dif1 =  max((Q.u_Hh - adj1).^2);
        dif2 =  max((Q.u_Lh - adj2).^2);
        dif3 =  max((Q.sigma - adj3).^2);
        dif = max([ dif1 dif2 dif3 ]  );
        
        Q.u_Hh = adj1;
        Q.u_Lh = adj2;
        Q.sigma = adj3;
%         difu_H = max( abs(newu_Hh - Q.u_Hh)./Q.u_Hh   ) ;  %
%         difu_L = max( abs(newu_Lh - Q.u_Lh)./Q.u_Lh  ) ;  %
%         difs = max( abs(newsigma - Q.sigma)./Q.sigma ); % 
%         dif = max([difu_H difu_L difs]) ;
% 
%         smooth = .9 * rand + .1;
%         
%         Q.u_Hh = smooth * newu_Hh + (1-smooth) * Q.u_Hh;
%         Q.u_Lh = smooth * newu_Lh + (1-smooth) * Q.u_Lh;
%         Q.sigma = smooth * newsigma + (1-smooth) * Q.sigma;

        % ensure nonnegative value
        if sum(Q.u_Hh<0, 'all') ||sum(Q.u_Lh<0, 'all') || sum(Q.sigma<0,'all')
            flag = 0;
        end
        
    end
    
    
end

