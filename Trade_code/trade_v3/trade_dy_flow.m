function [p,Q] = trade_dy_flow(p, Q, para)
%TRADE_DY_FLOW calculate the dynamic trade flow, pi in each time t
%   calculate the trade flow matrix, pi, using the property of EK model --
%   29 formula
    
    [element, y] = dy_phi(p.u,  para);
    % solve pi
    y1 = reshape(y, [ para.num, 1, para.TT] );
    Q.pi = element ./ ( repmat(y1, 1, para.num, 1) ) ;

    

end

