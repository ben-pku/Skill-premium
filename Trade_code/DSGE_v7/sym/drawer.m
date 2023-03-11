function y = drawer(p, Q, fl, pa, cf)
%DRAWER 
 % cf -- counterfactual signal

 
f1 = figure(1);
sp = p.w_H(:, :)./p.w_L(:, :) ;
plot(1:pa.T+1, sp );

ylabel("Skill premium in China");
xlabel("time");




f3 = figure(3);


plot(1:pa.T+1, Q.k);

ylabel("Capital");
xlabel("time");




f5 = figure(5);


plot(1: pa.T+1, Q.L);

ylabel("Unskilled labor");
xlabel("time");

f5 = figure(6);
plot(1: pa.T+1, Q.H);
ylabel("Skilled labor");
xlabel("time");


y =1;
end

