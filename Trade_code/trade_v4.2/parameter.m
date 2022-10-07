function [para] = parameter( num )
%PARAMETER give parameters
%   give some parameters to the model

    para.num = num;  % number of countries
    %% agriculture
    para.alpha1 = 1/3;
    para.A_a = ones(para.num, 1);
    para.phi = 1.4;  % SEI  K-H

    %% manufacturing
    para.alpha2 = 1/2;
    para.rho = 0.8; %SEI KH - L
    para.beta2 = 0.8;
    para.v1 = 1/2;
    
    para.e = 1.5;  % substitution elasticity of intermediate goods
    para.T = [0.6; 0.9] .* ones(para.num, 1);
    para.theta = 4* ones(para.num, 1);  %  trade elasticity para of Frechet Dist

    %% Low-skill service
    para.alpha3 = 0.6; 
    para.beta3 = 0.67;
    para.A_l = 0.8 * ones(para.num, 1);
   

    %% High-skill service
    para.A_h = 1.2 * ones(para.num, 1);
    para.alpha4 = 0.6;
    para.beta4 = 0.8; % share
    
    %% household
    para.beta = 0.96; % time discount rate
    para.delta = 0.1; % depreciation rate
    para.sigma = 0.06; % intertemporary substitution elasticity ISE
    % non homothetic para 
    para.eps_a = 0.99;   % agri
    para.eps_m = 1; % manu
    para.eps_sl = 1.15; % SL
    para.eps_sh = 1.23; % SH
    para.Omega_a = 1;
    para.Omega_m = 1;
    para.Omega_sl = 1;
    para.Omega_sh = 1;
    
     %% Transitional Path         
     % initial quantity
     para.K1 = [0.6;  1.5] .* ones(para.num, 1);
     % whole time range
     para.TT = 250;
     
    %% Labor resource
    para.L = [50; 28];
    para.H = [20;  12];
    para.Lt = repmat(para.L, 1, para.TT) ;
    para.Ht = repmat(para.H, 1, para.TT) ;
    
    %% Iceberg Cost 
    para.d = [1  1.25 ;
                   1.25  1   ];
   


end

