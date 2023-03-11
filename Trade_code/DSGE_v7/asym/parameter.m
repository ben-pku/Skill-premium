function [pa, y] = parameter(num, sec, counterfactual)
%PARAMETER formalize the parameter struct

pa.num = num; % num of countries
pa.sec = sec; % num of sectors
pa.T = 200;

% agri production:
pa.A = ones(pa.num, 1); % t=0
pa.A(2) = NaN;
pa.A_h = ones(pa.num, pa.T+1);
pa.A_h(2) = NaN;
% nonagri production: 
% manu, low-skill service, high-skill service 
pa.mu_K =  [0 0.33 0.2 0.4]; 
pa.mu_L =  [1 0.57    0.7     0.10]; % unskilled labor share
pa.mu_H = [0 0.10   0.1    0.50]; % skilled labor share
% T at t=0
pa.Te1 = ones(pa.num, 1);
pa.Te2 = ones(pa.num,1);
pa.Te3 = ones(pa.num,1);
pa.Te4 = ones(pa.num,1);
pa.Te_h1 = ones(pa.num, pa.T+1); % technical change in sector 1
pa.A_h = ones(pa.num, pa.T+1);
pa.Te_h2 = ones(pa.num, pa.T+1); % technical change in sector 2
pa.Te_h3 = ones(pa.num, pa.T+1); % technical change in sector 3
pa.Te_h4 = ones(pa.num, pa.T+1); % technical change in sector 4
pa.delta = 0.06; % depreciate rate
if counterfactual == 2
    pa.delta = 1;
end
% manu, L-S, H-S
pa.eta = [2, 2, 2, 2].* ones(1,4);
pa.theta = [8, 4, 8, 6] .* ones(1,4); % trade elasticity
% Household
pa.beta = 0.96; % discount factor / year
pa.epsilon = [ 0.3 1 0.9 1.2 ]; % a,m, Ls, Hs   non-homothetic Elasticity
pa.sigma = 0.5;
pa.Omega = [1, 1, 1, 1] .* ones(1, pa.sec); % Omega

% trade

pa.d_h = ones(pa.num, pa.num, pa.sec, pa.T+1);
if counterfactual == 0 || counterfactual == 2 % if trade costs decline from 0 to 30
    change2 = (1/10)^(1/30);% international trade cost decline
    for t = 1:30
        for j = 3: pa.num % urban China import cost decline
            pa.d_h(2, j, 2, t) = change2 ;
            pa.d_h(2, j, 3, t) = change2 ;
            pa.d_h(2, j, 4, t) = change2 ;
        end

        for j = 3: pa.num % urban China export cost decline
            pa.d_h(j, 2, 2, t) = change2 ;
            pa.d_h(j, 2, 3, t) = change2 ;
            pa.d_h(j, 2, 4, t) = change2 ;
        end
    end
end

% initial trade share -- agri no trade
pa.S1 = [      0.85 0  0.06  0.03 0.03 0.03  ;
                      0.82 0.01  0.07  0.03  0.03 0.04;
                      0.001 0 0.799 0.01 0.18 0.01 ;
                      0.0001 0 0.03 0.9 0.03  0.0399  ;
                      0.0001 0 0.0599 0.02 0.9  0.02;
                      0.0001 0 0.0599 0.02  0.02 0.9]; %sector 1 agri
pa.S2 = [   0.01 0.75 0.075 0.075 0.05 0.04 ;
                   0.01 0.75 0.075 0.075 0.05 0.04 ;
                   0.01 0.15 0.7 0.05 0.05 0.04 ;
                   0.01 0.15 0.1 0.65 0.05 0.04 ;
                   0.01 0.15 0.1 0.05 0.65 0.04 ;
                   0.01 0.15 0.1 0.05 0.05 0.64 ]; % sector 2 manufacturing
pa.S3 = [    0.01 0.75 0.075 0.075 0.05 0.04 ;
                   0.01 0.75 0.075 0.075 0.05 0.04 ;
                   0.01 0.15 0.7 0.05 0.05 0.04 ;
                   0.01 0.15 0.1 0.65 0.05 0.04 ;
                   0.01 0.15 0.1 0.05 0.65 0.04 ;
                   0.01 0.15 0.1 0.05 0.05 0.64  ]; % sector 3 low-skill service
pa.S4 = [   0.1 0.3 0.28 0.26 0.03 0.03 ;
                   0.1 0.3 0.28 0.26 0.03 0.03 ;
                   0.1 0.004 0.65 0.231 0.005 0.01 ;
                   0.1 0.004 0.23 0.651 0.005 0.01 ;
                   0.01 0.004 0.25 0.241 0.65 0.025 ;
                   0.01 0.004 0.2 0.211 0.025 0.55 ]; % sector 4 high-skill service

% trade cost
pa.d0 =   ones(pa.num, pa.num, pa.sec) ;

    for n = 1 : pa.num
        for i = 1 : pa.num
          pa.d0(n, i, 1) = (pa.S1(n,i) * pa.S1(i,n)/(pa.S1(n,n)*pa.S1(i,i))  ).^(-1/(2* pa.theta(1)));
        end
    end

     for n = 1 : pa.num
        for i = 1 : pa.num
          pa.d0(n, i, 2) = (pa.S2(n,i) * pa.S2(i,n)/(pa.S2(n,n)*pa.S2(i,i))  ).^(-1/(2* pa.theta(2)));
        end
     end

      for n = 1 : pa.num
        for i = 1 : pa.num
          pa.d0(n, i, 3) = (pa.S3(n,i) * pa.S3(i,n)/(pa.S3(n,n)*pa.S3(i,i))  ).^(-1/(2* pa.theta(3)));
        end
      end

      for n = 1 : pa.num
        for i = 1 : pa.num
          pa.d0(n, i, 4) = (pa.S4(n,i) * pa.S4(i,n)/(pa.S4(n,n)*pa.S4(i,i))  ).^(-1/(2* pa.theta(4)));
        end
     end



% migration
pa.rho = 2.02; % migration elasticity, by Caliendo Dvorkin Parro 2019
pa.kappa_h = ones(pa.num, pa.num, pa.T+1); % hat change
if counterfactual==0 || counterfactual == 2 
        change = (1.1/100)^(1/100);
        for t = 1:30
            pa.kappa_h(1, 2, t) =  change;
            pa.kappa_h(2, 1, t) =  change;
        end
end
pa.D_H = eye(pa.num);
pa.D_L = [ 0.99 0.01 0 0 0 0;
                0.001 0.999 0 0 0 0;
                0     0      1 0 0 0;
                0     0      0 1 0 0;
                0     0      0 0 1 0;
                0     0      0 0 0 1 ];

% population
pa.L = [ 7.995  ;  1.64 ;  3 ;  2.8  ; 5 ; 5  ]; % t=0 L
pa.H = [ 0.001  ;  0.36 ;  1 ;  1.5 ; 1 ; 1   ];% t=0 H

% capital
pa.k0 = [ 1e-7;  0.09 ; 2.666 ;  2.0032 ;0.6045; 0.7755 ] ; 

y=1;
end
