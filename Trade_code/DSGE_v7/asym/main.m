%% Trade and Skill premium dynamics in dual economy
% version 7.2 
% non-homothetic preference
% 4 sectors: agri, manu, low-skill service, high-skill service
% 2 labor: skilled and unskilled labor

tic;
[pa0, state] = parameter(6, 4, 0);
[p0, Q0, fl0] = tran(pa0); 
toc;

