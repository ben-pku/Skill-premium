%% Trade and Skill premium dynamics in dual economy
% version 7 -- symmetric case
% non-homothetic preference
% 4 sectors: agri, manu, low-skill service, high-skill service
% 2 labor: skilled and unskilled labor

tic;
[pa0, state] = parameter(6, 4, 1);
[p0, Q0, fl0] = tran(pa0); 
toc;
drawer(p0, Q0, fl0, pa0, 1);
