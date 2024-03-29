function [p, Q, fl] = tran(pa)
%% TRAN solve the transitional path
% By Dynamic Exact hat algebra
% p - price, Q - quantity, fl - flows
% from t=0 to t = T+1

% 1 guess the u_h , sigma
Q.u_h = repmat( linspace(1.8, 1, pa.T+1), pa.num , 1);
Q.sigma = (1-pa.beta)*ones(pa.num, pa.T+1);

% create other variables
p.R = [zeros(pa.num, pa.T)  1/pa.beta * ones(pa.num,1)];
Q.chi =  zeros(pa.num, pa.T+1) ;  % we have to solve chi(t=1)
Q.chi_h = ones(pa.num, pa.T+1);
fl.D = zeros(pa.num, pa.num, pa.T+1);
fl.D_h = zeros(pa.num , pa.num , pa.T+1);


p.p_h = zeros(pa.num, pa.T+1);





flag = 1; % nonnegative value
iter = 0;
dif = 10;

    while (iter <=1e4 && dif >1e-3 && flag)
        iter = iter + 1;

        % 2 Set the rental rates in period t = 1
        p.R(:, 1) = pa.k1./pa.k0 .* ( 1 - Q.sigma(:, 1) );

        % 3 get migration rates
        

        for t = 0: pa.T
            % solve fl.D_h and fl.D (t)
            if t ==0
                numer = repmat( Q.u_h( :, t+2), 1, pa.num) ./ (pa.kappa_h(:, : , t+1).^(1/pa.rho)) ;
                denom = sum(pa.D' .* numer , 1); % 1* pa.num
                fl.D_h( :, :, t+1) =  ( numer./ repmat(denom, pa.num , 1) )';
                fl.D(:, :, t+1) = fl.D_h( :, :, t+1) .* pa.D;
            elseif t < pa.T
                numer = repmat( Q.u_h( :, t+2), 1, pa.num) ./ pa.kappa_h(:, : , t+1).^(1/pa.rho);
                denom = sum(fl.D( :, :, t)' .* numer , 1); % 1* pa.num
                fl.D_h( :, :, t+1) =  ( numer./ repmat(denom, pa.num , 1) )';
                fl.D(:, :, t+1) = fl.D_h( :, :, t+1) .* fl.D( :, :, t);
            else 
                numer = repmat( ones(pa.num,1), 1, pa.num) ./ pa.kappa_h(:, : , t+1).^(1/pa.rho);
                denom = sum(fl.D( :, :, t)' .* numer , 1); % 1* pa.num
                fl.D_h( :, :, t+1) =  ( numer./ repmat(denom, pa.num , 1) )';
                fl.D(:, :, t+1) = fl.D_h( :, :, t+1) .* fl.D( :, :, t);                
                    
            end
        end
%         fl.D(: , :, pa.T+1) = fl.D(: , :, pa.T);

        % 4 population
        Q.l = zeros( pa.num, pa.T+1);
        for  t = 0: pa.T
            if t == 0
                Q.l(:, t+1) = (fl.D(:, :, t+1) )' * pa.l;
            else
                Q.l(:, t+1) = (fl.D(: ,: , t+1) )' * Q.l(:, t);
            end
        end
        l_lag = [ pa.l Q.l(:, 1:pa.T)] ; %[l0 l(1~T)]
        Q.l_h = Q.l ./ l_lag ;

        % edit chi chi_h
        Q.chi(:, 1) = pa.k1 ./ Q.l(:, 1);
        Q.chi_h(:, 1) = Q.chi(:, 1) ./ (pa.k0./pa.l) ;

        % 5 solve wage, trade flow, price, rental rate, capital labor ratio
        % solve w (absolute level, t=0) , given S0, l0
        p.w0 =  fsolve(@(w)goodmkt(w, pa.S, pa.l, pa), ones(pa.num, 1)   ) ;
        if sum(p.w0<0)
            disp("Fail to solve the initial wage (t=0) \n");
            pause;
        end

        % 5 a  wage, trade flow
        p.w_h = ones(pa.num, pa.T+1); 
        fl.S = zeros(pa.num, pa.num, pa.T+1);
        fl.S_h = ones(pa.num, pa.num, pa.T+1);
        for t = 0 : pa.T  % we know t and want to solve t+1

            [p, Q, fl] = trade(p, Q, fl, t, pa);

            % 5 b price indices
            if t ==0
                p_ele = pa.S .* pa.tau_h( :, :, t+1).^(-pa.theta) .* ...
                   repmat( ( ( p.w_h(:, t+1) ./ pa.z_h( :,t+1 ) .* (Q.chi_h( : , t+1)).^(pa.mu-1) ).^(-pa.theta) )' , pa.num, 1)  ;
            else
                p_ele = fl.S(: , :, t) .* pa.tau_h( :, :, t+1).^(-pa.theta) .* ...
                   repmat( ( ( p.w_h(:, t+1) ./ pa.z_h( :,t+1 ) .* (Q.chi_h( : , t+1)).^(pa.mu-1) ).^(-pa.theta) )' , pa.num, 1)  ;
            end
            p.p_h(: , t+1) = (  sum( p_ele ,2)  ) .^(-1/pa.theta) ;

            % 5 c new rental rates R
            if t == 0
            % solve initial R 
                p.r0 = (1-pa.mu)/pa.mu * p.w0 .* pa.l ./ pa.k0;
                CDcons = ( (1-pa.mu)/pa.mu )^(1-pa.mu);
                p_ele = ( CDcons * pa.tau .* repmat(  (p.w0 .* ( pa.k0./pa.l ).^(pa.mu-1)  ./pa.z )' ,pa.num, 1 ) ).^(-pa.theta) ;
                p.p0 = ( sum( p_ele , 2)   ).^(-1/pa.theta) ;
                p.R0 = 1 - pa.delta + p.r0 ./ p.p0 ;
                p.R(:, t+1) = 1- pa.delta + p.w_h(: , t+1).*(p.R0-1+ pa.delta)./( p.p_h(:,t+1) .* Q.chi_h(:, t+1) );
            else
                p.R(:, t+1) = 1- pa.delta + p.w_h(: , t+1).*(p.R(:,t)-1+ pa.delta)./( p.p_h(:,t+1) .* Q.chi_h(:, t+1) );
            end
            % 5 d update chi, chi_h t+2
            if t ~= pa.T
                Q.chi(: , t+2) = (1 - Q.sigma(: , t+1)) .* p.R(: , t+1) .* Q.chi(: , t+1) ./ Q.l_h( :, t+2);
                Q.chi_h( : , t+2) = Q.chi(: , t+2)./Q.chi(: , t+1);
            end
        end


        % 6 solve backwards for u_h 
        newu_h = ones( pa.num, pa.T+1); % updated u hat
        for t = linspace( pa.T, 0, pa.T+1)
            if t == pa.T
                newu_h(:, t+1)  = ones(pa.num, 1);
            elseif t>0
                u_ele = (fl.D(:, :, t))' ./ (pa.kappa_h(:,:,t+1).^(1/pa.rho) ) .* repmat( newu_h(:, t+2) , 1, pa.num);
                newu_h(:, t+1) = ( pa.b_h(:,t+1).* p.w_h(:,t+1) ./p.p_h(:,t+1) ).^(pa.beta/pa.rho) .* ...
                    ( (sum(u_ele, 1))' ).^(pa.beta) ;
            else
                u_ele = (pa.D)' ./ (pa.kappa_h(:,:,t+1).^(1/pa.rho) ) .* repmat( newu_h(:, t+2) , 1, pa.num);
                newu_h(:, t+1) = ( pa.b_h(:,t+1).* p.w_h(:,t+1) ./p.p_h(:,t+1) ).^(pa.beta/pa.rho) .* ...
                    ( (sum(u_ele, 1))' ).^(pa.beta) ;
            end
                
        end

        % 7 solve backwards for sigma
        newsigma = (1-pa.beta) * ones( pa.num, pa.T+1 );  % updated sigma
        for t = linspace( pa.T, 0, pa.T+1)
            if t ~= pa.T
                newsigma(:, t+1) = newsigma(:, t+2) ./( newsigma(:, t+2) + pa.beta^pa.psi * p.R(: , t+2).^(pa.psi-1)) ;
            end
        end

        dif1 = abs((newu_h - Q.u_h) ./Q.u_h);  %
        dif2 = abs( (newsigma - Q.sigma) ./ Q.sigma); % 
        dif = max( max([dif1 dif2]) );

        smooth = .9 * rand + .1;
        
        Q.u_h = smooth * newu_h + (1-smooth) * Q.u_h;
        Q.sigma = smooth * newsigma + (1-smooth) * Q.sigma;

        % ensure nonnegative value
        if sum(Q.u_h<0, 'all') || sum(Q.sigma<0,'all')
            flag = 0;
        end

        

    end
    
end

