function [p,Q] = trade_dy_flow(p, Q, para)
%TRADE_DY_FLOW calculate the dynamic trade flow, pi in each time t
%   calculate the trade flow matrix, pi, using the property of EK model --
%   29 formula
     for t = 1: para.TT
         [element, y] = phi(p.u(:, t),  para);
         Q.pi( :, : , t) = element ./ repmat(y, 1, para.num);    
         
     end

    

end

