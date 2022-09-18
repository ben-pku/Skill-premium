function [para] = parameter( num )
%PARAMETER give parameters
%   give some parameters to the model

    para.num = num;  % number of countries
    %% agriculture
    para.alpha1 = 2/3;
    para.A_a = ones(para.num, 1);
    para.rho = 1.8;

    %% manufacturing
    para.beta2 = 0.8;
    para.tau = 0.8;
    para.phi = 0.6;  % SEI
    para.eta = 0.6;  % SEI
    para.e = 1.5;  % substitution elasticity of intermediate goods
    para.T = [0.6; 0.9] .* ones(para.num, 1);
    para.theta = 4* ones(para.num, 1);  %  trade elasticity

    %% Low-skill service
    para.A_l = 0.8 * ones(para.num, 1);
    para.chi_l = 0.6; % SEI
    para.alpha_l = 0.9; % share

    %% High-skill service
    para.A_h = 1.2 * ones(para.num, 1);
    para.chi_h = 0.6; % SEI
    para.alpha_h = 0.65; % share
    
    %% household
    para.beta = 0.96; % time discount rate
    para.delta = 0.1; % depreciation rate
    para.sigma = 0.06; % intertemporary substitution elasticity ISE
    % non homothetic para 
    para.eps_a = 0.45;   % agri
    para.eps_m = 1; % manu
    para.eps_sl = 1.27; % SL
    para.eps_sh = 1.43; % SH
    para.Omega_a = 1;
    para.Omega_m = 1;
    para.Omega_sl = 1;
    para.Omega_sh = 1;
    
     %% Transitional Path         
     % initial quantity
     para.K1 = [0.6;  1.5] .* ones(para.num, 1);
     % whole time range
     para.TT = 200;
     
    %% Labor resource
    para.L = [5; 2.8];
    para.H = [2;  1.2];
    para.Lt = repmat(para.L, 1, para.TT) ;
    para.Ht = repmat(para.H, 1, para.TT) ;
    
    %% Iceberg Cost 
    para.d = [1  1.25 ;
                   1.25  1   ];
   


end

