%% Trade and Skill premium dynamics in dual economy
% Version 6.3 -- prepare for v7 -- now turn to the v6.4 with Euler
% Equation. Indeed v6.3 relies on the simultaneous calibration of k1 and k0
% 4 sectors: agri, manu, low-skill service, high-skill service
% two labor: skilled and unskilled labor

%% transition path
tic;
[pa0, state] = parameter(6, 4, 0);
[p0, Q0, fl0] = tran(pa0); 
toc;
plot(1: pa0.T+1, Q0.k)
