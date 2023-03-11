%% Trade and Skill premium dynamics in dual economy
% Based on Version 6.2 extension
% 4 sectors: agri, manu, low-skill service, high-skill service
% two labor: skilled and unskilled labor

%% transition path
tic;
[pa0, state] = parameter(6, 4, 0);
[p0, Q0, fl0] = tran(pa0); 
toc;

%% drawer
%drawer(p0, Q0, fl0, pa0 , 0);

