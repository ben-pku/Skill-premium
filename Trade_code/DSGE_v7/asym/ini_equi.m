function [p, Q] = ini_equi(p, Q, pa, iter0)
%INI_EQUI solve the initial equilibrium, t=0
% input
% S0 -- country *country
% L0, H0, k0 -- country * 1
% sigma -- country * 1 consumption rate
% output
% w_H0, w_L0, r0 -- the initial factor prices: country * 1
% k -- t=1 capital stock, country * 1
% E0 -- expenditure t=0 country * 1
% I0 -- investment t=0 country * 1

% guess the three prices first ( if iter0 >1, then apply last solution as
% the guessing price
if iter0==1
    p.w_H0 = 1.4 * ones( pa.num, 1) ;
    p.w_H0(1) = NaN;
    p.w_L0 =  ones( pa.num, 1) ;
    p.r0 = ones( pa.num, 1) ;
    p.r0(1) = NaN;
end

% 3a guess and solve E, I
maxit = 1e4;
dif = 10;
tol = 1e-8;
for iter = 1: maxit
    if dif < tol
        break
    end


    % unit cost
    uc1 = p.w_L0; % i \neq 2
    uc1(2) = NaN;
    % CD constant
    B1 = 1./((pa.mu_K(2:4) .^pa.mu_K(2:4)) .*(pa.mu_L(2:4).^pa.mu_L(2:4)) .*(pa.mu_H(2:4).^pa.mu_H(2:4)) );
    B = [1, B1];
    uc2 = B(2) * p.r0.^pa.mu_K(2) .* p.w_L0.^pa.mu_L(2) .* p.w_H0.^pa.mu_H(2) ;
    uc3 = B(3) * p.r0.^pa.mu_K(3) .* p.w_L0.^pa.mu_L(3) .* p.w_H0.^pa.mu_H(3) ;
    uc4 = B(4) * p.r0.^pa.mu_K(4) .* p.w_L0.^pa.mu_L(4) .* p.w_H0.^pa.mu_H(4) ;
   
    % prices
    p.p1_0 = uc1 ./ pa.A;
    p.p1_0(2) = uc1(1) / pa.A(1);
    % gamma manu, LS, HS
    G = (gamma(1+ (1-pa.eta)./pa.theta)   ).^(1./(1-pa.eta)) ;
    % manu
    ele = repmat(pa.Te2(2: pa.num)', pa.num-1, 1) .* (repmat(uc2(2: pa.num)', pa.num-1, 1) .* pa.d0(2:pa.num,2:pa.num,2) ).^(-pa.theta(1)); % except rural
    sumele = G(2) * (sum(ele, 2)).^ (-1/pa.theta(2));
    p.p2_0 = [  sumele(1); 
                    sumele];
    % L-service
    ele = repmat(pa.Te3(2: pa.num)', pa.num-1, 1) .* (repmat(uc3(2: pa.num)', pa.num-1, 1) .* pa.d0(2:pa.num,2:pa.num,3) ).^(-pa.theta(2)); % except rural
    sumele = G(3) * (sum(ele, 2)).^ (-1/pa.theta(3));
    p.p3_0 = [ sumele(1);
                    sumele];
    % H-service
    ele = repmat(pa.Te4(2: pa.num)', pa.num-1, 1) .* (repmat(uc4(2: pa.num)', pa.num-1, 1) .* pa.d0(2:pa.num,2:pa.num,4) ).^(-pa.theta(3)); % except rural
    sumele = G(4) * (sum(ele, 2)).^ (-1/pa.theta(4));
    p.p4_0 = [ sumele(1);
                    sumele];

    p.R0 = p.r0./ p.p2_0  +1-pa.delta;
    Q.k(:, 1) = (1-Q.sigma0) .* p.R0 .* pa.k0;
    Q.E0 = Q.sigma0 .* p.R0.* pa.k0 .* p.p2_0;
    Q.I0 = p.p2_0.*(Q.k(:, 1)-(1-pa.delta)*pa.k0);
    
    % b expenditure share
    Q.oL0 = share(p.p1_0, p.p2_0, p.p3_0, p.p4_0, p.w_L0, pa); % low worker
    Q.oH0 = share(p.p1_0, p.p2_0, p.p3_0, p.p4_0, p.w_H0, pa); % high worker
    Q.oK0 = share(p.p1_0, p.p2_0, p.p3_0, p.p4_0, Q.E0, pa); % landlord

    % c update factor prices
    % expenditures in each sector
    X1 = Q.oL0(:, 1) .* p.w_L0 .* pa.L + Q.oH0(:, 1) .* p.w_H0 .* pa.H + Q.oK0(:, 1) .* Q.E0;
    X1(1) = Q.oL0(1, 1) * p.w_L0(1) * pa.L(1);
    X2 = Q.oL0(:, 2) .* p.w_L0 .* pa.L + Q.oH0(:, 2) .* p.w_H0 .* pa.H + Q.oK0(:, 2) .* Q.E0 + Q.I0;
    X2(1) = Q.oL0(1, 2) * p.w_L0(1) * pa.L(1);
    X3 = Q.oL0(:, 3) .* p.w_L0 .* pa.L + Q.oH0(:, 3) .* p.w_H0 .* pa.H + Q.oK0(:, 3) .* Q.E0;
    X3(1) = Q.oL0(1, 3) * p.w_L0(1) * pa.L(1);
    X4 = Q.oL0(:, 4) .* p.w_L0 .* pa.L + Q.oH0(:, 4) .* p.w_H0 .* pa.H + Q.oK0(:, 4) .* Q.E0;
    X4(1) = Q.oL0(1, 4) * p.w_L0(1) * pa.L(1);

    % calculate  w_L w_H r
    % w_H
    pre = ( pa.mu_H(1) * ( sum(pa.S2(:, 2:pa.num)' .* repmat( X2', pa.num-1,1 ) ,2 )  )  ... manu
        + pa.mu_H(2) * ( sum(pa.S3(:, 2:pa.num)' .* repmat( X3', pa.num-1,1 ) ,2 ) ) ... l_S
        + pa.mu_H(3) * ( sum(pa.S4(:, 2:pa.num)' .* repmat( X4', pa.num-1,1 ) ,2 ) )) ... h_S
        ./ pa.H(2: pa.num) ; % H
    nw_H0 = [ NaN;
                        pre  ];
    % w_L
    pre = ( pa.mu_L(1) * ( sum(pa.S2(:, 2:pa.num)' .* repmat( X2', pa.num-1,1 ) ,2 )  ) ...
           + pa.mu_L(2) *  ( sum(pa.S3(:, 2:pa.num)' .* repmat( X3', pa.num-1,1 ) ,2 ) ) ...
           + pa.mu_L(3) *  ( sum(pa.S4(:, 2:pa.num)' .* repmat( X4', pa.num-1,1 ) ,2 ) ) ...
                   +[ 0; X1(3: pa.num)] ) ...
                ./ pa.L(2: pa.num) ; 
    nw_L0 =  [  (X1(1) + X1(2))./pa.L(1) ;
                        pre]; % i \neq 1 
    
    % r
    pre = ( pa.mu_K(1) * ( sum( pa.S2(:, 2:pa.num)' .* repmat(X2' , pa.num-1, 1) ,2 ) )  ... manu
        + pa.mu_K(2) * ( sum( pa.S3(: , 2:pa.num)' .* repmat(X3' , pa.num-1, 1) ,2) ) ... l_S
        + pa.mu_K(3) * ( sum( pa.S4(: , 2:pa.num)' .* repmat(X4' , pa.num-1, 1) ,2) ) ) ... h_S
        ./ pa.k0(2: pa.num) ; % K
    nr0 = [ NaN;
                 pre];

        % numeraire
    numer = nw_L0(2);
    nw_H0 = nw_H0 /numer;
    nw_L0 = nw_L0/numer;
    nr0 = nr0 /numer;
    % diff
    dif_H = max((p.w_H0- nw_H0).^2 ); 
    dif_L = max((p.w_L0- nw_L0).^2 );
    dif_r = max( (p.r0 - nr0).^2);

    dif = sum([dif_H, dif_L, dif_r]);

    % update the prices
    smooth = .1 * rand;
    p.w_H0 = (1-smooth) * nw_H0 + smooth * p.w_H0;
    p.w_L0 = (1-smooth) * nw_L0 + smooth * p.w_L0 ;
    p.r0 = (1-smooth) * nr0 + smooth * p.r0;
end




end

