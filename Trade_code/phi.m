function [element, y] = phi(u, para)
%PHI Calculate the parameter Phi for every economy
%   Given bundle cost of every country, try to calculate the parameter Phi (in E-K model)
    
    % matrix
    element = ( repmat(u', para.num, 1) .* para.d ) .^(-para.theta) .* repmat(para.T', para.num, 1) ; 
    % phi value
    y = sum(element, 2 );
end

