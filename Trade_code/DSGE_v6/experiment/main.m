%% Trade and Skill premium dynamics in dual economy
% Version 6.2 -- experiment1 right one --- please turn to program under
% file, four-sector-two-labor (v6.3)
% three sectors: agri, low-skill manu, high-skill manu
% two labor: skilled and unskilled labor


%% transition path
tic;
[pa0, state] = parameter(6, 3, 1);
[p0, Q0, fl0] = tran(pa0); 
toc;
plot(1:pa0.T+1, Q0.k);



%% drawer
% drawer(p0, Q0, fl0, pa0 , 0);
% drawer(p2, Q2, fl2, pa2 , 2);
