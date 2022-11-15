%% note : Model v2 - 2 sector 3 region with input-output linkage (zero migration cost within regions, wages are different)
% Last Update: 2022.10.29
% Solving for the Sequential Competitive Equilibrium of the Redding Model
% Consider an economy on a transition path to some unknown steady-state 
%   starting from an initial allocation l_0^j, k_0^j, k_1^j, S_0, D_—1^j, 
%   given an anticipated sequence of changes in fundamentals, z_hat, b_hat,
%   tau_hat, kappa_hat. 
% The strategy to solve the sequential competitive equilibrium is as follows:

clear all; clc;
tic
%% 1. Parameter Setting

J = 2; % ind number
I = 3; % region number

% Initial Allocation
pa.l_0 = [3,2,1;3,2,1]'; 
pa.K_0 = [2,2.5,3]';
pa.K_1 = 1.02.*pa.K_0;
pa.S1_0 = [0.8,0.1,0.1;0.1,0.8,0.1;0.1,0.1,0.8];
pa.S2_0 = [0.8,0.1,0.1;0.1,0.8,0.1;0.1,0.1,0.8];
pa.D_m1 = [[0.4,0.4;0.4,0.4],[0.05,0.05;0.05,0.05],[0.05,0.05;0.05,0.05];
           [0.1,0.1;0.1,0.1],[0.3,0.3;0.3,0.3],[0.1,0.1;0.1,0.1];
           [0.05,0.05;0.05,0.05],[0.05,0.05;0.05,0.05],[0.4,0.4;0.4,0.4]];

% Constant Perameters
pa.eta = 2;
pa.rho = 1;
pa.miu = 0.5;
pa.theta = 4;
pa.phi = 3;
pa.beta = 0.96;
pa.delta = 0.01;
pa.alpha_l = [0.4;0.1]; 
pa.alpha_k = [0.1;0.4];
pa.alpha_m1 = [0.25;0.25];
pa.alpha_m2 = [0.25;0.25];
pa.gamma1 = 0.5;
pa.gamma2 = 0.5;


% Changes in Fundamentals

TT=300;

pa.kappa_0 = [[1,1;1,1],[1.1,1.1;1.1,1.1],[1.1,1.1;1.1,1.1];
              [1.1,1.1;1.1,1.1],[1,1;1,1],[1.1,1.1;1.1,1.1];
              [1.1,1.1;1.1,1.1],[1.1,1.1;1.1,1.1],[1,1;1,1]];
pa.tau_0 = [1,2,2;2,1,2;2,2,1];
pa.z1_0 = [1,1,1]';
pa.z2_0 = [1,1,1]';


pa.z1_hat = ones(3,TT+1);  
pa.z2_hat = ones(3,TT+1);  
pa.b_hat = ones(3,TT+1);
pa.tau_hat = ones(3,3,TT+1);
pa.kappa_hat = ones(6,6,TT+1);
pa.kappa_hat_0 = [[1,1;1,1],[1,1;1,1],[1,1;1,1];
                  [1,1;1,1],[1,1;1,1],[1,1;1,1];
                  [1,1;1,1],[1,1;1,1],[1,1;1,1]];

%% 2. Solve for the sequential competitive equilibrium

% Initial guess

u_hat = ones(3,2,TT+1);
u_hat_new = zeros(3,2,TT+1);

stigma = (1-pa.beta).*ones(3,TT+1);
stigma_new = zeros(3,TT+1);

R = zeros(3,TT+1);  
R_hat = zeros(3,TT+1);
D = zeros(J*I,J*I,TT+1);
D_hat = zeros(J*I,J*I,TT+1);
L = zeros(I,J,TT+1);
L1 = zeros(3,TT+1);
L2 = zeros(3,TT+1);
L_hat = zeros(I,J,TT+1);
pop_hat = zeros(3,TT+1);
S1 = zeros(3,3,TT+1);
S2 = zeros(3,3,TT+1);
S1_hat = zeros(3,3,TT+1);
S2_hat = zeros(3,3,TT+1);
W = zeros(3,TT+1);
W1 = zeros(3,TT+1);
W2 = zeros(3,TT+1);
W1_hat = zeros(3,TT+1);
W2_hat = zeros(3,TT+1);
K = zeros(3,TT+1);
K_hat = zeros(3,TT+1);
K1 = zeros(I,TT+1);
K2 = zeros(I,TT+1);
P_hat = zeros(3,TT+1);
P1_hat = zeros(3,TT+1);
P2_hat = zeros(3,TT+1);

K(:,1)=pa.K_1;

dif = 10;
iter = 0;

% iteration

while dif > 1e-3

    iter = iter + 1;

    %rental rate at t = 1
    R(:,1) = pa.K_1./pa.K_0.*(1-stigma(:,1));

    [m,n]=size(pa.D_m1);
    % migration rate
    for tt = 0 : TT
        if tt == 0
            % migration rate at t = 0
            for j = 1:J
                u = u_hat(:,:,1)';
                fenmu = repmat(sum(repmat(u(:)',3,1).*pa.D_m1(j:J:m,:)./(pa.kappa_hat_0(j:J:m,:)).^(1/pa.rho),2),1,3);
                for h = 1:J
                    DD = pa.D_m1(j:J:m,h:J:n);
                    KK_hat = pa.kappa_hat_0(j:J:m,h:J:n);
                    UU = u_hat(:,h,tt+1);
                    fenzi = DD.*repmat(UU',3,1)./(KK_hat.^(1/pa.rho));
                    D_0(j:J:m,h:J:n) = fenzi./fenmu;
                end    
            end    
        elseif tt == 1
            % migration rate at t = 1
            for j = 1:J
                u = u_hat(:,:,tt+1)';
                fenmu = repmat(sum(repmat(u(:)',3,1).*D_0(j:J:m,:)./(pa.kappa_hat(j:J:m,:,tt)).^(1/pa.rho),2),1,3);
                for h = 1:J
                    DD = D_0(j:J:m,h:J:n);
                    KK_hat = pa.kappa_hat(j:J:m,h:J:n,tt);
                    UU = u_hat(:,h,tt+1);
                    fenzi = DD.*repmat(UU',3,1)./(KK_hat.^(1/pa.rho));
                    D(j:J:m,h:J:n,tt) = fenzi./fenmu;
                end    
            end 
        else    
            % migration rate at t > 1
            for j = 1:J
                u = u_hat(:,:,tt+1)';
                fenmu = repmat(sum(repmat(u(:)',3,1).*D(j:J:m,:,tt-1)./(pa.kappa_hat(j:J:m,:,tt)).^(1/pa.rho),2),1,3);
                for h = 1:J
                    DD = D(j:J:m,h:J:n,tt-1);
                    KK_hat = pa.kappa_hat(j:J:m,h:J:n,tt);
                    UU = u_hat(:,h,tt+1);
                    fenzi = DD.*repmat(UU',3,1)./(KK_hat.^(1/pa.rho));
                    D(j:J:m,h:J:n,tt) = fenzi./fenmu;
                end    
            end 
        end
    end

    % population
    for tt = 1 : TT+1
        if tt == 1
            %population at t = 1
            l = pa.l_0';
            L1 = sum(repmat(l(:),1,6).*D_0,1)';
            L(:,:,tt) = reshape(L1',[2,3])';
            L_hat(:,:,tt) = L(:,:,tt)./pa.l_0;
        else
            l = L(:,:,tt-1)';
            L1 = sum(repmat(l(:),1,6).*D_0,1)';
            L(:,:,tt) = reshape(L1',[2,3])';
            L_hat(:,:,tt) = L(:,:,tt)./L(:,:,tt-1);    
        end
    end
    clear l L1 DD KK_hat UU fenzi fenmu u

    % Solve the initial wage w0 given S0 and l0
    alpha = repmat(pa.alpha_l,1,3)';
    A = pa.l_0(:)./alpha(:);
    Pi = [pa.S1_0', pa.S1_0';
          pa.S2_0', pa.S2_0'];
    POP = repmat(pa.l_0(:)',6,1);
    GAMMA = repmat([repmat(pa.gamma1,3,1);repmat(pa.gamma2,3,1)],1,6);
    ALPHA = [repmat([repmat(pa.alpha_l(1)+pa.alpha_k(1),6,1)],1,3),repmat([repmat(pa.alpha_l(2)+pa.alpha_k(2),6,1)],1,3)];
    ALPHA_M = [pa.alpha_m1(1).*ones(3,3),pa.alpha_m1(2).*ones(3,3);pa.alpha_m2(1).*ones(3,3),pa.alpha_m2(2).*ones(3,3)];
    ALPHA_L = [repmat(pa.alpha_l(1),6,3),repmat(pa.alpha_l(2),6,3)];
    PARA = (GAMMA.* ALPHA + ALPHA_M)./ALPHA_L;
    B = Pi.*POP.*PARA;
    w0 = fsolve(@(w)goodmkt(w, A, B), ones(6, 1)) ;
    if sum(w0<0)
        disp("Fail to solve the initial wage (t=0) \n");
        pause;
    end
    % normalize w1 = 1
    w0 = 1./w0(1).*w0;
    w0 = reshape(w0,[3,2]);
    W_0 = (w0(:,1).*pa.l_0(:,1)+w0(:,2).*pa.l_0(:,2))./sum(pa.l_0,2);
    clear alpha A Pi POP GAMMA ALPHA ALPHA_M ALPHA_L PARA B

    L1 = L(:,1,:);
    L2 = L(:,2,:);

    % Use L_t+1, L_t, K_1, K_0 to solve K_0^j K_1^j
    [K1_0,K2_0] = k_allocation(pa.l_0, pa.K_0, pa) ;

    % Use L_t+1, L_t, K_t+1, K_t, S to solve P_hat, w_hat, S_hat
    tt = 1;
    
    % capital allocation
    [K1(:,tt),K2(:,tt)] = k_allocation(L(:,:,tt), pa.K_1, pa) ;
    K(:,tt) = K1(:,tt)+K2(:,tt);
    K_hat(:,tt) = K(:,tt)./pa.K_0;
    pop_hat(:,tt) = (L1(:,tt)+L2(:,tt))./(pa.l_0(:,1)+pa.l_0(:,2));

    % PSW SYSTEM

    % method 1: iteration
%     [P1_hat(:,tt), P2_hat(:,tt), W1_hat(:,tt), W2_hat(:,tt), S1_hat(:,:,tt), S2_hat(:,:,tt)] = func1(L1(:,tt), pa.l_0(:,1), L2(:,tt), pa.l_0(:,2), K1(:,tt), K1_0, K2(:,tt), K2_0, pa.S1_0, pa.S2_0, w0, pa, tt);


    % method 2: fsolve
    pw = fsolve(@(value)func(value,L1(:,tt), pa.l_0(:,1), L2(:,tt), pa.l_0(:,2), K1(:,tt), K1_0, K2(:,tt), K2_0, pa.S1_0, pa.S2_0, w0, pa, tt), ones(3,4));
    P1_hat(:,tt) = pw(:,1);
    P2_hat(:,tt) = pw(:,2);
    W1_hat(:,tt) = pw(:,3);
    W2_hat(:,tt) = pw(:,4); 
    % S_hat
    c1 = W1_hat(:,tt).^(pa.alpha_l(1)+pa.alpha_k(1)).*(L1(:,tt)./pa.l_0(:,1)./K1(:,tt).*K1_0).^pa.alpha_k(1).*P1_hat(:,tt).^pa.alpha_m1(1).*P2_hat(:,tt).^pa.alpha_m2(1)./pa.z1_hat(:,tt);
    c2 = W2_hat(:,tt).^(pa.alpha_l(2)+pa.alpha_k(2)).*(L2(:,tt)./pa.l_0(:,2)./K2(:,tt).*K2_0).^pa.alpha_k(2).*P1_hat(:,tt).^pa.alpha_m1(2).*P2_hat(:,tt).^pa.alpha_m2(2)./pa.z2_hat(:,tt);
    fenzi1 = (pa.tau_hat(:,:,tt).*repmat(c1',3,1)).^(-pa.theta);
    fenzi2 = (pa.tau_hat(:,:,tt).*repmat(c2',3,1)).^(-pa.theta);
    S1_hat(:,:,tt)=fenzi1./repmat(sum(pa.S1_0.*fenzi1,2),1,3);
    S2_hat(:,:,tt)=fenzi2./repmat(sum(pa.S2_0.*fenzi2,2),1,3);
    
    W1(:,tt) = w0(:,1).*W1_hat(:,tt);
    W2(:,tt) = w0(:,2).*W2_hat(:,tt);
    W(:,tt) = (W1(:,tt).*L1(:,tt)+W2(:,tt).*L2(:,tt))./(L1(:,tt)+L2(:,tt));
    W_hat(:,tt) = W(:,tt)./W_0;
    S1(:,:,tt) = pa.S1_0.*S1_hat(:,:,tt);
    S2(:,:,tt) = pa.S2_0.*S2_hat(:,:,tt);
    P_hat(:,tt) = P1_hat(:,tt).^pa.gamma1.*P2_hat(:,tt).^pa.gamma2;

    % rental rates at tt = 1    
    r = (pa.alpha_k(1)./pa.alpha_l(1).*W1(:,tt).*L1(:,tt)+pa.alpha_k(2)./pa.alpha_l(2).*W2(:,tt).*L2(:,tt))./K(:,tt);
    % given c^j solve P^j
    Price = fsolve(@(P)price(P,W1(:,tt), W2(:,tt), L1(:,tt), L2(:,tt), K1(:,tt), K2(:,tt), pa), ones(3,2));
    % p = (gamma((pa.theta+1-pa.eta)./pa.theta)).^(1/(1-pa.eta)).^(pa.gamma1+pa.gamma2).*Price(:,1).^pa.gamma1.*Price(:,2).^pa.gamma2;
    p = Price(:,1).^pa.gamma1.*Price(:,2).^pa.gamma2;
    R(:,tt) = 1 - pa.delta + r./p;
    
    %update the new capital at tt = 2
    K(:,tt+1)=(1-stigma(:,tt)).*R(:,tt).*K(:,tt);
    
    for tt = 2:TT+1
        % capital allocation
        [K1(:,tt),K2(:,tt)] = k_allocation(L(:,:,tt), K(:,tt), pa) ;
        K(:,tt) = K1(:,tt)+K2(:,tt);
        K_hat(:,tt) = K(:,tt)./K(:,tt-1);
        pop_hat(:,tt) = (L1(:,tt)+L2(:,tt))./(L1(:,tt-1)+L2(:,tt-1));

        % method 1
        pw = fsolve(@(value)func(value,L1(:,tt), L1(:,tt-1), L2(:,tt), L2(:,tt-1), K1(:,tt), K1(:,tt-1), K2(:,tt), K2(:,tt-1), S1(:,:,tt-1), S2(:,:,tt-1), [W1(:,tt-1),W2(:,tt-1)], pa, tt), 2.*ones(3,4));
        P1_hat(:,tt) = pw(:,1);
        P2_hat(:,tt) = pw(:,2);
        W1_hat(:,tt) = pw(:,3);
        W2_hat(:,tt) = pw(:,4); 
        % S_hat
        c1 = W1_hat(:,tt).^(pa.alpha_l(1)+pa.alpha_k(1)).*(L1(:,tt)./L1(:,tt-1)./K1(:,tt).*K1(:,tt-1)).^pa.alpha_k(1).*P1_hat(:,tt).^pa.alpha_m1(1).*P2_hat(:,tt).^pa.alpha_m2(1)./pa.z1_hat(:,tt);
        c2 = W2_hat(:,tt).^(pa.alpha_l(2)+pa.alpha_k(2)).*(L2(:,tt)./L2(:,tt-1)./K2(:,tt).*K2(:,tt-1)).^pa.alpha_k(2).*P1_hat(:,tt).^pa.alpha_m1(2).*P2_hat(:,tt).^pa.alpha_m2(2)./pa.z2_hat(:,tt);
        fenzi1 = (pa.tau_hat(:,:,tt).*repmat(c1',3,1)).^(-pa.theta);
        fenzi2 = (pa.tau_hat(:,:,tt).*repmat(c2',3,1)).^(-pa.theta);
        S1_hat(:,:,tt)=fenzi1./repmat(sum(S1(:,:,tt-1).*fenzi1,2),1,3);
        S2_hat(:,:,tt)=fenzi2./repmat(sum(S2(:,:,tt-1).*fenzi2,2),1,3);
        
        % method 2
%         [P1_hat(:,tt), P2_hat(:,tt), W1_hat(:,tt), W2_hat(:,tt), S1_hat(:,:,tt), S2_hat(:,:,tt)] = func1(L1(:,tt), L1(:,tt-1), L2(:,tt), L2(:,tt-1), K1(:,tt), K1(:,tt-1), K2(:,tt), K2(:,tt-1), S1(:,:,tt-1), S2(:,:,tt-1), [W1(:,tt-1),W2(:,tt-1)], pa, tt);

           
        W1(:,tt) = W1(:,tt-1).*W1_hat(:,tt);
        W2(:,tt) = W2(:,tt-1).*W2_hat(:,tt);
        W(:,tt) = (W1(:,tt).*L1(:,tt)+W2(:,tt).*L2(:,tt))./(L1(:,tt)+L2(:,tt));
        W_hat(:,tt) = W(:,tt)./W(:,tt-1);
        S1(:,:,tt) = S1(:,:,tt-1).*S1_hat(:,:,tt);
        S2(:,:,tt) = S2(:,:,tt-1).*S2_hat(:,:,tt);
        P_hat(:,tt) = P1_hat(:,tt).^pa.gamma1.*P2_hat(:,tt).^pa.gamma2;
    
        % %new rental rates
        R(:,tt) = (1-pa.delta) + W_hat(:,tt)./P_hat(:,tt).*pop_hat(:,tt)./K_hat(:,tt).*(R(:,tt-1)-1+pa.delta);
    
        % update the new capital
        K(:,tt+1)=(1-stigma(:,tt)).*R(:,tt).*K(:,tt);    
    end
    
    W_hat = zeros(3,2,TT+1);
    for tt = 1:TT+1
        W_hat(:,:,tt) = [W1_hat(:,tt),W2_hat(:,tt)];
    end

    for tt=linspace(TT,1,TT)
        %solve backwards for utility
        if tt > 1
            for j = 1:J
                u = u_hat(:,:,tt+1)';
                a = (pa.b_hat(:,tt).*W_hat(:,j,tt)./P_hat(:,tt)).^(pa.beta./pa.rho);
                b = (sum(repmat(u(:)',3,1).*D(j:J:m,:,tt-1)./(pa.kappa_hat(j:J:m,:,tt)).^(1/pa.rho),2)).^pa.beta;
                u_hat_new(:,j,tt) = a.*b;
            end
        else    
            for j = 1:J
                u = u_hat(:,:,tt+1)';
                a = (pa.b_hat(:,tt).*W_hat(:,j,tt)./P_hat(:,tt)).^(pa.beta./pa.rho);
                b = (sum(repmat(u(:)',3,1).*D_0(j:J:m,:)./(pa.kappa_hat(j:J:m,:,tt)).^(1/pa.rho),2)).^pa.beta;
                u_hat_new(:,j,tt) = a.*b;
            end
        end
    end
    u_hat_new(:,TT+1) = 1;

    for tt = linspace(TT,1,TT)
        %solve backwards for stigma
        R(:,TT+1) = 1./pa.beta;
        stigma_new(:,TT+1) = 1-pa.beta.^pa.phi.*R(:,TT+1).^(pa.phi-1); 
        stigma_new(:,tt)=stigma_new(:,tt+1)./(stigma_new(:,tt+1)+pa.beta.^pa.phi.*R(:,tt+1).^(pa.phi-1));
    end   

    difference = abs([u_hat_new(:);stigma_new(:)]-[u_hat(:);stigma(:)]);
    dif = max(max(difference));

    smooth = .9 * rand + .1;
    u_hat = smooth .* u_hat_new + (1 - smooth) .* u_hat;
    stigma = smooth .* stigma_new + (1 - smooth) .* stigma;
end
toc

plot(K')
%% FUNCTIONS

function y = goodmkt(w, A, B)
%GOODMKT apply good market clearing condition to solve the wage 
    y = w.*A - B * w;
end

function [K1,K2] = k_allocation(L,K,pa)
% solve k1 and k2 given l1, l2, K
    K = sum(K,2);
    L_1 = L(:,1);
    L_2 = L(:,2);
    K2 = (pa.alpha_k(2)./pa.alpha_k(1) .* L_2./L_1.*pa.alpha_l(1)./pa.alpha_l(2) .* K ) ./ (1 +pa.alpha_k(2)./pa.alpha_k(1) .* L_2./L_1.*pa.alpha_l(1)./pa.alpha_l(2));
    K1 = K-K2;
end

function [P1_hat, P2_hat, W1_hat, W2_hat, S1_hat, S2_hat] = func1(L1_1, L1_0, L2_1, L2_0, K1_1, K1_0, K2_1, K2_0, S1_0, S2_0, W, pa, tt)
% interation method to solve the p s w system
    gap = 10; iter=0;
    %initial guess
    W1_hat=[1,1,1]';
    W2_hat=[1,1,1]';
    P1_hat=[1,1,1]';
    P2_hat=[1,1,1]';

    while gap > 1e-3
        iter = iter + 1;
        
        % trade flow S change
        c1 = W1_hat.^(pa.alpha_l(1)+pa.alpha_k(1)).*(L1_1./L1_0./K1_1.*K1_0).^pa.alpha_k(1).*P1_hat.^pa.alpha_m1(1).*P2_hat.^pa.alpha_m2(1)./pa.z1_hat(:,tt);
        c2 = W2_hat.^(pa.alpha_l(2)+pa.alpha_k(2)).*(L2_1./L2_0./K2_1.*K2_0).^pa.alpha_k(2).*P1_hat.^pa.alpha_m1(2).*P2_hat.^pa.alpha_m2(2)./pa.z2_hat(:,tt);
        fenzi1 = (pa.tau_hat(:,:,tt).*repmat(c1',3,1)).^(-pa.theta);
        fenzi2 = (pa.tau_hat(:,:,tt).*repmat(c2',3,1)).^(-pa.theta);
        S1_hat=fenzi1./repmat(sum(S1_0.*fenzi1,2),1,3);
        S2_hat=fenzi2./repmat(sum(S2_0.*fenzi2,2),1,3);
        S1_new=S1_0.*S1_hat; 
        S2_new=S1_0.*S2_hat; 
        
        % wage change
        b1 = W1_hat.*L1_1./L1_0;
        b2 = W2_hat.*L2_1./L2_0;
        a1_1 = (pa.gamma1.*(pa.alpha_l(1)+pa.alpha_k(1))+pa.alpha_m1(1))./pa.alpha_l(1) .* W(:,1) .* L1_0;
        a1_2 = (pa.gamma1.*(pa.alpha_l(2)+pa.alpha_k(2))+pa.alpha_m2(1))./pa.alpha_l(2) .* W(:,2) .* L2_0;
        a2_1 = (pa.gamma2.*(pa.alpha_l(1)+pa.alpha_k(1))+pa.alpha_m1(2))./pa.alpha_l(1) .* W(:,1) .* L1_0;
        a2_2 = (pa.gamma2.*(pa.alpha_l(2)+pa.alpha_k(2))+pa.alpha_m2(2))./pa.alpha_l(2) .* W(:,2) .* L2_0;
        fenzi1 = S1_new.*repmat(a1_1.*b1,1,3) + S1_new.*repmat(a1_2.*b2,1,3);
        fenzi2 = S2_new.*repmat(a2_1.*b1,1,3) + S2_new.*repmat(a2_2.*b2,1,3);
        fenmu1 = repmat(sum(S1_0.*repmat(a1_1,1,3) + S1_0.*repmat(a1_2,1,3),1),3,1)';
        fenmu2 = repmat(sum(S2_0.*repmat(a2_1,1,3) + S2_0.*repmat(a2_2,1,3),1),3,1)';
        W1_hat_new = sum(fenzi1./fenmu1,1)'.*L1_0./L1_1;
        W2_hat_new = sum(fenzi2./fenmu2,1)'.*L2_0./L2_1;
        % wage normalization
        W1_hat_new = 1./W1_hat_new(1).*W1_hat_new;
        W2_hat_new = 1./W1_hat_new(1).*W2_hat_new;
        
        P_new = fsolve(@(P)price_hat(P, W1_hat_new, W2_hat_new, S1_0, S2_0, L1_1, L1_0, K1_1, K1_0, L2_1, L2_0, K2_1, K2_0, pa), ones(3, 2)) ;
        P1_hat_new = P_new(:,1);
        P2_hat_new = P_new(:,2);
%         % price change in ind 1
%         c1_new = W1_hat_new.^(pa.alpha_l(1)+pa.alpha_k(1)).*(L1_1./L1_0./K1_1.*K1_0).^pa.alpha_k(1).*P1_hat.^pa.alpha_m1(1).*P2_hat.^pa.alpha_m2(1)./pa.z1_hat(:,tt);
%         a = S1_new.*(repmat(c1_new',3,1).*pa.tau_hat(:,:,tt)).^(-pa.theta);
%         P1_hat_new = sum(a,2).^(-1./pa.theta);
%         
%         % price change in ind 2
%         c2_new = W2_hat_new.^(pa.alpha_l(2)+pa.alpha_k(2)).*(L2_1./L2_0./K2_1.*K2_0).^pa.alpha_k(2).*P1_hat_new.^pa.alpha_m1(2).*P2_hat.^pa.alpha_m2(2)./pa.z2_hat(:,tt);
%         a = S2_new.*(repmat(c2_new',3,1).*pa.tau_hat(:,:,tt)).^(-pa.theta);
%         P2_hat_new = sum(a,2).^(-1./pa.theta);

        difference = abs([W1_hat_new;W2_hat_new;P1_hat_new;P2_hat_new]-[W1_hat;W2_hat;P1_hat;P2_hat]);
        gap = max(max(difference));
        
        smooth=.9*rand+.1;
        W1_hat=smooth.*W1_hat+(1-smooth).*W1_hat_new;
        W2_hat=smooth.*W2_hat+(1-smooth).*W2_hat_new;
        P1_hat=smooth.*P1_hat+(1-smooth).*P1_hat_new;
        P2_hat=smooth.*P2_hat+(1-smooth).*P2_hat_new;
    end

end


function pw = func(value, L1_1, L1_0, L2_1, L2_0, K1_1, K1_0, K2_1, K2_0, S1_0, S2_0, W, pa, tt)
% using fsolve to solve the p w s
    P1_hat = value(:,1);
    P2_hat = value(:,2);
    W1_hat = value(:,3);
    W2_hat = value(:,4);

    c1 = W1_hat.^(pa.alpha_l(1)+pa.alpha_k(1)).*(L1_1./L1_0./K1_1.*K1_0).^pa.alpha_k(1).*P1_hat.^pa.alpha_m1(1).*P2_hat.^pa.alpha_m2(1)./pa.z1_hat(:,tt);
    c2 = W2_hat.^(pa.alpha_l(2)+pa.alpha_k(2)).*(L2_1./L2_0./K2_1.*K2_0).^pa.alpha_k(2).*P1_hat.^pa.alpha_m1(2).*P2_hat.^pa.alpha_m2(2)./pa.z2_hat(:,tt);
    fenzi1 = (pa.tau_hat(:,:,tt).*repmat(c1',3,1)).^(-pa.theta);
    fenzi2 = (pa.tau_hat(:,:,tt).*repmat(c2',3,1)).^(-pa.theta);
    S1_hat=fenzi1./repmat(sum(S1_0.*fenzi1,2),1,3);
    S2_hat=fenzi2./repmat(sum(S2_0.*fenzi2,2),1,3);
    S1_new=S1_0.*S1_hat; 
    S2_new=S2_0.*S2_hat; 
    
    % wage change
    b1 = W1_hat.*L1_1./L1_0;
    b2 = W2_hat.*L2_1./L2_0;
    a1_1 = (pa.gamma1.*(pa.alpha_l(1)+pa.alpha_k(1))+pa.alpha_m1(1))./pa.alpha_l(1) .* W(:,1) .* L1_0;
    a1_2 = (pa.gamma1.*(pa.alpha_l(2)+pa.alpha_k(2))+pa.alpha_m2(1))./pa.alpha_l(2) .* W(:,2) .* L2_0;
    a2_1 = (pa.gamma2.*(pa.alpha_l(1)+pa.alpha_k(1))+pa.alpha_m1(2))./pa.alpha_l(1) .* W(:,1) .* L1_0;
    a2_2 = (pa.gamma2.*(pa.alpha_l(2)+pa.alpha_k(2))+pa.alpha_m2(2))./pa.alpha_l(2) .* W(:,2) .* L2_0;
    fenzi1 = S1_new.*repmat(a1_1.*b1,1,3) + S1_new.*repmat(a1_2.*b2,1,3);
    fenzi2 = S2_new.*repmat(a2_1.*b1,1,3) + S2_new.*repmat(a2_2.*b2,1,3);
    fenmu1 = repmat(sum(S1_0.*repmat(a1_1,1,3) + S1_0.*repmat(a1_2,1,3),1),3,1)';
    fenmu2 = repmat(sum(S2_0.*repmat(a2_1,1,3) + S2_0.*repmat(a2_2,1,3),1),3,1)';
    W1_hat_new = sum(fenzi1./fenmu1,1)'.*L1_0./L1_1;
    W2_hat_new = sum(fenzi2./fenmu2,1)'.*L2_0./L2_1;
    % wage normalization
    W1_hat_new = 1./W1_hat_new(1).*W1_hat_new;
    W2_hat_new = 1./W1_hat_new(1).*W2_hat_new;    
    pw(:,1) = W1_hat - W1_hat_new;
    pw(:,2) = W2_hat - W2_hat_new;
    
    % price change in ind 1
    c1 = W1_hat.^(pa.alpha_l(1)+pa.alpha_k(1)).*(L1_1./L1_0./K1_1.*K1_0).^pa.alpha_k(1).*P1_hat.^pa.alpha_m1(1).*P2_hat.^pa.alpha_m2(1)./pa.z1_hat(:,1);
    a1 = S1_0.*(repmat(c1',3,1).*pa.tau_hat(:,:,1)).^(-pa.theta);
    pw(:,3) = P1_hat - sum(a1,2).^(-1./pa.theta);
    
    % price change in ind 2
    c2 = W2_hat.^(pa.alpha_l(2)+pa.alpha_k(2)).*(L2_1./L2_0./K2_1.*K2_0).^pa.alpha_k(2).*P1_hat.^pa.alpha_m1(2).*P2_hat.^pa.alpha_m2(2)./pa.z2_hat(:,1);
    a2 = S2_0.*(repmat(c2',3,1).*pa.tau_hat(:,:,1)).^(-pa.theta);
    pw(:,4) = P2_hat - sum(a2,2).^(-1./pa.theta);

end


function price_hat = price_hat(P, W1_hat, W2_hat, S1_0, S2_0, L1_1, L1_0, K1_1, K1_0, L2_1, L2_0, K2_1, K2_0, pa) 
% given w_hat S_hat solve p_hat
    P1_hat = P(:,1);
    P2_hat = P(:,2);
    % price change in ind 1
    c1 = W1_hat.^(pa.alpha_l(1)+pa.alpha_k(1)).*(L1_1./L1_0./K1_1.*K1_0).^pa.alpha_k(1).*P1_hat.^pa.alpha_m1(1).*P2_hat.^pa.alpha_m2(1)./pa.z1_hat(:,1);
    a1 = S1_0.*(repmat(c1',3,1).*pa.tau_hat(:,:,1)).^(-pa.theta);
    price_hat(:,1) = P1_hat - sum(a1,2).^(-1./pa.theta);
    
    % price change in ind 2
    c2 = W2_hat.^(pa.alpha_l(2)+pa.alpha_k(2)).*(L2_1./L2_0./K2_1.*K2_0).^pa.alpha_k(2).*P1_hat.^pa.alpha_m1(2).*P2_hat.^pa.alpha_m2(2)./pa.z2_hat(:,1);
    a2 = S2_0.*(repmat(c2',3,1).*pa.tau_hat(:,:,1)).^(-pa.theta);
    price_hat(:,2) = P2_hat - sum(a2,2).^(-1./pa.theta);
end

function price = price(P, W1, W2, L1, L2, K1, K2, pa) 
% given w S solve p
    P1 = P(:,1);
    P2 = P(:,2);

%     A1 = pa.alpha_l(1).^pa.alpha_l(1).*pa.alpha_k(1).^pa.alpha_k(1).*pa.alpha_m1(1).^pa.alpha_m1(1).*pa.alpha_m2(1).^pa.alpha_m2(1);
%     A2 = pa.alpha_l(2).^pa.alpha_l(2).*pa.alpha_k(2).^pa.alpha_k(2).*pa.alpha_m1(2).^pa.alpha_m1(2).*pa.alpha_m2(2).^pa.alpha_m2(2);

    % price change in ind 1
    c1 = W1.^(pa.alpha_l(1)+pa.alpha_k(1)).*(L1./K1).^pa.alpha_k(1).*P1.^pa.alpha_m1(1).*P2.^pa.alpha_m2(1)./pa.z1_0;
    a1 = (repmat(c1',3,1).*pa.tau_0).^(-pa.theta);
    price(:,1) = P1 - sum(a1,2).^(-1./pa.theta);
    
    % price change in ind 2
    c2 = W2.^(pa.alpha_l(2)+pa.alpha_k(2)).*(L2./K2).^pa.alpha_k(2).*P1.^pa.alpha_m1(2).*P2.^pa.alpha_m2(2)./pa.z2_0;
    a2 = (repmat(c2',3,1).*pa.tau_0).^(-pa.theta);
    price(:,2) = P2 - sum(a2,2).^(-1./pa.theta);
end

% end
