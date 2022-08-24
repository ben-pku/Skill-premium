function [p,Q] = ss_C(p, para)
%SS_C calculate the corresponding C, consumption
%   calculate by combining 12 formulas  
%  HH's budget constraint
%   F .* Q.C = E

     Q.K = (1-para.alpha1)/para.alpha1 * p.w_l .* para.L ./ p.r;
     Q.C = (p.w_l .* para.L + p.w_h .* para.H + Q.K .*( p.r - para.delta* p.p_m ) ) ./ p.p_c;

    
end

