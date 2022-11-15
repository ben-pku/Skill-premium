function [pa, y] = parameter(num , sec, counterfactual)
%PARAMETER get the parameters

    pa.num = num; % num of countries
    pa.sec = sec; % num of sectors
    pa.T = 200;
    
    % production 
    pa.mu_K = [0.13 0.33 0.4]; % capital share
    pa.mu_L = [0.87  0.57 0.10]; % unskilled labor share
    pa.mu_H = [0 0.10 0.50]; % skilled labor share
    %pa.Te = [1 0.001 0.001; 0.001 0.5 0.6; 0.5 0.5 0.6] .* ones(pa.num, pa.sec); % technology (useless)
    pa.Te_h1 = ones(pa.num, pa.T+1); % technical change in sector 1
    pa.Te_h2 = ones(pa.num, pa.T+1); % technical change in sector 2
    pa.Te_h3 = ones(pa.num, pa.T+1); % technical change in sector 2
    pa.delta = 0.06;   % depreciate rate
    % counterfactual: if without capital accumulation
    if counterfactual == 2  
        pa.delta = 1; 
    end
    
    pa.theta = [6, 4, 4] .* ones(1, pa.sec); % trade elasticity

    % Household
    pa.beta = 0.96; % discount factor / year
    pa.gamma = [0.2 0.55 0.25]; % expenditure share
    % landlord
    pa.psi = 0.5; % IES
    pa.b = 1; % amenity (useless)
    pa.b_h = ones(pa.num, pa.T+1);
    
    % trade
%     pa.d = 10 * ones(pa.num, pa.num, pa.sec); %trade cost (useless)
%     for j = 1: pa.sec
%         for i = 1: pa.num
%             pa.d(i,i,j) = 1;
%         end
%     end
    pa.d_h = ones(pa.num, pa.num, pa.sec, pa.T+1); 
    
    %% counterfactual
    % if trade costs decline from t=0 to 30
    if counterfactual == 0 ||counterfactual == 2 
%         change1 = (1/10)^(1/30); % domestic trade cost decline
%         for t = 1 : 30
%             for i = 1: 2
%                 for j = 1:2
%                     pa.d_h(i , j, 2:3, t) = change1 ;
%                 end
%             end
%         end
        
        change2 = (1/10)^(1/30); % international trade cost decline
        for t = 1 : 30
                for j = 3 : pa.num   % urban China import cost decline
                    pa.d_h(2 , j, 2, t) = change2 ;
                    pa.d_h(2 , j, 3, t) = change2 ;
                end
                for j = 3 : pa.num  % urban China export cost decline
                    pa.d_h(j, 2, 2, t) = change2 ;
                    pa.d_h(j, 2, 3, t) = change2 ;
                end
        end
        
    end
    
    
    %%
    
    % initial trade share
%     S = 0.8*eye(pa.num);
%     temp = (ones(pa.num, pa.num) - eye(pa.num)) * (0.2/(pa.num-1)) ;
%     S = temp + S;
    pa.S1 = [ 0.85 0 0.06  0.03 0.03 0.03  ;
                  0.82 0.01  0.07  0.03  0.03 0.04;
                  0.001 0 0.799 0.01 0.18 0.01 ;
                  0.0001 0 0.03 0.9 0.03  0.0399  ;
                  0.0001 0 0.0599 0.02 0.9  0.02;
                  0.0001 0 0.0599 0.02  0.02 0.9]; %sector 1 agri
    pa.S2 = [  0.01  0.89  0.025  0.025 0.025 0.025 ;
                   0 0.75 0.075 0.075 0.05 0.05 ;
                   0 0.15 0.7 0.05 0.05 0.05 ;
                   0 0.15 0.1 0.65 0.05 0.05 ;
                   0 0.15 0.1 0.05 0.65 0.05 ;
                   0 0.15 0.1 0.05 0.05 0.65 ]; %sector 2 low-skill manufacturing
    pa.S3 = [ 0.0000001  0.5999999  0.19  0.19 0.01 0.01 ;
                   0 0.4 0.28 0.26 0.03 0.03 ;
                   0 0.004 0.75 0.231 0.005 0.01 ;
                   0 0.004 0.23 0.751 0.005 0.01 ;
                   0 0.004 0.25 0.251 0.65 0.025 ;
                   0 0.004 0.21 0.211 0.025 0.55 ]; %sector 3 high-skill manufacturing
               
    
    % migration
    pa.rho = 2.02;  % as for Caliendo Paroo 2019
%     pa.kappa0 = [ 1 100 999;
%                           100 1 999;
%                           999 999 1]; %migration cost t=0
    for i = 1: pa.num
        pa.kappa0(i,i) = 1;
    end
    pa.kappa_h = ones(pa.num, pa.num,pa.T+1); % hat change
    if counterfactual==0 || counterfactual == 2 
        change = (1.1/100)^(1/100);
        for t = 1:30
            pa.kappa_h(1, 2, t) =  change;
            pa.kappa_h(2, 1, t) =  change;
        end
    end
%     pa.kappa = ones(pa.num, pa,num,pa.T); % migration cost 
%     for t = 1: pa.T
%         pa.kappa(:, :, t) = cumprod(pa.kappa_h, 3)(:,:, t) .* pa.kappa0;
%     end
    % migration rate
%     pa.D_H = 0.7* eye(pa.num); % D t=0
%     temp = (ones(pa.num, pa.num) - eye(pa.num)) * (0.3/(pa.num-1)) ;
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
%     temp = (ones(pa.num, pa.num) - eye(pa.num)) * (0.3/(pa.num-1)) ;
%     pa.D_L = temp + pa.D_L;
    
    % population
    pa.L = [ 7.995  ;  1.64 ;  3 ;  2.8  ; 5 ; 5  ]; %(linspace(6, 2, pa.num))' .* ones(pa.num, 1); % t=0 L
    pa.H = [ 0.005  ;  0.36 ;  1 ;  1.5 ; 1 ; 1   ];%(linspace(0.1 , 0.5, pa.num))' .* ones(pa.num, 1); % t=0 H
    
   
    % capital
    pa.k0 = [ 0.01;  0.09 ; 2.666 ;  2.0032 ;0.6045; 0.7755 ] ; % (linspace(1, 1.5, pa.num))' .* ones(pa.num, 1);
    % 10424/156.4 * (1e-3) * 4
    % 7286.2/156.4*(1e-2)* 4.3
    % 1575.8 / 156.4 *(1e-2)* 6
    % 2021.6 / 156.4 *(1e-2)* 6 
    pa.k1 = [1.01; 1.02; 1.02; 1.02; 1.02; 1.02] .* pa.k0;        % (1.02*linspace(1, 1.5, pa.num))' .* ones(pa.num, 1);

    y =    1;
end

