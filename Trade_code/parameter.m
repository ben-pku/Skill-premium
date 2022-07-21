function [para] = parameter( num )
%PARAMETER give parameters
%   give some parameters to the model

    para.num = num;  % number of countries
    %% agriculture
    para.alpha1 = 0.85;
    para.A_a = [1; 2] .*ones(para.num, 1);

    %% manufacturing
    para.alpha2 = 0.2;
    para.beta2 = 0.2;
    para.v_m = 0.4 * ones( para.num, 1);
    para.eta = 1.5*ones(para.num, 1);  % substitution elasticity of intermediate goods
    para.T = [1; 1] .*ones(para.num, 1);
    para.theta = 1* ones(para.num, 1);  %  variation of technology

    %% Low-skill service
    para.A_l = ones(para.num, 1);
    para.alpha3 = 0.29;
    para.beta3 = 0.01;

    %% High-skill service
    para.A_h = ones(para.num, 1);
    para.alpha4 = 0.05;
    para.beta4 = 0.32;    
    
    %% household
    para.gamma1 = 0.3;
    para.gamma2 = 0.3;
    para.gamma3 = 0.3;
    para.theta_a = 0.3;
    para.theta_l = 0.1;
    para.theta_h = 1;
    
    para.beta = 0.99; % time discount rate
    para.delta = 0.1; % depreciation rate
    
    %% Labor resource
    para.L = [12.6; 2.8];
    para.H = [1.4;  1.2];
    
    %% Iceberg Cost
    para.d = [1  1.25;
                   1.55  1];
    
end

