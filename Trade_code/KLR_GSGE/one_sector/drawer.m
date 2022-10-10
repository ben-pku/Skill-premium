function y = drawer(p, Q, fl, pa, cf)
%DRAWER 
 % cf -- counterfactual signal

 
f1 = figure(1);
plot(1:pa.T+1, p.w_h./p.p_h );
 if cf ==1
     xline(30, ':r');
 end
title("Real wage hat");
xlabel("time");

f2 = figure(2);
plot(1:pa.T+1, p.R);
 if cf ==1
     xline(30, ':r');
 end
title("return to capital");
xlabel("time");

f3 = figure(3);
plot(1:pa.T+1, Q.chi);
 if cf ==1
     xline(30, ':r');
 end
title(" capital per person");
xlabel("time");

f4 = figure(4);
plot(1: pa.T+1, Q.l);
 if cf ==1
     xline(30, ':r');
 end
title(" population");
xlabel("time");

if cf == 1
    print(f1, './figure/realwage-c.eps', '-depsc');
    print(f2, './figure/R-c.eps', '-depsc');
    print(f3, './figure/kperson-c.eps', '-depsc');
    print(f4, './figure/pop-c.eps', '-depsc');
else
    print(f1, './figure/realwage.eps', '-depsc');
    print(f2, './figure/R.eps', '-depsc');
    print(f3, './figure/kperson.eps', '-depsc');
    print(f4, './figure/pop.eps', '-depsc');
end

y =1;
end

