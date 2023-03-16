 function pa = parameter_v6(N, O, J, TT)

% Initial Allocation
pa.l_0 = [10,10,30;
           2, 2,30]'; % initial worker in rural and urban sectors
pa.k_0 = [10,25,40]'; % initial capital stock at t == 0
pa.k_1 = 1.2.*pa.k_0;  % initial capital stock at t == 1
pa.S1_0 = [0.8,0.1,0.1;0.2,0.6,0.2;0.3,0.3,0.4]; % initial trade share in agriculture
pa.S2_0 = [0.6,0.2,0.2;0.3,0.4,0.3;0.2,0.2,0.6]; % initial trade share in manufacturing
pa.S3_0 = [0.4,0.3,0.3;0.1,0.8,0.1;0.1,0.1,0.8]; % initial trade share in service 1
pa.S4_0 = [0.3,0.2,0.5;0.2,0.3,0.5;0.1,0.1,0.8]; % initial trade share in service 2
pa.S_0 = [pa.S1_0,pa.S2_0,pa.S3_0,pa.S4_0];

pa.D_m1 = [[0.85,0.05;0.4,0.4],[0.025,0.025;0.05,0.05],[0.025,0.025;0.05,0.05]; % initial migration share across sector and region
           [0.1,0.1;0.1,0.1],[0.3,0.3;0.3,0.3],[0.1,0.1;0.1,0.1];
           [0.05,0.05;0.05,0.05],[0.05,0.05;0.05,0.05],[0.4,0.4;0.4,0.4]];

% Constant Perameters
pa.xi = 0.4;
pa.Lambda_a = 5;
pa.Lambda_na = 10;
pa.rho = 1;
pa.miu = 0.5;
pa.theta = 4;
pa.phi = 3;
pa.beta = 0.96;
pa.delta = 0.01;
pa.alpha_l = [0.5;0.2;0.2;0.3];
pa.alpha_k = [0.0;0.4;0.2;0.1];
pa.alpha_m1 = [0.2;0.1;0.2;0.1];
pa.alpha_m2 = [0.1;0.1;0.2;0.1];
pa.alpha_m3 = [0.1;0.1;0.1;0.2];
pa.alpha_m4 = [0.1;0.1;0.1;0.2];
pa.alpha_m = [pa.alpha_m1,pa.alpha_m2,pa.alpha_m3,pa.alpha_m4];
pa.gamma1 = 0.4;
pa.gamma2 = 0.3;
pa.gamma3 = 0.3;
pa.gamma = [0.3,0.3,0.2,0.2];
pa.eta_s = [0.2,0.2,0.6]'; % investment share of different industries in structure 
pa.eta_e = [0.1,0.6,0.3]'; % investment share of different industries in equipment
pa.nu = [0.4;0.6]; % investment share of structure and equipment
pa.sigma = 2;


% Changes in Fundamentals

% initial migration cost 
A = [1,2;2,1]; % migration cost across sectors
B = [1,2,2;2,1,2;2,2,1]; % migration cost across regions
pa.kappa_0 = kron(B,A);

% initial trade cost
pa.tau_0 = [1,2,2;2,1,2;2,2,1];

% initial productivity 
pa.z1_0 = [1,1,1]';
pa.z2_0 = [1,1,1]';
pa.z3_0 = [1,1,1]';
pa.z_0 = [pa.z1_0,pa.z2_0,pa.z3_0];

pa.z_hat = ones(N,J,TT+1);
pa.z1_hat = ones(3,TT+1);  
pa.z2_hat = ones(3,TT+1);  
pa.z3_hat = ones(3,TT+1);  
pa.b_hat = ones(3,TT+1);
pa.tau_hat = ones(N,N,TT+1);
pa.kappa_hat = ones(N*O,N*O,TT+1);
pa.kappa_hat_0 = ones(N*O,N*O);

end