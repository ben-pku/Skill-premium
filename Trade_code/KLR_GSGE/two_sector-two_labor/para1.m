function [pa, y] = para1(num , sec, counterfactual)
%PARA1 get the parameters

    pa.num = num; % num of countries
    pa.sec = sec; % num of sectors
    pa.T = 150;
    
    % production
    pa.mu_K = [0.23 0.33];
    pa.mu_L = [0.76  0.37];
    pa.mu_H = [0.01 0.30];
    pa.Te = [0.2 0.5; 0.2 0.5; 0.2 0.5] .* ones(pa.num, pa.sec); % tech
    pa.Te_h1 = ones(pa.num, pa.T+1);
    pa.Te_h2 = ones(pa.num, pa.T+1);
    pa.delta = 0.01;   % depreciate
    pa.theta = 4 * ones(1, pa.sec); % trade elasticity

    % Household
    pa.beta = 0.96; % discount factor / year
    pa.gamma = [0.5 0.5]; % expenditure share
    % landlord
    pa.psi = 3; % IES
    pa.b = 1; % amenity
    pa.b_h = ones(pa.num, pa.T+1);
    
    % trade
    pa.d = 1.5 * ones(pa.num, pa.num); %trade cost
    for i = 1: pa.num
        pa.d(i,i) = 1;
    end
    pa.d_h = ones(pa.num, pa.num, pa.T+1);
    
    %% counterfactual
    % if trade cost be declined by 25% at t = 30
    if counterfactual == 1
        pa.d_h(: , :, 30) = 0.75 *pa.d_h(: , :, 30) ;
        for i = 1: pa.num
            pa.d_h(i,i,:) = 1;
        end
    end
    %%
    
    % initial trade share
    S = 0.8*eye(pa.num);
    temp = (ones(pa.num, pa.num) - eye(pa.num)) * (0.2/(pa.num-1)) ;
    S = temp + S;
    pa.S1 = S; %sector 1
    pa.S2 = S; %sector 2
    
    % migration
    pa.rho = 1;
    pa.kappa0 = 1.1 * ones(pa.num, pa.num); 
                      %migration cost t=0
    for i = 1: pa.num
        pa.kappa0(i,i) = 1;
    end
    pa.kappa_h = ones(pa.num, pa.num,pa.T+1); % hat change
%     pa.kappa = ones(pa.num, pa,num,pa.T); % migration cost 
%     for t = 1: pa.T
%         pa.kappa(:, :, t) = cumprod(pa.kappa_h, 3)(:,:, t) .* pa.kappa0;
%     end
    % migration rate
    pa.D_H = 0.7* eye(pa.num); % D t=0
    temp = (ones(pa.num, pa.num) - eye(pa.num)) * (0.3/(pa.num-1)) ;
    pa.D_H = [ 0.9 0.1 0;
                    0.01 0.99 0;
                    0     0      1];%pa.D_H = temp + pa.D_H;
    
    pa.D_L = 0.7* eye(pa.num); % D t=0
    temp = (ones(pa.num, pa.num) - eye(pa.num)) * (0.3/(pa.num-1)) ;
     pa.D_L = [ 0.95 0.05 0;
                    0.01 0.99 0;
                    0     0      1];%pa.D_L = temp + pa.D_L;
    
    % population
    pa.L = (linspace(6, 2, pa.num))' .* ones(pa.num, 1); % t=0 L
    pa.H = (linspace(0.1 , 0.5, pa.num))' .* ones(pa.num, 1); % t=0 H
    
   
    % capital
    pa.k0 = (linspace(1, 1.5, pa.num))' .* ones(pa.num, 1);
    pa.k1 = (1.02*linspace(1, 1.5, pa.num))' .* ones(pa.num, 1);

    y =    1;
end

