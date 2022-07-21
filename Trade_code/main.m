%% SC and Skill Premium in CN and US Trade
% --------------------------------- Lijun Zhu, Zhuokai Huang 
% --------------------------------- edited on July 21, 2022


%% Parameters 
para = parameter(2); % 2 countries

%% steady state
display(' ');
display('---------------------------------------------------------------');
display(' steady state');
t1 = tic; % time start nb

[ssp, ssQ] = solve_ss(para); 
time = toc(t1);
display('---------------------------------------------------------------');
display( fprintf('Running time is %.3f seconds. \n', time) );
