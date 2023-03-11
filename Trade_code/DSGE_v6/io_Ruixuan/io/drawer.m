function y = drawer(p, Q, fl, pa, cf)
%DRAWER 
 % cf -- counterfactual signal

 
f1 = figure(1);
plot(1:pa.T+1, p.w_Hh./p.w_Lh );

     xline(30, ':r');
     %xline(70, ':r');

title("Skill premium");
xlabel("time");
legend('CN rural','CN urban','ROW');

f2 = figure(2);
plot(1:pa.T+1, p.R);

     xline(30, ':r');

title("Gross return to capital");
xlabel("time");
legend('CN rural','CN urban','ROW');

f3 = figure(3);
plot(1:pa.T+1, Q.k);

     xline(30, ':r');

title("Capital");
xlabel("time");
legend('CN rural','CN urban','ROW');

f4 = figure(4);
plot(1: pa.T+1, Q.H);

     xline(30, ':r');

title("Skilled labor");
xlabel("time");
legend('CN rural','CN urban','ROW');

f5 = figure(5);
plot(1: pa.T+1, Q.L);

     xline(30, ':r');

title("Unskilled labor");
xlabel("time");
legend('CN rural','CN urban','ROW');

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

