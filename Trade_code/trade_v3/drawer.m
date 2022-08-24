function [y] = drawer(p, Q, para)
%DRAWER Draw the figures
%   

%% transition path
    f1 = figure(1);
    
    % skill premium
    subplot(3,2,1);
    plot([1: para.TT], p.w_h(1,:)./p.w_l(1,:) , 'LineWidth', 1);
    hold on
    plot([1: para.TT], p.w_h(2,:)./p.w_l(2,:) , 'LineWidth', 1);
    title('Skill Premium')  %sp
    ma = max([p.w_h(1,:)./p.w_l(1,:) , p.w_h(2,:)./p.w_l(2,:)]);
    mi = min([ p.w_h(1,:)./p.w_l(1,:) , p.w_h(2,:)./p.w_l(2,:)]);
    r = ma - mi;
    ylim([mi-r/10  ma+r/10  ]);
    yline(0,'-.','LineWidth',1);
    legend('1', '2' );
    
    
    % capital locus
    subplot(3,2,2);
    plot([1: para.TT], Q.K(1,:) , 'LineWidth', 1);
    hold on
    plot([1: para.TT], Q.K(2,:) , 'LineWidth', 1);
    title('Capital') 
    ma = max([Q.K(1,:)  , Q.K(2,:)]);
    mi = min( [Q.K(1,:) , Q.K(2,:)] );
    r = ma - mi;
    ylim([mi-r/10  ma+r/10  ]);
    yline(0,'-.','LineWidth',1);
    legend('1', '2' );
    
    
    % GDP
    Q.gdp = p.w_l .* para.Lt + p.w_h .* para.Ht + p.r .* Q.K;
    
    subplot(3,2,3);
    plot([1: para.TT], Q.gdp(1,:) , 'LineWidth', 1);
    hold on
    plot([1: para.TT], Q.gdp(2,:), 'LineWidth', 1);
    title('GDP') 
    ma = max([Q.gdp(1,:)  , Q.gdp(2,:)]);
    mi = min( [Q.gdp(1,:)  , Q.gdp(2,:)] );
    r = ma - mi;
    ylim([mi-r/10  ma+r/10  ]);
    yline(0,'-.','LineWidth',1);
    legend('1', '2' );
    
    
    % investment rate
    Q.ir = Q.i./Q.gdp;
    subplot(3,2,4);
    plot([1: para.TT], Q.ir(1,:) , 'LineWidth', 1);
    hold on
    plot([1: para.TT], Q.ir(2,:) , 'LineWidth', 1);
    title('Investment Rate') 
    ma = max([Q.ir(1,:) , Q.ir(2,:)]);
    mi = min( [Q.ir(1,:) , Q.ir(2,:)] );
    r = ma - mi;
    ylim([mi-r/10  ma+r/10  ]);
    yline(0,'-.','LineWidth',1);
    legend('1', '2' );
    
    % interest rate
    subplot(3,2,5);
    plot([1: para.TT], p.r(1,:) , 'LineWidth', 1);
    hold on
    plot([1: para.TT], p.r(2,:) , 'LineWidth', 1);
    title('Interest Rate') 
    ma = max([p.r(1,:)  , p.r(2,:)]);
    mi = min( [p.r(1,:)  , p.r(2,:)] );
    r = ma - mi;
    ylim([mi-r/10  ma+r/10  ]);
    yline(0,'-.','LineWidth',1);
    legend('1', '2' );
    
    
    % consumption
    subplot(3,2,6);
    plot([1: para.TT],  Q.C(1,:) , 'LineWidth', 1);
    hold on
    plot([1: para.TT], Q.C(2,:) , 'LineWidth', 1);
    title('Consumption Volume') 
    ma = max([Q.C(1,:)  , Q.C(2,:)]);
    mi = min( [Q.C(1,:)  , Q.C(2,:)] );
    r = ma - mi;
    ylim([mi-r/10  ma+r/10  ]);
    yline(0,'-.','LineWidth',1);
    legend('1', '2' );    
    
    
    y = 1;
    
end

