function [p, Q, fl] = t_hat(p, Q, fl, t, pa)
%T_HAT 
% given changes in fundamentals, p and Q at t-1, guessed factor prices
% solve p, p_h, S
% output
% p_h

% unit cost
p.uc_h1(:, t) =  p.w_Lh(:, t);
p.uc_h2(:, t) = p.r_h(:, t).^pa.mu_K(2) .* p.w_Lh(:, t).^pa.mu_L(2) .* p.w_Hh(:, t).^pa.mu_H(2);
p.uc_h3(:, t) = p.r_h(:, t).^pa.mu_K(3) .* p.w_Lh(:, t).^pa.mu_L(3) .* p.w_Hh(:, t).^pa.mu_H(3);
p.uc_h4(:, t) = p.r_h(:, t).^pa.mu_K(4) .* p.w_Lh(:, t).^pa.mu_L(4) .* p.w_Hh(:, t).^pa.mu_H(4);

% sector goods price, trade flow  
%!!!!!!! i think I have to edit here, how to solve the trade share in region 1(the same as region 2)
if t==1

    numer2 = pa.S2 .* repmat( (pa.Te_h2(:,t))', pa.num, 1 ) .* ...
        ( repmat(p.uc_h2(:,t)', pa.num, 1  ) .* pa.d_h(:,:,1,t)   ) .^(-pa.theta(2)) ;
    numer3 = pa.S3 .* repmat( (pa.Te_h3(:,t))', pa.num, 1 ) .* ...
        ( repmat(p.uc_h3(:,t)', pa.num, 1  ) .* pa.d_h(:,:,1,t)   ) .^(-pa.theta(3)) ;
    numer4 = pa.S4 .* repmat( (pa.Te_h4(:,t))', pa.num, 1 ) .* ...
        ( repmat(p.uc_h4(:,t)', pa.num, 1  ) .* pa.d_h(:,:,1,t)   ) .^(-pa.theta(4)) ;
else

    numer2 = fl.S2(:,:,t-1)  .* repmat( (pa.Te_h2(:,t))', pa.num, 1 ) .* ...
        ( repmat(p.uc_h2(:,t)', pa.num, 1  ) .* pa.d_h(:,:,1,t)   ) .^(-pa.theta(2)) ;
    numer3 = fl.S3(:,:,t-1)  .* repmat( (pa.Te_h3(:,t))', pa.num, 1 ) .* ...
        ( repmat(p.uc_h3(:,t)', pa.num, 1  ) .* pa.d_h(:,:,1,t)   ) .^(-pa.theta(3)) ;
    numer4 = fl.S4(:,:,t-1)  .* repmat( (pa.Te_h4(:,t))', pa.num, 1 ) .* ...
        ( repmat(p.uc_h4(:,t)', pa.num, 1  ) .* pa.d_h(:,:,1,t)   ) .^(-pa.theta(4)) ;
end

p.p_h1(:, t) = p.uc_h1(:, t) ./ pa.A_h(:, t);
p.p_h2(:, t) = sum( numer2, 2 ) .^ (-1/pa.theta(2));
fl.S2(:, :, t) = numer2 ./ (p.p_h2(:, t).^(-pa.theta(2)));
p.p_h3(:, t) = sum( numer3, 2 ) .^ (-1/pa.theta(3));
fl.S3(:, :, t) = numer3 ./ (p.p_h3(:, t).^(-pa.theta(3)));
p.p_h4(:, t) = sum( numer4, 2 ) .^ (-1/pa.theta(4));
fl.S4(:, :, t) = numer4 ./ (p.p_h4(:, t).^(-pa.theta(4)));

end

