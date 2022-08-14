%% SC and Skill Premium in CN and US Trade
% --------------------------------- Lijun Zhu, Zhuokai Huang 
% --------------------------------- time stamp is on the github


%% Parameters 
para = parameter(2); % number of countries

%% steady state
display(' ');
display('---------------------------------------------------------------');
display(' steady state');
t1 = tic; % time start 

[ssp, ssQ] = solve_ss(para); 
time1 = toc(t1);
display('---------------------------------------------------------------');
display( fprintf('Running time is %.3f seconds. \n', time1) );


%% Transition Path
para = parameter(2); % number of countries
display(' ');
display('---------------------------------------------------------------');
display(' transition path');
t2 = tic;

[tran_p, tran_Q] = t_invest(para, ssp, ssQ);
time2 = toc(t2);
display('---------------------------------------------------------------');
display( fprintf('Running time is %.3f seconds. \n', time2) );