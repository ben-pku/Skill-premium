function y = drawer(p, Q, fl, pa, cf)
%DRAWER 
 % cf -- counterfactual signal

 
f1 = figure(1);
% patch( 'Faces',  [1 2 3 4] , 'Vertices' ,[0 0; 0 10; 30 10; 30 0], 'FaceAlpha', .7, 'FaceColor', [0.96078 0.96078 0.96078 ],...
%     'LineStyle', 'none') ;
% hold on
sp = [ p.w_H(2, :)./p.w_L(2, :) ];
plot(1:pa.T+1, sp );

     %xline(70, ':r');
% txt = 'China Opening';
% text( 8,8, txt  );
xlim([0 50]);
ylabel("Skill premium in China");
xlabel("time");
legend('China Opening');

f2 = figure(2);
plot(1:pa.T+1, p.R);

     xline(30, ':r');

title("Gross return to capital");
xlabel("time");
legend('CN rural','CN urban','NA');

f3 = figure(3);
% patch( 'Faces',  [1 2 3 4] , 'Vertices' ,[0 0; 0 2; 30 2; 30 0], 'FaceAlpha', .7, 'FaceColor', [0.96078 0.96078 0.96078 ],...
%     'LineStyle', 'none') ;
% hold on
k = [ Q.k(1,:) ;Q.k(2,:) ];
plot(1:pa.T+1, k);

%      xline(30, ':r');
xlim([0 50]);
ylabel("Capital");
xlabel("time");
legend('CN rural','CN urban');

f4 = figure(4);
plot(1: pa.T+1, Q.H);

xline(30, ':r');


title("Skilled labor");
xlabel("time");
legend('CN rural','CN urban','NA');

f5 = figure(5);
% patch( 'Faces',  [1 2 3 4] , 'Vertices' ,[0 0; 0 10; 30 10; 30 0], 'FaceAlpha', .7, 'FaceColor', [0.96078 0.96078 0.96078 ],...
%     'LineStyle', 'none') ;
% hold on
L = [ Q.L(1:2, :) ];
plot(1: pa.T+1, L);
     %xline(70, ':r');
% txt = 'China Opening';
% text( 8,8, txt  );
xlim([0 50]);
ylabel("Unskilled labor");
xlabel("time");
legend('CN rural','CN urban');

if cf ==0
    print(f1, './figure/skillpremium.eps', '-depsc');
    print(f2, './figure/R.eps', '-depsc');
    print(f3, './figure/k.eps', '-depsc');
    print(f4, './figure/H.eps', '-depsc');
    print(f5, './figure/L.eps', '-depsc');
elseif cf==2
    print(f1, './figure/skillpremium-c.eps', '-depsc');
    print(f2, './figure/R-c.eps', '-depsc');
    print(f3, './figure/k-c.eps', '-depsc');
    print(f4, './figure/H-c.eps', '-depsc');
    print(f5, './figure/L-c.eps', '-depsc');
end

y =1;
end

