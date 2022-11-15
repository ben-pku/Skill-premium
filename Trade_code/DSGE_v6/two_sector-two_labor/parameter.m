function [pa, y] = parameter(num , sec, counterfactual)
%PARAMETER get the parameters

    pa.num = num; % num of countries
    pa.sec = sec; % num of sectors
    pa.T = 200;
    
    % production 
    pa.mu_K = [0.13 0.33]; % capital sharep
    pa.mu_L = [0.8699  0.37]; % unskilled labor share
    pa.mu_H = [0.0001 0.30]; % skilled labor share
    pa.Te = [0.2 0.5; 0.2 0.5; 0.2 0.5] .* ones(pa.num, pa.sec); % technology
    pa.Te_h1 = ones(pa.num, pa.T+1); % technical change in sector 1
    pa.Te_h2 = ones(pa.num, pa.T+1); % technical change in sector 2
    pa.delta = 0.01;   % depreciate rate
    % counterfactual: if without capital accumulation
    if counterfactual == 2  
        pa.delta = 1; 
    end
    
    pa.theta = [6 , 4] .* ones(1, pa.sec); % trade elasticity

    % Household
    pa.beta = 0.96; % discount factor / year
    pa.gamma = [0.2 0.8]; % expenditure share
    % landlord
    pa.psi = 3; % IES
    pa.b = 1; % amenity
    pa.b_h = ones(pa.num, pa.T+1);
    
    % trade
    pa.d = 10 * ones(pa.num, pa.num); %trade cost
    for i = 1: pa.num
        pa.d(i,i) = 1;
    end
    pa.d_h = ones(pa.num, pa.num, pa.T+1);
    
    %% counterfactual
    % if trade cost be declined by 25% at t = 30
    if counterfactual == 0 ||counterfactual == 2 
        change = (1/10)^(1/100);
        for t = 30 : 130
            for i = 1:3
                for j = 1:3
                    pa.d_h(i , j, t) = change ;
                end
            end
        end
        
        for i = 1: pa.num
            pa.d_h(i,i,:) = ones(1,1,pa.T+1);
        end
    end
    
    
    %%
    
    % initial trade share
%     S = 0.8*eye(pa.num);
%     temp = (ones(pa.num, pa.num) - eye(pa.num)) * (0.2/(pa.num-1)) ;
%     S = temp + S;
    pa.S1 = [ 0.8999 0.1 0.0001;
                   0.299 0.7 0.001;
                   0.001 0 0.999]; %sector 1
    pa.S2 = [ 0.3 0.699  0.01;
                   0.185 0.80  0.015;
                   0.0001 0.0099 0.99]; %sector 2
    
    % migration
    pa.rho = 1;
    pa.kappa0 = [ 1 100 999;
                          100 1 999;
                          999 999 1]; %migration cost t=0
    for i = 1: pa.num
        pa.kappa0(i,i) = 1;
    end
    pa.kappa_h = ones(pa.num, pa.num,pa.T+1); % hat change
    if counterfactual==0 || counterfactual == 2 
        change = (4/100)^(1/100);
        for t = 30 : 130
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
    pa.D_H = [ 0.9 0.1 0;
                    0.01 0.99 0;
                    0     0      1];
    
    pa.D_L = [ 0.95 0.05 0;
                    0.01 0.99 0;
                    0     0      1]; % D t=0
%     temp = (ones(pa.num, pa.num) - eye(pa.num)) * (0.3/(pa.num-1)) ;
%     pa.D_L = temp + pa.D_L;
    
    % population
    pa.L = [ 7.93  ;  1.9 ;  40  ]; %(linspace(6, 2, pa.num))' .* ones(pa.num, 1); % t=0 L
    pa.H = [ 0.07  ;  0.1 ;  4 ];%(linspace(0.1 , 0.5, pa.num))' .* ones(pa.num, 1); % t=0 H
    
   
    % capital
    pa.k0 = [ 0.01  ;  5 ; 20 ] ;%(linspace(1, 1.5, pa.num))' .* ones(pa.num, 1);
    pa.k1 = 1.02 * pa.k0;%(1.02*linspace(1, 1.5, pa.num))' .* ones(pa.num, 1);

    y =    1;
end

