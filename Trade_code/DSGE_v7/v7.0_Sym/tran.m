function [p, Q, fl] = tran(  pa )
%% TRAN  solve the transitional path

% 1 guess the u_h, sigma
Q.u_Hh = repmat( logspace(log10(2), 0, pa.T+1)   , pa.num, 1);
Q.u_Lh = repmat( logspace(log10(1), 0, pa.T+1)   , pa.num, 1);
Q.sigma = (1 - pa.beta ) * ones(pa.num, pa.T+1); % t= 1 ~ T+1
Q.sigma0 = (1 - pa.beta) * ones(pa.num, 1); % t = 0

p.R = [NaN(pa.num, pa.T)  1/pa.beta * ones(pa.num,1)];
Q.k = NaN(pa.num, pa.T+1) ;
fl.D_H = NaN(pa.num, pa.num, pa.T+1) ;
fl.D_Hh = NaN(pa.num, pa.num, pa.T+1) ;
fl.D_L = NaN(pa.num, pa.num, pa.T+1);
fl.D_Lh = NaN(pa.num , pa.num , pa.T+1);
p.r0 = NaN(pa.num, 1);

maxit = 1e4;
dif = 10;
tol = 1e-7;
for iter = 1: maxit
    if dif < tol
        break
    end

    % 3 solve the migration rate, population
    for t = 1 : pa.T+1
        if t == 1
            numer = repmat(Q.u_Hh(:, t+1)', pa.num, 1 ) ./ pa.kappa_h(:,:, t)'.^(1/pa.rho);
            denom = sum(pa.D_H .* numer ,2 ); % I * 1
            fl.D_Hh( :, :, t ) = numer ./ repmat(denom, 1, pa.num);
            fl.D_H( :, :, t ) = fl.D_Hh( :, :, t ) .* pa.D_H;
        elseif t <= pa.T
            numer = repmat(Q.u_Hh(:, t+1)', pa.num, 1 ) ./ pa.kappa_h(:,:, t)'.^(1/pa.rho);
            denom = sum(fl.D_H(:, :, t-1) .* numer ,2 ); % I * 1
            fl.D_Hh( :, :, t ) = numer ./ repmat(denom, 1, pa.num);
            fl.D_H( :, :, t) = fl.D_Hh( :, :, t ) .* fl.D_H( :, :, t-1);
        else
            numer = repmat(ones(pa.num,1)', pa.num, 1 ) ./ pa.kappa_h(:,:, t)'.^(1/pa.rho);
            denom = sum(fl.D_H(:, :, t-1) .* numer ,2 ); % I * 1
            fl.D_Hh( :, :, t ) = numer ./ repmat(denom, 1, pa.num);
            fl.D_H( :, :, t) = fl.D_Hh( :, :, t ) .* fl.D_H( :, :, t-1);
        end
                
       if t == 1
            numer = repmat(Q.u_Lh(:, t+1)', pa.num, 1 ) ./ pa.kappa_h(:,:, t)'.^(1/pa.rho);
            denom = sum(pa.D_L .* numer ,2 ); % I * 1
            fl.D_Lh( :, :, t ) = numer ./ repmat(denom, 1, pa.num);
            fl.D_L( :, :, t ) = fl.D_Lh( :, :, t ) .* pa.D_L;
        elseif t<= pa.T
            numer = repmat(Q.u_Lh(:, t+1)', pa.num, 1 ) ./ pa.kappa_h(:,:, t)'.^(1/pa.rho);
            denom = sum(fl.D_L(:, :, t-1) .* numer ,2 ); % I * 1
            fl.D_Lh( :, :, t ) = numer ./ repmat(denom, 1, pa.num);
            fl.D_L( :, :, t) = fl.D_Lh( :, :, t ) .* fl.D_L( :, :, t-1);
        else
            numer = repmat(ones(pa.num,1)', pa.num, 1 ) ./ pa.kappa_h(:,:, t)'.^(1/pa.rho);
            denom = sum(fl.D_L(:, :, t-1) .* numer ,2 ); % I * 1
            fl.D_Lh( :, :, t ) = numer ./ repmat(denom, 1, pa.num);
            fl.D_L( :, :, t) = fl.D_Lh( :, :, t ) .* fl.D_L( :, :, t-1);
        end
    end

    % 4 population
    Q.L = NaN( pa.num, pa.T+1);
    Q.H = NaN( pa.num, pa.T+1);
    for t = 1: pa.T+1
        if t == 1
            Q.L(:, t) = fl.D_L(:,:, t)' * pa.L;
            Q.H(:, t) = fl.D_H(:,:, t)' * pa.H;        
        else
            Q.L(:, t) = fl.D_L(:,:, t)' * Q.L(:, t-1);
            Q.H(:, t) = fl.D_H(:,:, t)' * Q.H(:, t-1);
        end

    end

    % 5 initial equi & temp equi

    % w_H, w_L, r, t=0
    [p, Q] = ini_equi(p, Q, pa, iter) ;
    if (sum(p.w_H0<0) || sum(p.w_L0<0) || sum(p.r0<0) ) 
        disp("Fail to solve the initial factor price (t=0) \n");
        pause;
    end

    % 6 temporary equilibrium (t=1,...,T+1)
    p.uc_h1 = NaN(pa.num, pa.T+1); % agri
    p.uc_h2 = NaN(pa.num, pa.T+1); % manu
    p.uc_h3 = NaN(pa.num, pa.T+1);  % l_S
    p.uc_h4 = NaN(pa.num, pa.T+1);  % h_S
    p.w_Hh = ones(pa.num,pa.T+1) ;  % guess the w_Hh
    p.w_Lh = ones(pa.num,pa.T+1) ; % guess the w_Lh
    p.r_h = ones(pa.num,pa.T+1)  ; % guess the r_h
    p.w_H = NaN(pa.num,pa.T+1) ;
    p.w_L = NaN(pa.num,pa.T+1) ;
    p.r = NaN(pa.num,pa.T+1) ;
    p.R = NaN(pa.num, pa.T+1); % gross return of capital
    p.p_h1 = NaN(pa.num,pa.T+1)  ; % agri
    p.p_h2 = NaN(pa.num,pa.T+1)  ; % manu
    p.p_h3 = NaN(pa.num,pa.T+1)  ; % l_S
    p.p_h4 = NaN(pa.num,pa.T+1)  ; % h_S
    p.p1 = NaN(pa.num,pa.T+1)  ; % agri
    p.p2 = NaN(pa.num,pa.T+1)  ; % manu
    p.p3 = NaN(pa.num,pa.T+1)  ; % l_S
    p.p4 = NaN(pa.num,pa.T+1)  ; % h_S
    fl.S1 = NaN(pa.num, pa.num, pa.T+1);    
    fl.S1_h = NaN(pa.num, pa.num, pa.T+1);
    fl.S2 = NaN(pa.num, pa.num, pa.T+1);
    fl.S2_h = NaN(pa.num, pa.num, pa.T+1);
    fl.S3 = NaN(pa.num, pa.num, pa.T+1);
    fl.S3_h = NaN(pa.num, pa.num, pa.T+1);
    fl.S4 = NaN(pa.num, pa.num, pa.T+1);
    fl.S4_h = NaN(pa.num, pa.num, pa.T+1);

%     Q.E = NaN(pa.num, pa.T+1); % expenditure
%     Q.I = NaN(pa.num, pa.T+1); % investment expenditure
    Q.oL = NaN(pa.num, pa.sec, pa.T+1); % expenditure share of lowskill
    Q.oH = NaN(pa.num, pa.sec, pa.T+1); % high worker
    Q.oK = NaN(pa.num, pa.sec, pa.T+1); % landlord

    for t = 1: pa.T+1
        [p, Q, fl] = temp_e(p, Q, fl, t, pa);
    end

%     % 6 update u_Hh, u_Lh
%     newu_Hh = [NaN( pa.num, pa.T), ones(pa.num, 1)]; % updated u hat
%     newu_Lh = [NaN( pa.num, pa.T), ones(pa.num, 1)] ; % updated u hat
%     for t = pa.T : -1: 1
%           if t==1
%                 u_eleH = pa.D_H' .* repmat(newu_Hh(:,t+1), 1, pa.num ) ./ ( pa.kappa_h(:,:,t).^(1/pa.rho) );
%                 u_eleL = pa.D_L' .* repmat(newu_Lh(:,t+1), 1, pa.num ) ./ ( pa.kappa_h(:,:,t).^(1/pa.rho) );
%             else
%                 u_eleH = fl.D_H(: ,:, t-1)' .* repmat(newu_Hh(:,t+1), 1, pa.num ) ./ ( pa.kappa_h(:,:,t).^(1/pa.rho) );
%                 u_eleL = fl.D_L(: , :, t-1)' .* repmat(newu_Lh(:,t+1), 1, pa.num ) ./ ( pa.kappa_h(:,:,t).^(1/pa.rho) );
%             end
%             p_h = p.p_h1(:, t).^pa.gamma(1) .* p.p_h2(:, t).^pa.gamma(2) ;
%             newu_Hh(:, t) = ( pa.b_h(:, t) .* p.w_Hh(: , t) ./ p_h ).^(pa.beta/pa.rho) ...
%                     .* (sum(u_eleH, 1 )').^pa.beta ;
%             newu_Lh(:, t) = ( pa.b_h(:, t) .* p.w_Lh(: , t) ./ p_h ).^(pa.beta/pa.rho) ...
%                     .* (sum(u_eleL , 1 )').^pa.beta ;
% 
%     end

% 6 update u_Hh, u_Lh
    newu_Hh = [NaN( pa.num, pa.T), ones(pa.num, 1)]; % updated u hat
    newu_Lh = [NaN( pa.num, pa.T), ones(pa.num, 1)] ; % updated u hat
    % solve C_h 
    omega2H_h = NaN(pa.num, pa.T+1);
    omega2L_h = NaN(pa.num, pa.T+1);
    for t = 1: pa.T+1
        if t == 1
            omega2H_h(:, t) = Q.oH(: , 2 , t) ./ Q.oH0(:, 2);
            omega2L_h(:, t) = Q.oL(: , 2 , t) ./ Q.oL0(:, 2);
        else
            omega2H_h(:, t) = Q.oH(: , 2 , t) ./ Q.oH(: , 2 , t-1);
            omega2L_h(:, t) = Q.oL(: , 2 , t) ./ Q.oL(: , 2 , t-1);
        end
    end
    C_Hh = p.w_Hh ./ p.p_h2 .* omega2H_h.^(1/(1-pa.sigma)); % country*t
    C_Lh = p.w_Lh ./ p.p_h2 .* omega2L_h.^(1/(1-pa.sigma)); % country*t
    
    for t = pa.T : -1: 1
        if t ==1 
            eleH = pa.D_H .* repmat(newu_Hh(: , t+1)' , pa.num, 1 ) ./ ( pa.kappa_h( :, :, t)'.^(1/pa.rho));
            eleL  = pa.D_L .* repmat(newu_Lh(: , t+1)', pa.num, 1 ) ./ (pa.kappa_h(:, :, t)'.^(1/pa.rho));
        else
            eleH = fl.D_H(:, :, t-1) .* repmat(newu_Hh(: , t+1)' , pa.num, 1 ) ./ ( pa.kappa_h( :, :, t)'.^(1/pa.rho));
            eleL  = fl.D_L(:, :, t-1) .* repmat(newu_Lh(: , t+1)', pa.num, 1 ) ./ ( pa.kappa_h( :, :, t)'.^(1/pa.rho));
        end
        newu_Hh( :, t) = C_Hh(:, t) .^( pa.beta / (pa.varepsilon_b * pa.rho) ) ...
            .* sum( eleH,2).^pa.beta;
        newu_Lh( :, t) = C_Lh(:, t) .^( pa.beta / (pa.varepsilon_b * pa.rho) ) ...
            .* sum( eleL,2).^pa.beta;
    end

%    % 7 solve backwards for sigma
%     newsigma = (1-pa.beta) * ones( pa.num, pa.T+1 );  % updated sigma
%     for t = pa.T : -1 : 1
%         newsigma(:, t) = newsigma(:, t+1) .* Q.k(:, t+1)./Q.k(:, t) ./ ( pa.beta^pa.psi * p.R(:, t+1).^(pa.psi-1).* p.R(:, t) );
%     end
%     newsigma0 = newsigma(:, 1) .* Q.k(:, 1)./pa.k0 ./ ( pa.beta^pa.psi * p.R(:, 1).^(pa.psi-1).* p.R0 );

 % 7 solve the consumption rate backward
    newsigma = (1-pa.beta)* ones(pa.num, pa.T+1);
    epsilon_bar = NaN(pa.num, pa.T+1);
    epsilon_bar(:, pa.T+1) = sum( Q.oK(:, :, pa.T+1) .* repmat(pa.epsilon, pa.num, 1), 2 );
    for t = pa.T : -1: 1
        epsilon_bar( :, t) = sum( Q.oK(:, :, t) .* repmat(pa.epsilon, pa.num, 1), 2 );
        newsigma(:, t) = 1/pa.beta * epsilon_bar(:, t+1)./epsilon_bar(:, t) .* ...
            Q.k(:, t+1)./ Q.k(:, t) .* p.p_h2(:, t+1) ./ p.R(:, t) .* newsigma(:, t+1);
    end
    % t =0
    epsilon_bar0 = sum( Q.oK0 .* repmat(pa.epsilon, pa.num, 1) ,2 );
    newsigma0 = 1/pa.beta * epsilon_bar(:, 1)./epsilon_bar0 .* ...
            Q.k(:, 1)./ pa.k0 .* p.p_h2(:, 1) ./ p.R0 .* newsigma(:, 1);

    vfactor = -0.05;
    zw1 = Q.u_Hh - newu_Hh ;
    zw2 =  Q.u_Lh - newu_Lh;
    zw3 = Q.sigma - newsigma;
    zw4 = Q.sigma0 - newsigma0;
    adj1 = Q.u_Hh .* (1 + vfactor*zw1./Q.u_Hh );
    adj2 = Q.u_Lh .* (1 + vfactor*zw2./Q.u_Lh );
    adj3 = Q.sigma .* (1 + vfactor*zw3 ./ Q.sigma);
    adj4 = Q.sigma0 .* (1 + vfactor*zw4 ./ Q.sigma0);
    dif1 =  max((Q.u_Hh - adj1).^2);
    dif2 =  max((Q.u_Lh - adj2).^2);
    dif3 =  max((Q.sigma - adj3).^2);
    dif4 = max((Q.sigma0 - adj4).^2);
    dif = max([ dif1 dif2 dif3 dif4]  );
    
    Q.u_Hh = adj1;
    Q.u_Lh = adj2;
    Q.sigma = adj3;
    Q.sigma0 = adj4;


    disp(['iteration ' num2str(iter) ', dif = ' num2str(dif)]);

end

Q.k = Q.k(:, 1: pa.T+1);

end