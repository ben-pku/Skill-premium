function [p, Q, fl] = temp_e(p, Q, fl, t, pa)
%% TEMP_E solve temporary equilibrium
%   semi dynamic exact-hat algebra, given t-1 solve t

dif = 10;
tol = 1e-8;
maxit = 1e4;
for iter = 1: maxit
    if dif < tol
        break;
    end

    % b solve change in prices and trade flow
    [p, Q, fl] = t_hat(p, Q, fl, t, pa);

    % update prices
    if t==1
        p.w_H(:, t) = p.w_H0 .* p.w_Hh(:, t);
        p.w_L(:, t) = p.w_L0 .* p.w_Lh(:, t);
        p.r(:, t) = p.r0 .* p.r_h(:, t);

        p.p1(:, t) = p.p1_0 .* p.p_h1(:, t);
        p.p2(:, t) = p.p2_0 .* p.p_h2(:, t);
        p.p3(:, t) = p.p3_0 .* p.p_h3(:, t);
        p.p4(:, t) = p.p4_0 .* p.p_h4(:, t);
    else
        p.w_H(:, t) = p.w_H(:, t-1) .* p.w_Hh(:, t);
        p.w_L(:, t) = p.w_L(:, t-1) .* p.w_Lh(:, t);
        p.r(:, t) = p.r(:, t-1) .* p.r_h(:, t);

        p.p1(:, t) = p.p1(:, t-1) .* p.p_h1(:, t);
        p.p2(:, t) = p.p2(:, t-1) .* p.p_h2(:, t);
        p.p3(:, t) = p.p3(:, t-1) .* p.p_h3(:, t);
        p.p4(:, t) = p.p4(:, t-1) .* p.p_h4(:, t);
    end

%    % update R(t)
%    if t == 1
%         p.R(:, t) = 1 - pa.delta + p.r_h(: , t) ./ ( p.p_h1(:,t).^pa.gamma(1) .*  p.p_h2(:,t).^pa.gamma(2) .*  p.p_h3(:,t).^pa.gamma(3) ) .* ( p.R0 -1+pa.delta);
%     else
%         p.R(:, t) = 1 - pa.delta + p.r_h(: , t) ./ ( p.p_h1(:,t).^pa.gamma(1) .*  p.p_h2(:,t).^pa.gamma(2) .*  p.p_h3(:,t).^pa.gamma(3) ) .* ( p.R(:, t-1 ) -1+pa.delta);
%    end

   %  expenditure share: country * sec
    Q.oL(:, :, t) = share( pa); % low worker
    Q.oH(:, :, t) = share( pa); % high worker
    Q.oK(:, :, t) = share( pa); % landlord

    % e update new factor prices
     new = factor( p, Q, fl, t, pa);

          % successful codes:
    vfactor = -0.05;
    zw1 = p.w_Hh(: , t) - new.w_Hh;
    zw2 = p.w_Lh(: , t) - new.w_Lh ;
    zw3 = p.r_h(:, t) - new.r_h  ;
    adj1 = p.w_Hh(:, t) .*( 1+ vfactor*zw1./  p.w_Hh(:, t)  );
    adj2 = p.w_Lh(:, t) .*( 1+ vfactor*zw2./  p.w_Lh(:, t)  );
    adj3 = p.r_h(:, t) .*( 1+ vfactor*zw3./  p.r_h(:, t)  );
    dif1 = p.w_Hh(:, t) - adj1;
    dif2 = p.w_Lh(:, t) - adj2;
    dif3 = p.r_h(:, t) - adj3;
    dif = sum(([dif1; dif2; dif3 ]).^2) ;
    p.w_Hh(:, t) =adj1; % (1-smooth) * p.w_Hh(:, t) + smooth * new.w_Hh(:, t);
    p.w_Lh(:, t) =adj2; %(1-smooth) * p.w_Lh(:, t) + smooth * new.w_Lh(:, t);
    p.r_h(:, t) = adj3; %(1-smooth) * p.r_h(:, t) + smooth * new.r_h(:, t);

end

% g solve the k t+1
% if t < pa.T+1
%     Q.k(:, t+1) = (1 - Q.sigma(:, t)) .* p.R(:, t) .* Q.k(:, t);
% end

% update R(t)
if t == 1
    p.R(:, t) = 1 - pa.delta + p.r_h(: , t) ./ ( p.p_h1(:,t).^pa.gamma(1) .*  p.p_h2(:,t).^pa.gamma(2) .*  p.p_h3(:,t).^pa.gamma(3).*  p.p_h4(:,t).^pa.gamma(4) ) .* ( p.R0 -1+pa.delta);
else
    p.R(:, t) = 1 - pa.delta + p.r_h(: , t) ./ ( p.p_h1(:,t).^pa.gamma(1) .*  p.p_h2(:,t).^pa.gamma(2) .*  p.p_h3(:,t).^pa.gamma(3).*  p.p_h4(:,t).^pa.gamma(4)  ) .* ( p.R(:, t-1 ) -1+pa.delta);
end
 if t < pa.T+1
    Q.k(:, t+1) = (1 - Q.sigma(:, t)) .* p.R(:, t) .* Q.k(:, t);
 end
end

