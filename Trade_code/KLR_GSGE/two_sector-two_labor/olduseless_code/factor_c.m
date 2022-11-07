function [p, Q, fl] = factor_c(p, Q, fl, t , pa)
%FACTOR_C factor market clearing conditions
% capital k, skilled labor H, unskilled labor L

% guess the three prices first

% by iteration 
    iter = 0;
    dif = 10;
    tol = 1e-5;
    
    while dif > tol
        iter = iter +1;
        
        % 5 a 
        [p, Q, fl] = t_hat(p, Q, fl, t , pa);
        % 5 b
        if t ==1  % use the initial factor prices
            p.w_H( : , t)= p.w_Hh( : , t) .* p.w_H0;
            p.w_L( : , t)= p.w_Lh( : , t) .* p.w_L0;  
            p.r( : , t) = p.r_h( : , t) .* p.r0;

        else
            p.w_H( : , t)= p.w_Hh( : , t) .* p.w_H( : , t-1);
            p.w_L( : , t)= p.w_Lh( : , t) .* p.w_L( : , t-1);
            p.r( : , t) = p.r_h( : , t) .* p.r( : , t-1);
        end

        X1 = pa.gamma(1,1) * ( p.w_H(:, t).*Q.H(:,t) + p.w_L(:, t) .* Q.L(:, t) + p.r(:, t).* Q.k(:, t)) ;
        X2 = pa.gamma(1,2) * ( p.w_H(:, t).*Q.H(:,t) + p.w_L(:, t) .* Q.L(:, t) + p.r(:, t).* Q.k(:, t)) ;

        if t == 1
            nw_Hh = ( pa.mu_H(1,1) * ( sum( fl.S1(:,:, t) .* repmat(X1,1, pa.num), 1 ))'  + ...
                pa.mu_H(1,2) * ( sum( fl.S2(:,:, t) .* repmat(X2, 1, pa.num) , 1  ))' ) ...
                ./ (Q.H(:,t) .* p.w_H0);

            nw_Lh = ( pa.mu_L(1,1) * ( sum( fl.S1(:,:, t) .* repmat(X1,1, pa.num), 1 ))'  + ...
                pa.mu_L(1,2) * ( sum( fl.S2(:,:, t) .* repmat(X2, 1, pa.num) , 1  ))' ) ...
                ./ (Q.L(:,t) .* p.w_L0);

            nr_h = ( pa.mu_K(1,1) * ( sum( fl.S1(:,:, t)  .* repmat(X1,1, pa.num), 1 ))'  + ...
                pa.mu_K(1,2) * ( sum( fl.S2(:,:, t) .* repmat(X2, 1, pa.num) , 1  ))' ) ...
                ./ (pa.k0 .* p.r0 );            
        else
            nw_Hh = ( pa.mu_H(1,1) * ( sum( fl.S1(:,:, t) .* repmat(X1,1, pa.num), 1 ))'  + ...
                pa.mu_H(1,2) * ( sum( fl.S2(:,:, t) .* repmat(X2, 1, pa.num) , 1  ))' ) ...
                ./ (Q.H(:,t) .* p.w_H(: , t-1));

            nw_Lh = ( pa.mu_L(1,1) * ( sum( fl.S1(:,:, t) .* repmat(X1,1, pa.num), 1 ))'  + ...
                pa.mu_L(1,2) * ( sum( fl.S2(:,:, t) .* repmat(X2, 1, pa.num) , 1  ))' ) ...
                ./ (Q.L(:,t) .* p.w_L(: , t-1));

            nr_h = ( pa.mu_K(1,1) * ( sum( fl.S1(:,:, t)  .* repmat(X1,1, pa.num), 1 ))'  + ...
                pa.mu_K(1,2) * ( sum( fl.S2(:,:, t) .* repmat(X2, 1, pa.num) , 1  ))' ) ...
                ./ (pa.k0 .* p.r(:, t-1) );
     
        end
        
        difw_H = max(   (p.w_Hh(:, t)- nw_Hh).^2  ) ;
        difw_L = max(  (p.w_Lh(:, t)- nw_Lh).^2 ) ;
        difr = max(  (p.r_h(:, t)- nr_h).^2  ) ;
        dif = max( [difw_H, difw_L, difr]  );
        
        smooth = 0.8 + rand * 0.2;
        p.w_Hh(:, t) = smooth * nw_Hh + (1-smooth) * p.w_Hh(:, t);
        p.w_Lh(:, t) = smooth * nw_Lh + (1-smooth) * p.w_Lh(:, t);
        p.r_h(:, t) = smooth * nr_h + (1-smooth) * p.r_h(:, t);
        
        
    end
    
        
    
end

