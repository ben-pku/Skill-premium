%% Trade and Skill premium dynamics in dual economy
% Version 7.02 --  simple asymmetric -- only CN and ROW
% setting : CN rural is just part of CN
% 4 sectors: agri, manu, low-skill service, high-skill service
% two labor: skilled and unskilled labor

%% transition path
tic;
[pa0, state] = parameter(2, 4, 0);
p.r0 = ones(2 ,1);
Q.k = ones(pa0.num,1);
Q.sigma0 = 1 - pa0.beta;
[p, Q] = ini_equi(p, Q, pa0, 1);
toc;

