%% note : Model v1 - 1 sector 3 region
% Last Update: 2022.10.10
% Solving for the Sequential Competitive Equilibrium of the Redding Model
% Consider an economy on a transition path to some unknown steady-state 
%   starting from an initial allocation l_0, k_0, k_1, S_0, D_—1, W_0, 
%   given an anticipated sequence of changes in fundamentals, z_hat, b_hat,
%   tau_hat, kappa_hat. 
% The strategy to solve the sequential competitive equilibrium is as follows:

clear all; clc;
tic
%% 1. Parameter Setting

% Initial Allocation
pa.l_0 = [6,4,2]'; 
pa.K_0 = [1,1.25,1.5]';
pa.K_1 = 1.02.*pa.K_0;
pa.S_0 = [0.8,0.1,0.1;0.1,0.8,0.1;0.1,0.1,0.8];
pa.D_m1 = [0.7,0.15,0.15;0.15,0.7,0.15;0.15,0.15,0.7];

% Constant Perameters
pa.rho = 1;
pa.miu = 0.5;
pa.theta = 4;
pa.phi = 3;
pa.beta = 0.96;
pa.delta = 0.01;

% Changes in Fundamentals

TT=300;

pa.kappa_0 = [1,1.1,1.1;1.1,1,1.1;1.1,1.1,1];
pa.tau_0 = [1,2,2;2,1,2;2,2,1];
pa.z_0 = [1,1,1]';


pa.z_hat = ones(3,TT+1);  
pa.b_hat = ones(3,TT+1);
pa.tau_hat = ones(3,3,TT+1);
pa.kappa_hat = ones(3,3,TT+1);
pa.kappa_hat_0 = ones(3,3);
% for tt=1:10
%     z_hat(:,tt)=[1,1,1]*2;
%     b_hat(:,tt)=[1,1,1]*2;
%     tau_hat(:,:,tt)=[1,1,1;1,1,1;1,1,1]*2;
%     kappa_hat(:,:,tt)=[1,1,1;1,1,1;1,1,1]*2;
% end


%% 2. Solve for the sequential competitive equilibrium

% Initial guess

u_hat = repmat(linspace(1.8,1,TT+1),3,1);
u_hat_new = zeros(3,TT+1);

stigma = (1-pa.beta).*ones(3,TT+1);
stigma_new = zeros(3,TT+1);

R = zeros(3,TT+1);  
R_hat = zeros(3,TT+1);
D = zeros(3,3,TT+1);
D_hat = zeros(3,3,TT+1);
L = zeros(3,TT+1);
L_hat = zeros(3,TT+1);
S = zeros(3,3,TT+1);
S_hat = zeros(3,3,TT+1);
W = zeros(3,TT+1);
W_hat = zeros(3,TT+1);
K = zeros(3,TT+1);
P_hat = zeros(3,TT+1);
Chi = zeros(3, TT+1);  
Chi_hat = ones(3, TT+1);

K(:,1)=pa.K_1;

dif = 10;
iter = 0;

% iteration

% while (iter <= 1e4 && dif > 1e-3 && flag == 1)
while dif > 1e-3

    flag = 1;
    iter = iter + 1;

    %rental rate at t = 1
    R(:,1) = pa.K_1./pa.K_0.*(1-stigma(:,1));
    
    % migration rate
    for tt = 0 : TT
        if tt == 0
            % migration rate at t = 0
            fenzi = pa.D_m1.*repmat(u_hat(:,tt+1)',3,1)./(pa.kappa_hat_0'.^(1/pa.rho));
            D_0 = fenzi./repmat(sum(fenzi,2),1,3);
        elseif tt == 1
            % migration rate at t = 1
            fenzi=D_0.*repmat(u_hat(:,tt+1)',3,1)./(pa.kappa_hat(:,:,tt)'.^(1/pa.rho));
            D(:,:,tt) = fenzi./repmat(sum(fenzi,2),1,3);
        else            
            fenzi =D(:,:,tt-1).*repmat(u_hat(:,tt+1)',3,1)./(pa.kappa_hat(:,:,tt)'.^(1/pa.rho)); 
            D(:,:,tt) = fenzi./repmat(sum(fenzi,2),1,3);
        end
    end

    % population
    for tt = 1 : TT+1
        if tt == 1
            %population at t = 1
            L(:,tt) = sum(repmat(pa.l_0,tt,3).*D_0,1)';
            L_hat(:,tt) = L(:,tt)./pa.l_0;
        else
            L(:,tt) = sum(repmat(L(:,tt-1),1,3).*D(:,:,tt-1),1)';
            L_hat(:,tt) = L(:,tt)./L(:,tt-1);    
        end
    end
    
    % Solve the initial wage w0 given S0 and l0
    w0 = fsolve(@(w)goodmkt(w, pa.S_0, pa.l_0), ones(3, 1)) ;
    if sum(w0<0)
        disp("Fail to solve the initial wage (t=0) \n");
        pause;
    end
    
    Chi(:,1) = K(:,1)./L(:,1);
    Chi_hat(:,1) = Chi(:,1)./pa.K_0.*pa.l_0;

    %relative changes in wages and expenditure shares at t == 0    
    [W_hat(:,1),S_hat(:,:,1)]=function1(pa.l_0,L(:,1),pa.K_0,pa.K_1,pa.S_0,w0,pa.z_hat(:,1),pa.tau_hat(:,:,1),pa.miu,pa.theta);
    W(:,1) = w0 .* W_hat(:,1);
    S(:,:,1) = pa.S_0.*S_hat(:,:,1);
    %relative changes in price indices at t == 1
    a = W_hat(:,1).*(K(:,1)./pa.K_0.*pa.l_0./L(:,1)).^(pa.miu-1)./pa.z_hat(:,1);
    fenzi = (pa.tau_hat(:,:,tt).*repmat(a',3,1)).^(-pa.theta);
    together = S(:,:,1).*fenzi;
    P_hat(:,1)=(sum(together,2)).^(-1/pa.theta);
    %rental rates at t == 1
    a = (1-pa.miu)/pa.miu * W(:,1) .* L(:,1) ./ K(:,1);
    cons = ( (1-pa.miu)/pa.miu )^(1-pa.miu);
    b = ( cons * pa.tau_0 .* repmat(  (W(:,1) .* ( K(:,1)./L(:,1) ).^(pa.miu-1)  ./pa.z_0 )' ,3 , 1 ) ).^(-pa.theta) ;
    p0 = ( sum( b , 2)   ).^(-1/pa.theta) ;
    R(:,1) = 1 - pa.delta + a ./ p0 ;
    %rental rate R at t == 2
    R(:,2)=(1-pa.delta)+W_hat(:,1)./P_hat(:,1)./(K(:,1)./pa.K_0.*pa.l_0./L(:,1)).*(R(:,1)-1+pa.delta);
    %update the new capital at t == 2
    K(:,2)=(1-stigma(:,1)).*R(:,1).*K(:,1);

    for tt=1:TT
        %relative changes in wages and the new expenditure shares        
        [W_hat(:,tt+1),S_hat(:,:,tt+1)]=function1(L(:,tt),L(:,tt+1),K(:,tt),K(:,tt+1),S(:,:,tt),W(:,tt),pa.z_hat(:,tt+1),pa.tau_hat(:,:,tt+1),pa.miu,pa.theta);
        W(:,tt+1) = W(:,tt).*W_hat(:,tt+1);
        S(:,:,tt+1) = S(:,:,tt).*S_hat(:,:,tt+1);

        %relative changes in price indices
        a = W_hat(:,tt+1).*(K(:,tt+1)./K(:,tt).*L(:,tt)./L(:,tt+1)).^(pa.miu-1)./pa.z_hat(:,tt+1);
        fenzi = (pa.tau_hat(:,:,tt).*repmat(a',3,1)).^(-pa.theta);
        together = S(:,:,tt).*fenzi;
        P_hat(:,tt+1)=(sum(together,2)).^(-1/pa.theta);
        
        %new rental rates
        R(:,tt+1)=(1-pa.delta)+W_hat(:,tt+1)./P_hat(:,tt+1)./(K(:,tt+1)./K(:,tt).*L(:,tt)./L(:,tt+1)).*(R(:,tt)-1+pa.delta);
        
        %update the new capital
        if tt < TT
        K(:,tt+2)=(1-stigma(:,tt+1)).*R(:,tt+1).*K(:,tt+1);
        end
    end
    
    a = linspace(TT,1,TT);
    for tt=linspace(TT,1,TT)
        %solve backwards for utility
        if tt > 1
            together = repmat(u_hat(:,tt+1)',3,1)./(pa.kappa_hat(:,:,tt)').^(1/pa.rho).*D(:,:,tt-1);
        else    
            together = repmat(u_hat(:,tt+1)',3,1)./(pa.kappa_hat(:,:,tt)').^(1/pa.rho).*D_0;
        end
        u_hat_new(:,tt)=(pa.b_hat(:,tt).*W_hat(:,tt)./P_hat(:,tt)).^(pa.beta/pa.rho).*sum(together,2).^(pa.beta);
    end
    u_hat_new(:,TT+1) = 1;

    for tt = a
        %solve backwards for stigma
        R(:,TT+1) = 1./pa.beta;
        stigma_new(:,TT+1) = 1-pa.beta.^pa.phi.*R(:,TT+1).^(pa.phi-1); 
        stigma_new(:,tt)=stigma_new(:,tt+1)./(stigma_new(:,tt+1)+pa.beta.^pa.phi.*R(:,tt+1).^(pa.phi-1));
    end   
    
    difference = abs([u_hat_new;stigma_new]-[u_hat;stigma]);
    dif = max(max(difference));

    smooth = .9 * rand + .1;
    u_hat = smooth .* u_hat_new + (1 - smooth) .* u_hat;
    stigma = smooth .* stigma_new + (1 - smooth) .* stigma;
end
toc

%% Functions

function [W_hat,S_hat]=function1(L_0,L_1,K_0,K_1,S,W,z_hat,tau_hat,miu,theta)

    gap = 10; iter=0;
    W_hat=[1,1,1]';
    while gap > 1e-3
        iter = iter + 1;
        
        % trade flow S change
        chi_hat = K_1./K_0.*L_0./L_1;
        A = W_hat./z_hat.*(chi_hat).^(miu-1);
        fenzi = (tau_hat.*repmat(A',3,1)).^(-theta);
        S_hat=fenzi./repmat(sum(S.*fenzi,2),1,3);
        S_new=S.*S_hat;
        
        
        % wage change
        A = W_hat.*L_1./L_0;
        B_1 = S_new.*repmat(W.*L_0.*A,1,3);            
        B_2 = sum(S.*repmat(W.*L_0,1,3),1);
        W_hat_new = sum(B_1./repmat(B_2,3,1),1)'.*L_0./L_1;

        gap = max(abs(W_hat_new - W_hat));
        
        smooth=.1*rand+.9;
        W_hat=smooth.*W_hat+(1-smooth).*W_hat_new;
    end
end

function y = goodmkt(w, S, l)
%GOODMKT apply good market clearing condition to solve the wage 
    y = w.*l - S' * (w.*l);
end


