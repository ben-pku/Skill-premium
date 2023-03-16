%% Trade and Skill premium dynamics in dual economy
% Version 7.1 --  adding non-homothetic CES into this model -- asymmetric
% setting : CN rural is just part of CN
% 4 sectors: agri, manu, low-skill service, high-skill service
% two labor: skilled and unskilled labor

%% transition path


tic;
[pa0, state] = para(5, 4, 0);
[p0, Q0, fl0] = tran(pa0); 
toc;
plot(1: pa0.T+1, Q0.k);

save fl0;
save p0;
save pa0;
save Q0;