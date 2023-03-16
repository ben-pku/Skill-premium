%% Trade and Skill premium dynamics in dual economy
% Version 7.01 --  change agri trade mat into sth containing 0 -- not
% applicable
% 4 sectors: agri, manu, low-skill service, high-skill service
% two labor: skilled and unskilled labor

%% transition path
tic;
[pa0, state] = parameter(6, 4, 0);
[p0, Q0, fl0] = tran(pa0); 
toc;
plot(1: pa0.T+1, Q0.k);
