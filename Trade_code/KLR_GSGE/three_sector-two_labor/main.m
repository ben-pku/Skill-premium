%% Dynamic Trade in dual economy
% Version 6.2
% three sectors: agri, low-skill manu, high-skill manu
% two labor: skilled and unskilled labor



%% transition path



tic;
[pa0, state] = parameter(6, 3, 0);
[p0, Q0, fl0] = tran(pa0); 
toc;

% 
% % Counterfactual without capital accumulation
[pa2, state] = parameter(6,3, 2);
[p2, Q2, fl2] = tran(pa2);



%% drawer
drawer(p0, Q0, fl0, pa0 , 0);
drawer(p2, Q2, fl2, pa2 , 2);