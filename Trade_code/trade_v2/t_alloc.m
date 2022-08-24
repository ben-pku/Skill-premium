function [p, Q] = t_alloc(p, Q, para, ssq, ssQ)
%% T_ALLOC solve the allocation on the transitional path
%   given all price indexes and locus of capital, solve YS_l directly and
%   then, solve other allocations 

     % calculate YS_l   A * YS_l = B
    A = p.p_l / para.gamma2;
    B = (1 - Q.rho) .* ( p.w_l .* para.Lt + p.w_h .* para.Ht + p.r .* Q.K) - p.p_a * para.theta_a - 1/para.gamma2 * para.theta_l * p.p_l + para.theta_h * p.p_h;
    Q.YS_l = B./A;

    % other quantity
    % low skill service
    % 22
    Q.CS_l = Q.YS_l;
    % 15
    Q.H_l = para.beta3* p.p_l .* Q.YS_l ./p.w_h;
    % 14
    Q.L_l = para.alpha3* p.p_l .* Q.YS_l ./p.w_l;
    % 13
    Q.K_l = (1-para.alpha3 - para.beta3)* p.p_l .* Q.YS_l ./ p.r;

    % agriculture
    % 4 5
    Q.YA = para.theta_a + (1-para.gamma1-para.gamma2-para.gamma3)/para.gamma1 * p.p_l ./ p.p_a.*(Q.YS_l + para.theta_l);
    % 8
    Q.L_a = para.alpha1 * Q.YA .* p.p_a ./p.w_l;
    % 19
    Q.CA = Q.YA;
    % 7
    Q.K_a = (1-para.alpha1) * Q.YA .* p.p_a ./ p.r;

    % high skill service 
    % 5 6
    Q.YS_h = para.gamma3/para.gamma2 * p.p_l./p.p_h .* (Q.YS_l + para.theta_l) - para.theta_h;
    % 17
    Q.L_h = para.alpha4* p.p_h .* Q.YS_h ./p.w_l;
    % 18
    Q.H_h = para.beta4* p.p_h .* Q.YS_h ./p.w_h;
    Q.CS_h = Q.YS_h;
    % 16
    Q.K_h = (1 - para.alpha4 - para.beta4) * p.p_h .* Q.YS_h ./p.r;

    % manufacturing 
    % unskilled labor mkt clearing 25
    Q.L_m = para.Lt - Q.L_h - Q.L_l - Q.L_a;
    % 10  11
    Q.H_m = para.beta2/para.alpha2 * p.w_l./p.w_h .* Q.L_m;
    % 10 9
    Q.K_m = (1-para.alpha2-para.beta2) / para.alpha2 * p.w_l .* Q.L_m ./ p.r;
end

