%% SC and Skill Premium in CN and US Trade
% --------------------------------- Lijun Zhu, Zhuokai Huang 
% --------------------------------- time stamp is on the github


%% Parameters 
para = parameter(2); % number of countries

% %% steady state
% display(' ');
% display('---------------------------------------------------------------');
% display(' steady state');
% t1 = tic; % time start 
% 
% [ssp, ssQ] = solve_ss(para); 
% time1 = toc(t1);
% display('---------------------------------------------------------------');
% fprintf('Running time is %.3f seconds. \n', time1) ;

%% steady state -- algorithm 2.0
disp(' ');
disp('---------------------------------------------------------------');
disp('steady state algorithm 2.0');
t3 = tic;

[ssp, ssQ] = solve_ss2(para);
time3 = toc(t3);
disp('---------------------------------------------------------------');
fprintf('Running time is %.3f seconds. \n', time3);


%% Transition Path -- algorithm 2.0
para = parameter(2); % number of countries
disp(' ');
disp('---------------------------------------------------------------');
disp(' transition path algorithm 2.0');
t2 = tic;

[tran_p, tran_Q] = t_path(para, ssp, ssQ);
time2 = toc(t2);
disp('---------------------------------------------------------------');
fprintf('Running time is %.3f seconds. \n', time2) ;