function [pa, y] = parameter(num , sec, counterfactual)
%PARAMETER get the parameters

pa.num = num; % num of countries
pa.sec = sec; % num of sectors
pa.T = 300;

% production 
pa.mu_K = [0 0.33 0.33 0.4]; % capital share
pa.mu_L = [1 0.57  0.57 0.10]; % unskilled labor share
pa.mu_H = [0 0.10  0.10 0.50]; % skilled labor share
pa.Te1 = ones(pa.num, 1);
pa.Te2 = ones(pa.num,1);
pa.Te3 = ones(pa.num,1);
pa.Te4 = ones(pa.num,1);
pa.Te_h1 = ones(pa.num, pa.T+1); % technical change in sector 1
pa.Te_h2 = ones(pa.num, pa.T+1); % technical change in sector 2
pa.Te_h3 = ones(pa.num, pa.T+1); % technical change in sector 3
pa.Te_h4 = ones(pa.num, pa.T+1); % technical change in sector 4
pa.delta = 0.06;   % depreciate rate

pa.theta = [6, 4, 4, 6] .* ones(1, pa.sec); % trade elasticity
pa.eta = 2 * ones(1, pa.sec);
% Household
pa.beta = 0.96; % discount factor / year
pa.gamma = [0.2 0.55 0.15 0.1]; % expenditure share
% landlord
pa.psi = 0.5; % IES
pa.b = 1; % amenity (useless)
pa.b_h = ones(pa.num, pa.T+1);

% trade
pa.S1 = [ 0.8 0.05 0.06  0.03 0.03 0.03  ;
              0.32 0.51  0.07  0.03  0.03 0.04;
              0.001 0.09 0.709 0.01 0.18 0.01 ;
              0.0001 0.03 0.05 0.85 0.03  0.0399  ;
              0.0001 0.0009 0.059 0.02 0.9  0.02;
              0.0001 0.0009 0.059 0.02  0.02 0.9];  %sector 1 agri
pa.S2 = [  0.01  0.89  0.025  0.025 0.025 0.025 ;
               0.05 0.75 0.07 0.075 0.05 0.05 ;
               0.02 0.15 0.7 0.03 0.05 0.05 ;
               0.02 0.15 0.1 0.65 0.05 0.03 ;
               0.02 0.15 0.1 0.05 0.65 0.03 ;
               0.02 0.15 0.1 0.05 0.05 0.63 ]; %sector 2  manufacturing
pa.S3 = [ 0.0000001  0.5999999  0.19  0.19 0.01 0.01 ;
               0.0001 0.4 0.28 0.26 0.03 0.0299 ;
               0.0001 0.004 0.75 0.2309 0.005 0.01 ;
               0.0001 0.004 0.23 0.751 0.0049 0.01 ;
               0.0001 0.004 0.25 0.2509 0.65 0.025 ;
               0.0001 0.004 0.21 0.2109 0.025 0.55 ]; %sector 3 low-skill service
           

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
pa.d_h = ones(pa.num, pa.num, pa.sec, pa.T+1); 

% migration
pa.rho = 2.02;  % as for Caliendo Paroo 2019

% for i = 1: pa.num
%     pa.kappa0(i,i) = 1;
% end
pa.kappa_h = ones(pa.num, pa.num,pa.T+1); % hat change
pa.D_H = [ 1 0 0 0 0 0;
                     0 1 0 0 0 0;
                     0 0 1 0 0 0;
                     0 0 0 1 0 0;
                     0 0 0 0 1 0;
                     0 0 0 0 0 1];

pa.D_L = [ 0.99 0.01 0 0 0 0;
                    0.001 0.999 0 0 0 0;
                    0     0      1 0 0 0;
                    0     0      0 1 0 0;
                    0     0      0 0 1 0;
                    0     0      0 0 0 1 ]; % D t=0

% population
pa.L = [ 7.995  ;  1.64 ;  3 ;  2.8  ; 5 ; 5  ]; %(linspace(6, 2, pa.num))' .* ones(pa.num, 1); % t=0 L
pa.H = [ 0.005  ;  0.36 ;  1 ;  1.5 ; 1 ; 1   ];%(linspace(0.1 , 0.5, pa.num))' .* ones(pa.num, 1); % t=0 H

% capital
pa.k0 = [ 0.01;  0.09 ; 2.666 ;  2.0032 ;0.6045; 0.7755 ] ; % (linspace(1, 1.5, pa.num))' .* ones(pa.num, 1);
% pa.k1 = [1.01; 1.02; 1.02; 1.02; 1.02; 1.02] .* pa.k0;        % (1.02*linspace(1, 1.5, pa.num))' .* ones(pa.num, 1);

y =    1;
end

