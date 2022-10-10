function [pa, y] = parameter(num , counterfactual)
%PARAMETER get the parameters

    pa.num = num;
    pa.T = 100;
    
    % production
    pa.mu = 0.5;
    pa.z = ones(pa.num, 1); % productivity
    pa.z_h = ones(pa.num, pa.T+1);
    pa.delta = 0.01;   % depreciate

    % Household
    pa.beta = 0.96; % discount factor
    pa.psi = 3; % IES
    pa.b = 1; % amenity
    pa.b_h = ones(pa.num, pa.T);
    
    % trade
    pa.theta = 4; % trade e
    pa.tau = 2 * ones(pa.num, pa.num); %trade cost
    for i = 1: pa.num
        pa.tau(i,i) = 1;
    end
    pa.tau_h = ones(pa.num, pa.num, pa.T+1);
    
    %% counterfactual
    % if trade cost be declined by 25% at t = 30
    if counterfactual == 1
        pa.tau_h(: , :, 30) = 0.75 *pa.tau_h(: , :, 30) ;
        for i = 1: pa.num
            pa.tau_h(i,i,:) = 1;
        end
    end
    %%
    
    % initial trade share
    pa.S = 0.8*eye(pa.num);
    temp = (ones(pa.num, pa.num) - eye(pa.num)) * (0.2/(pa.num-1)) ;
    pa.S = temp + pa.S;
    
    % migration
    pa.rho = 1;
    pa.kappa0 = 1.1 * ones(pa.num, pa.num); %migration cost t=0
    for i = 1: pa.num
        pa.kappa0(i,i) = 1;
    end
    pa.kappa_h = ones(pa.num, pa.num,pa.T+1); % hat change
%     pa.kappa = ones(pa.num, pa,num,pa.T); % migration cost 
%     for t = 1: pa.T
%         pa.kappa(:, :, t) = cumprod(pa.kappa_h, 3)(:,:, t) .* pa.kappa0;
%     end
    % migration rate
    pa.D = 0.7* eye(pa.num); % D t=0
    temp = (ones(pa.num, pa.num) - eye(pa.num)) * (0.3/(pa.num-1)) ;
    pa.D = temp + pa.D;
    
    % population
    pa.l = (linspace(6, 2, pa.num))' .* ones(pa.num, 1); % t=0
    
   
    % capital
    pa.k0 = (linspace(1, 1.5, pa.num))' .* ones(pa.num, 1);
    pa.k1 = (1.02*linspace(1, 1.5, pa.num))' .* ones(pa.num, 1);

    y =    1;
end

