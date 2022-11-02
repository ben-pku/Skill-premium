%% KLR Dynamic Spatial GE 
% Version 6.1
% two sector, two labor



%% transition path
[pa1, state] = parameter(3, 2, 0);
[p1, Q1, fl1] = tran(pa1); 

% Counterfactual
[pa2, state] = parameter(5, 1);
[p2, Q2, fl2] = tran(pa2); 


%% drawer
drawer(p1, Q1, fl1, pa1 , 0);
drawer(p2, Q2, fl2, pa2,  1);