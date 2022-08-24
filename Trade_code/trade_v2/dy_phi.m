function [element, y] = dy_phi(u, para)
%DY_PHI Calculate the parameter Phi for every economy in every time t
%   Given bundle cost of every country, try to calculate the dynamic parameter Phi (in E-K model)
    
    % matrix
    u = reshape(u, [1, para.num, para.TT]);
    element = ( repmat(u, para.num, 1,1) .* repmat(para.d,1,1, para.TT) ) .^(-para.theta) .* repmat(para.T', para.num, 1, para.TT) ; 
    % phi value
    y = sum(element, 2 );
    y = reshape(y, [para.num, para.TT]);
end

