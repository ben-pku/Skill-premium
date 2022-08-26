%% SC and Skill Premium in CN and US Trade  -- Version 3
% --------------------------------- Lijun Zhu, Zhuokai Huang 
% --------------------------------- time stamp is on the github
% using extend method to solve the whole locus of capital


%% Parameters 
para = parameter(2); % number of countries

%% steady state
disp(' ');
disp('---------------------------------------------------------------');
disp('Solve steady state');
t3 = tic;

[ssp, ssQ] = solve_ss(para);
time3 = toc(t3);
disp('---------------------------------------------------------------');
fprintf('Running time is %.3f seconds. \n', time3);


%% Transition Path
para = parameter(2); % number of countries
disp(' ');
disp('---------------------------------------------------------------');
disp('Solve transition path');
t2 = tic;

[tran_p, tran_Q] = t_path(para, ssp, ssQ);
time2 = toc(t2);
disp('---------------------------------------------------------------');
fprintf('Running time is %.3f seconds. \n', time2) ;

save('v3');

%% Drawer
drawer( tran_p, tran_Q, para );

