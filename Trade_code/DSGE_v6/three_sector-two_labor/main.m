%% Trade and Skill premium dynamics in dual economy
% Version 6.2
% three sectors: agri, low-skill manu, high-skill manu
% two labor: skilled and unskilled labor



%% transition path



tic;
[pa0, state] = parameter(6, 3, 1);
[p0, Q0, fl0] = tran(pa0); 
toc;

%% drawer
drawer(p0, Q0, fl0, pa0 , 0);
% 
% % Counterfactual without capital accumulation
% [pa2, state] = parameter(6,3, 2);
% [p2, Q2, fl2] = tran(pa2);

save pa0; 
save p0;
save Q0;
save fl0;


%% drawer
drawer(p0, Q0, fl0, pa0 , 0);
% drawer(p2, Q2, fl2, pa2 , 2);

%% output data
t = (1:50)';
k1 = Q0.k(1,1:50)';
k2 = Q0.k(2,1:50)';
sp = ( p0.w_H(2, 1:50) ./ p0.w_L(2, 1:50) )';
L1 = Q0.L(1, 1:50)';
L2 = Q0.L(2, 1:50)';
table0 = table(t, k1,k2,sp,L1,L2  ); 
writetable(table0, 'v6-1.csv');