%% Lewis faded away, skill premium surged up
% Version 6.1
% two sector, two labor



%% transition path

% tic;
% [pa0, state] = parameter(3, 2, 0);
% [p0, Q0, fl0] = tran(pa0); 
% toc;


% Counterfactual without capital accumulation
[pa2, state] = parameter(3,2, 2);
[p2, Q2, fl2] = tran(pa2);



%% drawer
%drawer(p0, Q0, fl0, pa0 , 0);
drawer(p2, Q2, fl2, pa2 , 2);
