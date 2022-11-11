function y = drawer(p, Q, fl, pa, cf)
%DRAWER 
 % cf -- counterfactual signal

 
f1 = figure(1);
sp = [ p.w_H0(1)/p.w_L0(1) p.w_H(2, :)./p.w_L(2, :) ];
plot(1:pa.T+2, sp );

     xline(30, ':r');
     %xline(70, ':r');

ylabel("Skill premium in China");
xlabel("time");
%legend('CN urban');

f2 = figure(2);
plot(1:pa.T+1, p.R);

     xline(30, ':r');

title("Gross return to capital");
xlabel("time");
legend('CN rural','CN urban','NA');

f3 = figure(3);
plot(1:pa.T+1, Q.k);

     xline(30, ':r');

title("Capital");
xlabel("time");
legend('CN rural','CN urban','NA');

f4 = figure(4);
plot(1: pa.T+1, Q.H);

     xline(30, ':r');

title("Skilled labor");
xlabel("time");
legend('CN rural','CN urban','NA');

f5 = figure(5);
L = [pa.L(1:2) Q.L(1:2, :) ];
plot(1: pa.T+2, L);

     xline(30, ':r');

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

