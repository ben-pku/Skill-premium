function [p,Q] = trade_flow(p, Q, para)
%TRADE_FLOW calculate the trade flow, pi
%   calculate the trade flow matrix, pi, using the property of EK model --
%   29 formula
     
    [element, y] = phi(p.u,  para);
    Q.pi = element ./ repmat(y, 1, para.num);
    
    

end

