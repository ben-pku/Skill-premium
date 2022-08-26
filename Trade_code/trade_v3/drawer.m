function [y] = drawer(p, Q, para)
%DRAWER Draw the figures
%   

%% transition path
    f1 = figure(1);
    
    time = [1: para.TT/2.5];
    
    % skill premium
    subplot(3,2,1);
    p.sp = p.w_h ./ p.w_l -1;
    plot(time, p.sp(1,time) , 'LineWidth', 1);
    hold on
    plot(time, p.sp(2,time) , 'LineWidth', 1);
    title('Skill Premium')  %sp
    ma = max([p.sp(1,:), p.sp(2,:)]);
    mi = min([ p.sp(1,:), p.sp(2,:)]);
    r = ma - mi;
    ylim([mi-r/10  ma+r/10  ]);
    yline(0,'-.','LineWidth',1);
    legend('CN', 'US' );
    
    
    % capital locus
    subplot(3,2,2);
    plot(time, Q.K(1,time) , 'LineWidth', 1);
    hold on
    plot(time, Q.K(2,time) , 'LineWidth', 1);
    title('Capital') 
    ma = max([Q.K(1,:)  , Q.K(2,:)]);
    mi = min( [Q.K(1,:) , Q.K(2,:)] );
    r = ma - mi;
    ylim([mi-r/10  ma+r/10  ]);
    yline(0,'-.','LineWidth',1);
    %legend('CN', 'US' );
    
    
    % agriculture in GDP
    Q.gdp = p.w_l .* para.Lt + p.w_h .* para.Ht + p.r .* Q.K;
    Q.agri = p.p_a .* Q.CA ./ Q.gdp;
    
    subplot(3,2,3);
    plot(time, Q.agri(1,time) , 'LineWidth', 1);
    hold on
    plot(time, Q.agri(2,time), 'LineWidth', 1);
    title('Agriculture in GDP') 
    ma = max([Q.agri(1,:)  , Q.agri(2,:)]);
    mi = min( [Q.agri(1,:)  , Q.agri(2,:)] );
    r = ma - mi;
    ylim([mi-r/10  ma+r/10  ]);
    yline(0,'-.','LineWidth',1);
    %legend('CN', 'US' );
    
    
    % investment rate
    Q.ir = Q.i./Q.gdp;
    subplot(3,2,4);
    plot(time, Q.ir(1,time) , 'LineWidth', 1);
    hold on
    plot(time, Q.ir(2,time) , 'LineWidth', 1);
    title('Investment Rate') 
    ma = max([Q.ir(1,:) , Q.ir(2,:)]);
    mi = min( [Q.ir(1,:) , Q.ir(2,:)] );
    r = ma - mi;
    ylim([mi-r/10  ma+r/10  ]);
    yline(0,'-.','LineWidth',1);
    %legend('CN', 'US' );
    
    % interest rate
    subplot(3,2,5);
    plot(time, p.r(1,time) , 'LineWidth', 1);
    hold on
    plot(time, p.r(2,time) , 'LineWidth', 1);
    title('Interest Rate') 
    ma = max([p.r(1,:)  , p.r(2,:)]);
    mi = min( [p.r(1,:)  , p.r(2,:)] );
    r = ma - mi;
    ylim([mi-r/10  ma+r/10  ]);
    yline(0,'-.','LineWidth',1);
    %legend('CN', 'US' );
    
    
    % consumption
    subplot(3,2,6);
    plot(time,  Q.C(1,time) , 'LineWidth', 1);
    hold on
    plot(time, Q.C(2,time) , 'LineWidth', 1);
    title('Consumption Volume') 
    ma = max([Q.C(1,:)  , Q.C(2,:)]);
    mi = min( [Q.C(1,:)  , Q.C(2,:)] );
    r = ma - mi;
    ylim([mi-r/10  ma+r/10  ]);
    yline(0,'-.','LineWidth',1);
    %legend('CN', 'US' );
    
    
    %% figures for presentation
    time = [1: 30];
    f2 = figure(2);
    
    plot(time, p.sp(1,time) , 'LineWidth', 1);
    hold on
    plot(time, p.sp(2,time) , 'LineWidth', 1);
    title('Skill Premium')  %sp
    ma = max([p.sp(1,:), p.sp(2,:)]);
    mi = min([ p.sp(1,:), p.sp(2,:)]);
    r = ma - mi;
    ylim([mi-r/10  ma+r/10  ]);
    yline(0,'-.','LineWidth',1);
    xlabel('time');
    legend('CN', 'US' );
    
    f3 = figure(3);
    Q.agri = Q.L_a./(para.Lt+para.Ht);
    Q.manu = (Q.L_m + Q.H_m)./(para.Lt+para.Ht);
    Q.S_l = (Q.L_l + Q.H_l)./(para.Lt+para.Ht);
    Q.S_h =  (Q.L_h + Q.H_h)./(para.Lt+para.Ht);
    subplot(1,2,1);
    plot(time, Q.agri(1,time) , 'LineWidth', 1);
    hold on
    plot(time, Q.manu(1,time) , 'LineWidth', 1);
    
    title('Structural Change in China, Employment Share') 
    
%     hold on
%     plot(time, Q.S_l(1,time) , 'LineWidth', 1);
%     hold on
%     plot(time, Q.S_l(2,time), 'LineWidth', 1);
%     hold on
%     plot(time, Q.S_h(1,time) , 'LineWidth', 1);
%     hold on
%     plot(time, Q.S_h(2,time), 'LineWidth', 1);
    
    
%     ma = max([Q.agri(1,:)  , Q.agri(2,:), Q.manu(1,time), Q.manu(2,time)]);
%     mi = min( [Q.agri(1,:)  , Q.agri(2,:), Q.manu(1,time), Q.manu(2,time),] );
%     r = ma - mi;
    ylim([0.27 0.35]);
    %yline(0,'-.','LineWidth',1);
    ax = gca;
    ax.YTickLabel = {};
    legend('CN, Agri', 'CN, Manu' );
    xlabel('time');
    
    subplot(1,2,2);
    plot(time, Q.manu(2,time), 'LineWidth', 1);
    hold on
    plot(time, Q.agri(2,time), 'LineWidth', 1);
    title('US') 
    ylim([0.27 0.35]);
    %yline(0,'-.','LineWidth',1);
    ax = gca;
    ax.YTickLabel = {};
    legend('US, agri', 'US, Manu' );
    xlabel('time');
    
    
    
    % capital and consumption
    Q.k = Q.K ./ (para.Lt+para.Ht);
    Q.c = Q.C ./ (para.Lt+para.Ht);
    f4 = figure(4);
    subplot(2,1, 1);
    plot(time, Q.k(1, time) , 'LineWidth', 1);
    hold on
    plot(time, Q.k(2, time) , 'LineWidth', 1);
    %hold on
    %plot([time; time], Q.c(:, time) , 'LineWidth', 1);
    title('Capital per capita') 
    ma = max(max([Q.k ]));
    mi = min(min([Q.k]));
    r = ma - mi;
    ylim([mi-r/10  ma+r/10  ]);
    yline(0,'-.','LineWidth',1);
    legend('CN', 'US' );
    xlabel('time');
    
    subplot(2,1, 2);
    plot(time, Q.c(1, time) , 'LineWidth', 1);
    hold on
    plot(time, Q.c(2, time) , 'LineWidth', 1);
    %hold on
    %plot([time; time], Q.c(:, time) , 'LineWidth', 1);
    title('Consumption per capita') 
    ma = max(max([Q.c ]));
    mi = min(min([Q.c]));
    r = ma - mi;
    ylim([mi-r/10  ma+r/10  ]);
    yline(0,'-.','LineWidth',1);
    %legend('CN', 'US' );
    xlabel('time');
    
    % some i and r
        % investment rate
    f5 = figure(5);
    subplot(2 ,1,1);
    plot(time, Q.ir(1,time) , 'LineWidth', 1);
    hold on
    plot(time, Q.ir(2,time) , 'LineWidth', 1);
    title('Investment Rate') 
    ma = max([Q.ir(1,:) , Q.ir(2,:)]);
    mi = min( [Q.ir(1,:) , Q.ir(2,:)] );
    r = ma - mi;
    ylim([mi-r/10  ma+r/10  ]);
    yline(0,'-.','LineWidth',1);
    legend('CN', 'US' );
    xlabel('time');
    
    % interest rate
    
    subplot(2,1,2);
    plot(time, p.r(1,time) , 'LineWidth', 1);
    hold on
    plot(time, p.r(2,time) , 'LineWidth', 1);
    title('Interest Rate') 
    ma = max([p.r(1,:)  , p.r(2,:)]);
    mi = min( [p.r(1,:)  , p.r(2,:)] );
    r = ma - mi;
    ylim([mi-r/10  ma+r/10  ]);
    yline(0,'-.','LineWidth',1);
    xlabel('time');
    %legend('CN', 'US' );
    
    
    y = 1;
    
end

