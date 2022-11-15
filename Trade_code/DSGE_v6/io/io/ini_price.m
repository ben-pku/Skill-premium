function p = ini_price(p, pa, iter0)
%INI_PRICE solve the initial factor price 
% solve the initial factor price : w_H, w_L, r (absolute level, t=0) ,
% given S0, L0, H0, k0
    
% guess the three prices first ( if iter0 >1, then apply last solution as
% the guessing price
    if iter0==1
        p.w_L0 = 0.6 * ones( pa.num, 1) ;
        p.r0 = ones( pa.num, 1) ;
%         p.p1_0 = ones( pa.num, 1) ;
%         p.p2_0 = ones( pa.num, 1) ;
    end

% solve the fixed point by iteration
    iter = 0;
    dif = 10;
    tol =1e-3;
    while dif >tol && iter < 1e4
        iter = iter +1;

%         [Y1, Y2] = production(pa.L, pa.k0, p.w_L0, p.r0, p.p1_0, p.p2_0 , pa.S1, pa.S2, pa);
% 
%         X1 = pa.gamma(1) * (p.w_L0 .* pa.L + p.r0.* pa.k0 + p.p1_0.*Y1 + p.p2_0.*Y2) ;
%         X2 = pa.gamma(2) * (p.w_L0 .* pa.L + p.r0.* pa.k0 + p.p1_0.*Y1 + p.p2_0.*Y2) ;

        [X1, X2] = expenditure(pa.L, pa.k0, p.w_L0, p.r0, pa.S1, pa.S2, pa);
             
        nw_L0 = ( pa.mu_L(1,1) * ( sum( pa.S1 .* repmat(X1,1, pa.num), 1 ))'  + ...
            pa.mu_L(1,2) * ( sum( pa.S2 .* repmat(X2, 1, pa.num) , 1  ))' ) ...
            ./ pa.L;
        
        nr0 = ( pa.mu_K(1,1) * ( sum( pa.S1 .* repmat(X1,1, pa.num), 1 ))'  + ...
            pa.mu_K(1,2) * ( sum( pa.S2 .* repmat(X2, 1, pa.num) , 1  ))' ) ...
            ./ pa.k0;

%         np1 = ( pa.mu_m1(1,1) * ( sum( pa.S1 .* repmat(X1,1, pa.num), 1 ))'  + ...
%             pa.mu_m1(1,2) * ( sum( pa.S2 .* repmat(X2, 1, pa.num) , 1  ))' ) ...
%             ./ Y1;
%         
%         np2 = ( pa.mu_m2(1,1) * ( sum( pa.S1 .* repmat(X1,1, pa.num), 1 ))'  + ...
%             pa.mu_m2(1,2) * ( sum( pa.S2 .* repmat(X2, 1, pa.num) , 1  ))' ) ...
%             ./ Y2;
        
        % numeraire
        numer = nw_L0(2);
        nw_L0 = nw_L0/numer;
        nr0 = nr0 /numer;
%         np1 = np1 /numer;
%         np2 = np2 /numer;
     
        % update
        difw_L = max( abs( (p.w_L0- nw_L0)./nw_L0 ) ) ;
        difr = max( abs( (p.r0- nr0)./nr0 ) ) ;
%         difp1 = max( abs( (p.p1_0- np1) ) ) ;
%         difp2 = max( abs( (p.p2_0- np2)) ) ;
        dif = max([difw_L, difr] );
        
        smooth = .9 + rand * .1;
        p.w_L0 = smooth * nw_L0 + (1-smooth) * p.w_L0;
        p.r0 = smooth * nr0 + (1-smooth) * p.r0;
%         p.p1_0 = smooth * np1 + (1-smooth) * p.p1_0;
%         p.p2_0 = smooth * np2 + (1-smooth) * p.p2_0;
%         
        
    end
    

end

