%% note : Model v1 - 1 sector
% Last Update: 2022.10.4
% Solving for the Sequential Competitive Equilibrium of the Redding Model
% Consider an economy on a transition path to some unknown steady-state 
%   starting from an initial allocation l_0, k_0, k_1, S_0, D_—1, W_0, 
%   given an anticipated sequence of changes in fundamentals, z_hat, b_hat,
%   tau_hat, kappa_hat. 
% The strategy to solve the sequential competitive equilibrium is as follows:

clear all; clc;

%% 1. Parameter Setting

% Initial Allocation
l_0 = [1,1,1]'; 
K_0 = [1,1,1]';
K_1 = [1.1,1.1,1.1]';
S_0 = [0.5,0.3,0.2;0.3,0.4,0.3;0.1,0.1,0.8];
D_m1 = [0.33,0.34,0.33;0.33,0.34,0.33;0.33,0.34,0.33];
W_0 = [1,1,1]';
kappa_hat_0 = [1,1.1,1.1;1.1,1,1.1;1.1,1.1,1];

% Constant Perameters
rho = 2;
miu = 0.5;
theta = 4;
phi = 3;
beta = 0.96;
delta = 0.06;

% Changes in Fundamentals

TT=300;

for tt=1:TT+1
    z_hat(:,tt)=[1.1,1.1,1.1];
    b_hat(:,tt)=[1.1,1.1,1.1;];
    tau_hat(:,:,tt)=[1,1.1,1.1;1.1,1,1.1;1.1,1.1,1];
    kappa_hat(:,:,tt)=[1,1.1,1.1;1.1,1,1.1;1.1,1.1,1];
end

%% 2. Solve for the initial "calibrated" steady state

% Initial guess

u_hat = linspace(1.05,1,TT+1);
u_hat = repmat(u_hat,3,1);
u_hat_new = u_hat;

for tt=1:TT+1
    stigma(:,tt)=[0.3,0.3,0.3]';
end

R = zeros(3,TT+1);  
D = zeros(3,3,TT+1);
D_hat = zeros(3,3,TT+1);
L = zeros(3,TT+1);
L_hat = zeros(3,TT+1);
K = zeros(3,TT+1);
P_hat = zeros(3,TT+1);
R_hat = zeros(3,TT+1);
S = zeros(3,3,TT+1);
S_hat = zeros(3,3,TT+1);
W = zeros(3,TT+1);
W_hat = zeros(3,TT+1);
 
K(:,1)=K_0;
K(:,2)=K_1;
W(:,1)=W_0;
S(:,:,1)=S_0;

dif = 10;
iter = 0;

% iteration

while dif > 1e-3
    
    iter = iter + 1;

    %rental rate at t = 1
    R(:,1) = K_1./K_0.*(1-stigma(:,1));

    %migration rate at t = 0
    fenzi = D_m1.*(repmat(u_hat(:,1)',3,1)./kappa_hat_0').^(1/rho);
    D_0 = fenzi./sum(fenzi,2);

    %population at t=1
    L(:,1) = sum(repmat(l_0,1,3).*D_0,1)';
    L_hat(:,1) = L(:,1)./l_0;

    %migration rate at t = 1
    fenzi=D_0.*(repmat(u_hat(:,2)',3,1)./kappa_hat(:,:,1)').^(1/rho);
    D(:,:,1) = fenzi./sum(fenzi,2);

    %population at t=2
    L(:,2) = sum(repmat(L(:,1),1,3).*D(:,:,1),1)';
    L_hat(:,2) = L(:,2)./L(:,1);

    for tt=2:TT
        %migration rate
        fenzi =D(:,:,tt-1).*repmat(u_hat(:,tt+1),1,3)./(kappa_hat(:,:,tt)'.^(1/rho)); 
        D(:,:,tt) = fenzi./sum(fenzi,2);

        %employment level
        together = D(:,:,tt-1).*repmat(L(:,tt-1),1,3);
        L(:,tt)=sum(together,1)';
        L_hat(:,tt) = L(:,tt)./L(:,tt-1);
    end
    
    %employment level at TT+1
    together = D(:,:,TT).*repmat(L(:,TT),1,3);
    L(:,TT+1)=sum(together,1)';
    L_hat(:,TT+1) = L(:,TT+1)./L(:,TT);
    
    for tt=1:TT
        %relative changes in wages and the new expenditure shares        
        [W_hat(:,tt+1),S_hat(:,:,tt+1)]=function1(L(:,tt),L(:,tt+1),K(:,tt),K(:,tt+1),S(:,:,tt),W(:,tt),z_hat(:,tt),tau_hat(:,tt),miu,theta);
        W(:,tt+1) = W(:,tt).*W_hat(:,tt+1);
        S(:,:,tt+1) = S(:,:,tt).*S_hat(:,:,tt+1);

        %relative changes in price indices
        a = W_hat(:,tt+1).*(K(:,tt+1)./K(:,tt).*L(:,tt)./L(:,tt+1)).^(miu-1)./z_hat(:,tt+1);
        fenzi = (tau_hat(:,:,tt).*repmat(a',3,1)).^(-theta);
        together = S(:,:,tt).*fenzi;
        P_hat(:,tt+1)=(sum(together,2)).^(-1/theta);
        
        %new rental rates
        R(:,tt+1)=(1-delta)+W_hat(:,tt+1)./P_hat(:,tt+1)./(K(:,tt+1)./K(:,tt).*L(:,tt)./L(:,tt+1)).*(R(:,tt)-1+delta);
        
        %update the new capital
        if tt < TT
        K(:,tt+2)=(1-stigma(:,tt+1)).*R(:,tt+1).*K(:,tt+1);
        end
    end

    [W_hat(:,1),S_hat(:,:,1)]=function1(l_0,L(:,1),K_0,K(:,1),S_0,W_0,z_hat(:,1),tau_hat(:,1),miu,theta);
    a = W_hat(:,1).*(K(:,1)./K_0.*l_0./L(:,1)).^(miu-1)./z_hat(:,1);
    fenzi = (tau_hat(:,:,1).*repmat(a',3,1)).^(-theta);
    together = S(:,:,tt).*fenzi;
    P_hat(:,1)=(sum(together,2)).^(-1/theta);
    a = linspace(300,1,300);
    for tt=a
        %solve backwards for utility
        together = repmat(u_hat(:,tt+1)',3,1)./(kappa_hat(:,:,tt)).^(1/rho);
        u_hat_new(:,tt)=(b_hat(:,tt).*W_hat(:,tt)./P_hat(:,tt)).^(beta/rho).*sum(together,2).^beta;
    end

    for tt = a
        %solve backwards for s
        R(:,TT+1) = 1./beta;
        stigma_new(:,TT+1) = stigma(:,TT+1); 
        stigma_new(:,tt)=stigma_new(:,tt+1)./(stigma_new(:,tt+1)+beta.^phi.*R(:,tt+1).^(phi-1));
    end   
    
    dif = max(max(abs([u_hat_new;stigma_new]-[u_hat;stigma])));
    u_hat = u_hat_new;
    stigma = stigma_new;
end

%% Functions

function [W_hat,S_hat]=function1(L_0,L_1,K_0,K_1,S,W,z_hat,tau_hat,miu,theta)

        gap = 10; iternum=0;
        W_hat=[1.1,1.1,1.1]';
        while gap > 1e-3
            iternum = iternum + 1;
            
            A = W_hat.*(K_1./K_0.*L_0./L_1).^(miu-1)./z_hat;
            fenzi = (tau_hat.*repmat(A',3,1)).^(-theta);
            S_hat=fenzi./sum(S.*fenzi,2);
            S_new=S.*S_hat;
            A = W_hat.*L_1./L_0;
            B_1 = S_new.*repmat(W.*L_1,1,3);            
            B_2 = sum(S.*repmat(W.*L_1,1,3),1);
            B = sum(B_1./repmat(B_2,3,1),1)';
            W_hat_new=B.*L_0./L_1;
            gap = max(abs((W_hat_new - W_hat)./W_hat));
            
            smooth=.1*rand+.9;
            W_hat=smooth.*W_hat+(1-smooth).*W_hat_new;
        end
end


