function p = ini_price(p, pa, iter0)
%INI_PRICE solve the initial factor price 
% solve the initial factor price : w_H, w_L, r (absolute level, t=0) ,
% given S0, L0, H0, k0
    
% guess the three prices first ( if iter0 >1, then apply last solution as
% the guessing price
    if iter0==1
        p.w_H0 = 1.4 * ones( pa.num, 1) ;
        p.w_L0 =  ones( pa.num, 1) ;
        p.r0 = ones( pa.num, 1) ;
    end

% solve the fixed point by iteration
    iter = 0;
    dif = 10;
    tol =1e-7;
    while dif >tol && iter < 1e4
        iter = iter +1;
        X1 = pa.gamma(1,1) * (p.w_H0 .* pa.H + p.w_L0 .* pa.L + p.r0.* pa.k0) ;
        X2 = pa.gamma(1,2) * (p.w_H0 .* pa.H + p.w_L0 .* pa.L + p.r0.* pa.k0) ;
        X3 = pa.gamma(1,3) * (p.w_H0 .* pa.H + p.w_L0 .* pa.L + p.r0.* pa.k0) ;
        
        nw_H0 = ( pa.mu_H(1,1) *  sum( pa.S1 .* repmat(X1,1, pa.num), 1 )'  + ...
            pa.mu_H(1,2) *  sum( pa.S2 .* repmat(X2, 1, pa.num) , 1  )' +  ...
            pa.mu_H(1,3) *  sum( pa.S3 .* repmat(X3, 1, pa.num) , 1  )'     ) ...
            ./ pa.H;
        
        nw_L0 = ( pa.mu_L(1,1) *  sum( pa.S1 .* repmat(X1,1, pa.num), 1 )'  + ...
            pa.mu_L(1,2) *  sum( pa.S2 .* repmat(X2, 1, pa.num) , 1  )' + ...
            pa.mu_L(1,3) *  sum( pa.S3 .* repmat(X3, 1, pa.num) , 1  )'         ) ...
            ./ pa.L;
        
        nr0 = ( pa.mu_K(1,1) *  sum( pa.S1 .* repmat(X1,1, pa.num), 1 )'  + ...
            pa.mu_K(1,2) *  sum( pa.S2 .* repmat(X2, 1, pa.num) , 1  )' + ...
            pa.mu_K(1,3) *  sum( pa.S3 .* repmat(X3, 1, pa.num) , 1  )'    ) ...
            ./ pa.k0;
        
        % numeraire
        numer = nw_L0(2);
        nw_H0 = nw_H0 /numer;
        nw_L0 = nw_L0/numer;
        nr0 = nr0 /numer;
     
        % update
        difw_H = max( abs(  (p.w_H0- nw_H0) ) ) ;
        difw_L = max( abs( (p.w_L0- nw_L0) ) ) ;
        difr = max( abs( (p.r0- nr0)) ) ;
        dif = max([difw_H, difw_L, difr] );
        
        smooth = 1;% .9 + rand * .1;
        p.w_H0 = smooth * nw_H0 + (1-smooth) * p.w_H0;
        p.w_L0 = smooth * nw_L0 + (1-smooth) * p.w_L0;
        p.r0 = smooth * nr0 + (1-smooth) * p.r0;
        
        
    end
    

end

