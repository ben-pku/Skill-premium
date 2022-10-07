function [pa, y] = parameter(num)
%PARAMETER get the parameters

    pa.num = num;
    pa.T = 200;
    
    % production
    pa.mu = 0.5;
    pa.z = ones(pa.num, 1); % productivity
    pa.z_h = ones(pa.num, pa.T);
    pa.delta = 0.01;   % depreciate

    % Household
    pa.beta = 0.96; % discount factor
    pa.psi = 3; % EoS
    pa.b = 1; % amenity
    pa.b_h = ones(pa.num, pa.T);
    
    % trade
    pa.theta = 4; % trade e
    pa.tau = 1.1 * ones(pa.num, pa.num); %trade cost
    for i = 1: pa.num
        pa.tau(i,i) = 1;
    end
    pa.tau_h = ones(pa.num, pa,num, pa.T);
    % initial trade share
    pa.S = eye(pa.num);
    
    % migration
    pa.rho = 1;
    pa.kappa = 1.1 * ones(pa.num, pa.num); %migration cost
    for i = 1: pa.num
        pa.kappa(i,i) = 1;
    end
    pa.kappa_h = ones(pa.num, pa,num,pa.T);
    % migration rate
    pa.D = eye(pa.num);
    
    % population
    pa.l = (linspace(6, 2, para.num))'*ones(pa.num, 1);
    
   
    % capital
    pa.k0 = (linspace(1, 1.5, para.num))' .* ones(pa.num, 1);
    pa.k1 = (linspace(1, 1.5, para.num))' .* ones(pa.num, 1);

    y =    1;
end

