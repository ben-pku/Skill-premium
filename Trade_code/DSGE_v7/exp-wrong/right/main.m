%% Trade and Skill premium dynamics in dual economy
% Version 7.03 --  simple asymmetric -- only CN and ROW and then add
% countries into here one by one
% setting : CN rural is just part of CN
% 4 sectors: agri, manu, low-skill service, high-skill service
% two labor: skilled and unskilled labor

%% transition path
tic;
[pa0, state] = parameter(5, 4, 0);
p.r0 = ones(pa0.num ,1);
Q.sigma0 = (1 - pa0.beta)* ones(pa0.num, 1);
[p, Q] = ini_equi(p, Q, pa0, 1);
toc;

