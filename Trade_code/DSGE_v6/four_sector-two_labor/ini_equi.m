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

% 4a guess the three prices first ( if iter0 >1, then apply last solution as
% the guessing price
if iter0==1
    p.w_H0 = 1.4 * ones( pa.num, 1) ;
    p.w_L0 =  ones( pa.num, 1) ;
    p.r0 = ones( pa.num, 1) ;
end

maxit = 1e4;
dif = 10;
tol = 1e-7;
for iter = 1: maxit
    if dif < tol
        break;
    end

%     % unit cost
%     % CD constant
%     B1 = 1./((pa.mu_K(2:4) .^pa.mu_K(2:4)) .*(pa.mu_L(2:4).^pa.mu_L(2:4)) .*(pa.mu_H(2:4).^pa.mu_H(2:4)) );
%     B = [1, B1];
%     uc1 = B(1) *  p.r0.^pa.mu_K(1) .* p.w_L0.^pa.mu_L(1) .* p.w_H0.^pa.mu_H(1) ;
%     uc2 = B(2) *  p.r0.^pa.mu_K(2) .* p.w_L0.^pa.mu_L(2) .* p.w_H0.^pa.mu_H(2) ;
%     uc3 = B(3) *  p.r0.^pa.mu_K(3) .* p.w_L0.^pa.mu_L(3) .* p.w_H0.^pa.mu_H(3) ;
%     uc4 = B(4) *  p.r0.^pa.mu_K(4) .* p.w_L0.^pa.mu_L(4) .* p.w_H0.^pa.mu_H(4) ;
%    
%     % price
%     % gamma: agri, manu, LS, HS
%     G = (gamma(1+ (1-pa.eta)./pa.theta)   ).^(1./(1-pa.eta)) ;
%     % agri
%     ele = repmat(pa.Te1', pa.num, 1) .* (  repmat(uc1', pa.num, 1) .* pa.d0(:,:,1)  ).^(-pa.theta(1));
%     p.p1_0 = G(1) * (sum(ele, 2)) .^(-1/pa.theta(1));
% 
%     % manu
%     ele = repmat(pa.Te2', pa.num, 1) .* (repmat(uc2', pa.num, 1) .* pa.d0(:,:,2) ).^(-pa.theta(2)); 
%     p.p2_0 = G(2) * (sum(ele, 2)).^ (-1/pa.theta(2));
%      
%     % L-service
%     ele = repmat(pa.Te3', pa.num, 1) .* (repmat(uc3', pa.num, 1) .* pa.d0(:,:,3) ).^(-pa.theta(3)); 
%     p.p3_0  = G(3) * (sum(ele, 2)).^ (-1/pa.theta(3));
%     
%     % H-service
%     ele = repmat(pa.Te4', pa.num, 1) .* (repmat(uc4', pa.num, 1) .* pa.d0(:,:,4) ).^(-pa.theta(4)); 
%     p.p4_0  = G(4) * (sum(ele, 2)).^ (-1/pa.theta(4));
    

    % 4b expenditure share
    Q.oL0 = share( pa); % low worker
    Q.oH0 = share(pa); % high worker
    Q.oK0 = share(pa); % landlord

    % 4c update factor prices
    % expenditures in each sector
    X1 = Q.oL0(:, 1) .* p.w_L0 .* pa.L + Q.oH0(:, 1)  .* p.w_H0 .* pa.H + Q.oK0(:, 1)  .* p.r0.*pa.k0;
    
    X2 = Q.oL0(:, 2)  .* p.w_L0 .* pa.L + Q.oH0(:, 2) .* p.w_H0 .* pa.H + Q.oK0(:, 2) .* p.r0.*pa.k0;
    
    X3 = Q.oL0(:, 3) .* p.w_L0 .* pa.L + Q.oH0(:, 3) .* p.w_H0 .* pa.H + Q.oK0(:, 3) .* p.r0.*pa.k0;
   
    X4 = Q.oL0(:, 4) .* p.w_L0 .* pa.L + Q.oH0(:, 4)  .* p.w_H0 .* pa.H + Q.oK0(:, 4)  .* p.r0.*pa.k0;

    % calculate  w_L w_H r
    % w_H
    nw_H0 = ( pa.mu_H(1) *  sum(  pa.S1 .* repmat(X1, 1, pa.num), 1)'  ... agri 
        + pa.mu_H(2) *  sum(  pa.S2 .* repmat(X2, 1, pa.num), 1)'   ... manu
        + pa.mu_H(3) *  sum(  pa.S3 .* repmat(X3, 1, pa.num), 1)'  ... l_S
        + pa.mu_H(4) *  sum(  pa.S4 .* repmat(X4, 1, pa.num), 1)' ) ... h_S
        ./ pa.H ; % H
    
    % w_L
    nw_L0 = ( pa.mu_L(1) *  sum(  pa.S1 .* repmat(X1, 1, pa.num), 1)'  ... agri 
        + pa.mu_L(2) *  sum(  pa.S2 .* repmat(X2, 1, pa.num), 1)'   ... manu
        + pa.mu_L(3) *  sum(  pa.S3 .* repmat(X3, 1, pa.num), 1)'  ... l_S
        + pa.mu_L(4) *  sum(  pa.S4 .* repmat(X4, 1, pa.num), 1)' ) ... h_S
        ./ pa.L; % L
    
    % r
    nr0 = (  pa.mu_K(1) *  sum(  pa.S1 .* repmat(X1, 1, pa.num), 1)'  ... agri 
        + pa.mu_K(2) *  sum(  pa.S2 .* repmat(X2, 1, pa.num), 1)'   ... manu
        + pa.mu_K(3) *  sum(  pa.S3 .* repmat(X3, 1, pa.num), 1)'  ... l_S
        + pa.mu_K(4) *  sum(  pa.S4 .* repmat(X4, 1, pa.num), 1)' ) ... h_S
        ./ pa.k0; % K

    % numeraire
    numer = nw_L0(1);
    nw_H0 = nw_H0 /numer;
    nw_L0 = nw_L0/numer;
    nr0 = nr0 /numer;
     

    dif_H = max(abs(p.w_H0- nw_H0) ); 
    dif_L = max(abs(p.w_L0- nw_L0) );
    dif_r = max( abs(p.r0 - nr0));

    dif = sum([dif_H, dif_L, dif_r]);

    % update the prices
    smooth = 1;% .9 + rand * .1;
    p.w_H0 = smooth * nw_H0 + (1-smooth) * p.w_H0;
    p.w_L0 = smooth * nw_L0 + (1-smooth) * p.w_L0;
    p.r0 = smooth * nr0 + (1-smooth) * p.r0;
end




end

