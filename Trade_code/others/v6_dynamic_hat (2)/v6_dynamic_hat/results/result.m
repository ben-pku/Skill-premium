
clear
load('..\results\results_v6.mat')

GDP = NaN(3,301);
POP = NaN(3,301);
GDPPC = NaN(3,301);
for tt = (1:301)

    wl = w_o(:,1,tt) .* L(:,1,tt) + w_o(:,2,tt) .* L(:,2,tt);
    rk = r_u(:,tt) .* K(:,tt);

    GDP(:,tt) = wl + rk;
    POP(:,tt) = sum(L(:,1,tt),2);
    GDPPC(:,tt) = GDP(:,tt)./POP(:,tt);

end

plot(GDPPC(:,1:50)')

