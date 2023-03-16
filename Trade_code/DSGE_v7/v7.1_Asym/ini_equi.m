function [p, Q] = ini_equi(p, Q, pa, iter0)
%INI_EQUI solve the initial equilibrium, t=0 -- asymmetric setting
% input
% S0 -- country *country
% L0, H0, k0 -- country * 1
% sigma -- country * 1 consumption rate
% output
% w_H0, w_L0, r0 -- the initial factor prices: country * 1
% k -- t=1 capital stock, country * 1
% E0 -- expenditure t=0 country * 1
% I0 -- investment t=0 country * 1

% 4a guess the three prices first ( if iter0 >1, then apply last solution as
% the guessing price
if iter0==1
    p.w_H0 = 1.4 * ones( pa.num, 1) ;
    p.w_L0 =  ones( pa.num+1, 1) ;
    p.r0 = ones( pa.num, 1) ;
end

% CD constant
B1 = 1./((pa.mu_K(2:pa.sec) .^pa.mu_K(2:pa.sec)) .*(pa.mu_L(2:pa.sec).^pa.mu_L(2:pa.sec)) .*(pa.mu_H(2:pa.sec).^pa.mu_H(2:pa.sec)) );
B = [1, B1];

maxit = 1e3;
dif = 10;
tol = 1e-7;
for iter = 1: maxit
    if dif < tol
        break;
    end

    % unit cost

    uc1 = [p.w_L0(1); p.w_L0( 3:pa.num+1) ];  % num * 1
    uc2 = B(2) *  p.r0.^pa.mu_K(2) .* p.w_L0(2: pa.num+1).^pa.mu_L(2) .* p.w_H0.^pa.mu_H(2) ; % num * 1
    uc3 = B(3) *  p.r0.^pa.mu_K(3) .* p.w_L0(2: pa.num+1).^pa.mu_L(3) .* p.w_H0.^pa.mu_H(3) ; % num * 1
    uc4 = B(4) *  p.r0.^pa.mu_K(4) .* p.w_L0(2: pa.num+1).^pa.mu_L(4) .* p.w_H0.^pa.mu_H(4) ; % num * 1
   
    % price
    % gamma: agri, manu, LS, HS
    G = (gamma(1+ (1-pa.eta)./pa.theta)   ).^(1./(1-pa.eta)) ; % sec (A M L H)
    % agri
    p.p1_0 = uc1 ./ pa.A ; % num* 1

    % manu
    ele = repmat(pa.Te2', pa.num, 1) .* (repmat(uc2', pa.num, 1) .* pa.d0(:,:,2) ).^(-pa.theta(2)); 
    p.p2_0 = G(2) * (sum(ele, 2)).^ (-1/pa.theta(2));% num* 1

   % low-skill
    ele = repmat(pa.Te3', pa.num, 1) .* (repmat(uc3', pa.num, 1) .* pa.d0(:,:,3) ).^(-pa.theta(3)); 
    p.p3_0 = G(3) * (sum(ele, 2)).^ (-1/pa.theta(3));% num* 1

   % high-skill
    ele = repmat(pa.Te4', pa.num, 1) .* (repmat(uc4', pa.num, 1) .* pa.d0(:,:,4) ).^(-pa.theta(4)); 
    p.p4_0 = G(4) * (sum(ele, 2)).^ (-1/pa.theta(4));% num* 1
         
    % E, I t=0
    p.R0 = p.r0./ p.p2_0  +1-pa.delta;
    Q.k(:, 1) = (1-Q.sigma0) .* p.R0 .* pa.k0;
    Q.E0 = Q.sigma0 .* p.R0.* pa.k0 .* p.p2_0;
    Q.I0 = p.p2_0.*(Q.k(:, 1)-(1-pa.delta)*pa.k0);

    % 4b expenditure share
    Q.oL0 = share( [p.p1_0(1) ; p.p1_0], [p.p2_0(1); p.p2_0],  [p.p3_0(1); p.p3_0],  [p.p4_0(1); p.p4_0],p.w_L0, pa, pa.num+1); % low worker num+1*1
    Q.oH0 = share(p.p1_0, p.p2_0, p.p3_0, p.p4_0, p.w_H0, pa, pa.num); % high worker num*1
    Q.oK0 = share(p.p1_0, p.p2_0, p.p3_0, p.p4_0 , Q.E0, pa, pa.num); % landlord num*1

    % 4c update factor prices
    % expenditures in each sector
    % agri
    low1 = Q.oL0(:,1) .* p.w_L0 .* pa.L; % num+1 * 1
    low1 = [low1(1)+low1(2); low1(3: pa.num+1)]; % num*1 
    X1 = low1 + Q.oH0(:, 1) .* p.w_H0 .* pa.H + Q.oK0(:,1) .* Q.E0; % num*1 
    % manu
    low2 = Q.oL0(:, 2)  .* p.w_L0 .* pa.L; % num+1 * 1 
    low2 = [low2(1)+low2(2); low2(3: pa.num+1)];% num*1
    X2 = low2 + Q.oH0(:, 2) .* p.w_H0 .* pa.H + Q.oK0(:, 2) .* Q.E0 + Q.I0; % num*1
    % low-service
    low3 = Q.oL0(:, 3)  .* p.w_L0 .* pa.L; % num+1 * 1 
    low3 = [low3(1)+low3(2); low3(3: pa.num+1)];% num*1
    X3 = low3 + Q.oH0(:, 3) .* p.w_H0 .* pa.H + Q.oK0(:, 3) .* Q.E0 + Q.I0; % num*1
    % high-service
    low4 = Q.oL0(:, 4)  .* p.w_L0 .* pa.L; % num+1 * 1 
    low4 = [low4(1)+low4(2); low4(3: pa.num+1)];% num*1
    X4 = low4 + Q.oH0(:, 4) .* p.w_H0 .* pa.H + Q.oK0(:, 4) .* Q.E0 + Q.I0; % num*1


    % calculate  w_L w_H r
       % w_H
    nw_H0 = (   pa.mu_H(2) *  sum(  pa.S2 .* repmat(X2, 1, pa.num), 1)'   ... manu
        + pa.mu_H(3) *  sum(  pa.S3 .* repmat(X3, 1, pa.num), 1)'  ... l_S
        + pa.mu_H(4) *  sum(  pa.S4 .* repmat(X4, 1, pa.num), 1)' ) ... h_S
        ./ pa.H ; % H  num* 1 
    
    % w_L
    agri_income = [ X1(1) ; 0 ; X1(2: pa.num)]; % num+1*1
    low_income = (  pa.mu_L(2) *  sum(  pa.S2 .* repmat(X2, 1, pa.num), 1)'   ... manu
        + pa.mu_L(3) *  sum(  pa.S3 .* repmat(X3, 1, pa.num), 1)'  ... l_S
        + pa.mu_L(4) *  sum(  pa.S4 .* repmat(X4, 1, pa.num), 1)' )  ; % h_S, num * 1 
    low_income = agri_income + [ 0 ; low_income]; % num+1*1
    nw_L0 = low_income ./ pa.L; % L (num+1) * 1
    
    % r
    nr0 = ( pa.mu_K(2) *  sum(  pa.S2 .* repmat(X2, 1, pa.num), 1)'   ... manu
        + pa.mu_K(3) *  sum(  pa.S3 .* repmat(X3, 1, pa.num), 1)'  ... l_S
        + pa.mu_K(4) *  sum(  pa.S4 .* repmat(X4, 1, pa.num), 1)' ) ... h_S
        ./ pa.k0; % K  num* 1 

    % numeraire
    numer = nw_H0(1);
    nw_H0 = nw_H0 /numer;
    nw_L0 = nw_L0/numer;
    nr0 = nr0 /numer;
     
    % successful codes:
    vfactor = -0.5;
    zw1 = p.w_H0 - nw_H0;
    zw2 = p.w_L0 - nw_L0 ;
    zw3 = p.r0 - nr0  ;
    adj1 = p.w_H0 .*( 1+ vfactor*zw1./  p.w_H0  );
    adj2 = p.w_L0 .*( 1+ vfactor*zw2./  p.w_L0  );
    adj3 = p.r0 .*( 1+ vfactor*zw3./  p.r0  );
    dif1 = p.w_H0 - adj1;
    dif2 = p.w_L0 - adj2;
    dif3 = p.r0 - adj3;
    dif = sum(([dif1; dif2; dif3 ]).^2) ;
    p.w_H0 =adj1; % (1-smooth) * p.w_Hh(:, t) + smooth * new.w_Hh(:, t);
    p.w_L0 =adj2; %(1-smooth) * p.w_Lh(:, t) + smooth * new.w_Lh(:, t);
    p.r0 = adj3; %(1-smooth) * p.r_h(:, t) + smooth * new.r_h(:, t);
end


end

