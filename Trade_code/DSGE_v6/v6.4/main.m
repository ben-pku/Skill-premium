%% Trade and Skill premium dynamics in dual economy
% Version 6.4 -- prepare for v7 -- apply Euler equation without k1 method
% -- please turn to v7.0 which adds non-homothetic CES into this model
% 4 sectors: agri, manu, low-skill service, high-skill service
% two labor: skilled and unskilled labor

%% transition path
tic;
[pa0, state] = parameter(6, 4, 0);
[p0, Q0, fl0] = tran(pa0); 
toc;
plot(1: pa0.T+1, Q0.k)
save fl0;
save p0;
save Q0;
save pa0;
