function [y] = Pm( P_m, p , para)
%PM The equation of P_m
%   we use the equation of P_m to solve the value of P_m
    xi=gamma(1+(1-para.eta)./para.theta).^(1./(1-para.eta));
    xi = repmat(xi, 1, para.TT); % for each t
    v_m = repmat(para.v_m, 1, para.TT); % for each t
     
    u = (p.r ./ ((1-para.alpha2-para.beta2)*v_m)  ).^((1-para.alpha2-para.beta2)*v_m) .*...
            (p.w_l ./ (para.alpha2*v_m) ).^(para.alpha2*v_m ) .*...
            (p.w_h ./(para.beta2*v_m ) ).^(para.beta2*v_m ) .*...
            (P_m ./(1-v_m) ).^(1-v_m) ;  % P_m is present here
    
    % matrix
    u = reshape(u, [1, para.num, para.TT]);
    element = ( repmat(u, para.num, 1,1) .* repmat(para.d,1,1, para.TT) ) .^(-para.theta) .* repmat(para.T', para.num, 1, para.TT) ; 
    % phi value
    phi = sum(element, 2 );
    phi = reshape(phi, [para.num, para.TT]);
    
    y = P_m - xi .* ( phi  .^(-1./repmat(para.theta, 1, para.TT)  ) ); 
end

