function [pa, y] = parameter(num , sec, counterfactual)
%PARAMETER get the parameters

pa.num = num; % num of countries
pa.sec = sec; % num of sectors
pa.T = 100;

% production 
pa.mu_K = [0 0.33 0.2 0.4]; % capital share
pa.mu_L = [1 0.57  0.7 0.10]; % unskilled labor share
pa.mu_H = [0 0.10  0.1 0.50]; % skilled labor share
% pa.Te1 = ones(pa.num, 1);
pa.A = 1/2 * ones(pa.num, 1); % agri productivity
pa.Te2 = ones(pa.num,1);
pa.Te3 = ones(pa.num,1);
pa.Te4 = ones(pa.num,1);
pa.delta = 0.25;   % depreciate rate

% agri, manu, L-S, H-S
pa.theta = [6 4 4 6] .* ones(1, pa.sec); % trade elasticity
pa.eta = 2 * ones(1, pa.sec);
% Household
pa.beta = 0.96; % discount factor / year
pa.epsilon = [0.2, 1, 1.01, 1.2];
pa.sigma = 0.5;
pa.Omega = [1 1 1 1] .* ones(1, pa.sec); % Omega
pa.varepsilon_b = 1;

% trade
pa.S2 = [ 0.5   0.20   0.15 0.1 0.05;
                  0.15 0.65  0.1  0.06  0.04;
                  0.17    0.2    0.5   0.1   0.03;
                  0.01  0.09   0.2  0.6   0.1;
                  0.01 0.09 0.05 0.05  0.8 ]; %sector 2  manufacturing
pa.S3 = [0.72 0.1 0.04 0.1  0.04;
               0.1 0.74  0.05   0.1 0.01;
               0.09   0.1   0.70  0.1  0.01;
               0.1   0.1    0.19   0.6   0.01;
               0.01 0.01 0.01    0.17 0.8]; %sector 3 low-skill service
pa.S4 = [0.72 0.1      0.11   0.06      0.01;
                 0.1    0.7      0.05    0.1       0.05;
                 0.05  0.15   0.7     0.15     0.05;
                 0.04  0.04   0.15    0.7       0.07;
                 0.1     0.1      0.1      0.1       0.6]; % sector 4 high-skill service
% trade cost
pa.d0 =   ones(pa.num, pa.num, pa.sec) ; % I-1 * I-1

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
% migration -- we have num+1 areas to migrate :)
pa.rho = 2.02;  % as for Caliendo Parro 2019

% population
pa.L = [ 7.995;   1.64 ;  3 ;  0.5; 0.4;       2 ]; % num+1 *1; 
pa.H = [                0.36 ;  1 ; 0.4; 0.3; 0.001 ]; % num *1

% capital
pa.k0 = [ 0.09 ; 2.6 ; 3 ; 3;  0.1] ; % num *1

y =    1;
end

