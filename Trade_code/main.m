%% SC and Skill Premium in CN and US Trade
% --------------------------------- Lijun Zhu, Zhuokai Huang 
% --------------------------------- edited on July 21, 2022


%% Parameters 
para = parameter(5); % 2 countries

%% steady state
display(' ');
display('---------------------------------------------------------------');
display(' steady state');
t1 = tic; % time start 

[ssp, ssQ] = solve_ss(para); 
time = toc(t1);
display('---------------------------------------------------------------');
display( fprintf('Running time is %.3f seconds. \n', time) );
