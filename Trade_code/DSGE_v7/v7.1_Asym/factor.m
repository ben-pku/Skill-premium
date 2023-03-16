function new = factor(p, Q, fl, t, pa)
%% FACTOR update new factor prices
% factor market clearing condition
%  find updated wage, and then recover the factor price_h
% we just change the p temporarily, we will store it as another variable in
% temp_e
low1 = Q.oL(:, 1, t) .* p.w_L(:, t).* Q.L(:, t); % num+1
low1 = [low1(1)+low1(2); low1(3: pa.num+1)];
X1 =  low1 +  Q.oH(:, 1, t) .* p.w_H(:, t).* Q.H(:, t) ...
        + Q.oK(:, 1, t) .* Q.E(:, t) ;

low2 = Q.oL(:, 2, t) .* p.w_L(:, t).* Q.L(:, t); % num+1
low2 = [low2(1)+low2(2); low2(3: pa.num+1)];
X2 = low2 +  Q.oH(:, 2, t) .* p.w_H(:, t).* Q.H(:, t) ...
        + Q.oK(:, 2, t).* Q.E(:, t) + Q.I(:, t);

low3 = Q.oL(:, 3, t) .* p.w_L(:, t).* Q.L(:, t); % num+1
low3 = [low3(1)+low3(2); low3(3: pa.num+1)];
X3 = low3 +  Q.oH(:, 3, t) .* p.w_H(:, t).* Q.H(:, t) ...
        + Q.oK(:, 3, t) .* Q.E(:, t) ;

low4 = Q.oL(:, 4, t) .* p.w_L(:, t).* Q.L(:, t); % num+1
low4 = [low4(1)+low4(2); low4(3: pa.num+1)];
X4 = low4 +  Q.oH(:, 4, t) .* p.w_H(:, t).* Q.H(:, t) ...
        + Q.oK(:, 4, t) .* Q.E(:, t) ;

if t ==1 
    new.w_Hh = (  pa.mu_H(2) * sum(fl.S2(:,:,t) .* repmat( X2, 1, pa.num ), 1 )'      ...
                    + pa.mu_H(3) * sum(fl.S3(:,:,t) .* repmat( X3, 1, pa.num ), 1 )'     ...
                    + pa.mu_H(4) * sum(fl.S4(:,:,t) .* repmat( X4, 1, pa.num ), 1 )'   ) ...
                    ./ ( p.w_H0 .* Q.H(:, t)   ); 

    agri_income = [X1(1); 0 ; X1(2:pa.num)]; % num+1
    low_income = pa.mu_L(2) * sum(fl.S2(:,:,t) .* repmat( X2, 1, pa.num ), 1 )'      ...
                    + pa.mu_L(3) * sum(fl.S3(:,:,t) .* repmat( X3, 1, pa.num ), 1 )'     ...
                    + pa.mu_L(4) * sum(fl.S4(:,:,t) .* repmat( X4, 1, pa.num ), 1 )'; % num
    low_income = agri_income + [0; low_income];
    new.w_Lh =  low_income ./ ( p.w_L0 .* Q.L(:, t)   ); 

    new.r_h = ( pa.mu_K(2) * sum(fl.S2(:,:,t) .* repmat( X2, 1, pa.num ), 1 )'      ...
                    + pa.mu_K(3) * sum(fl.S3(:,:,t) .* repmat( X3, 1, pa.num ), 1 )'     ...
                    + pa.mu_K(4) * sum(fl.S4(:,:,t) .* repmat( X4, 1, pa.num ), 1 )'   ) ...
                    ./ ( p.r0 .* Q.k(:, t)   ); 
else
    new.w_Hh = ( pa.mu_H(2) * sum(fl.S2(:,:,t) .* repmat( X2, 1, pa.num ), 1 )'      ...
                    + pa.mu_H(3) * sum(fl.S3(:,:,t) .* repmat( X3, 1, pa.num ), 1 )'     ...
                    + pa.mu_H(4) * sum(fl.S4(:,:,t) .* repmat( X4, 1, pa.num ), 1 )'   ) ...
                    ./ ( p.w_H(:, t-1) .* Q.H(:, t)   ); 

    agri_income = [X1(1); 0 ; X1(2:pa.num)]; % num+1
    low_income = pa.mu_L(2) * sum(fl.S2(:,:,t) .* repmat( X2, 1, pa.num ), 1 )'      ...
                    + pa.mu_L(3) * sum(fl.S3(:,:,t) .* repmat( X3, 1, pa.num ), 1 )'     ...
                    + pa.mu_L(4) * sum(fl.S4(:,:,t) .* repmat( X4, 1, pa.num ), 1 )'; % num
    low_income = agri_income + [0; low_income];
    new.w_Lh =  low_income ./ ( p.w_L(:, t-1) .* Q.L(:, t)   ); 

    new.r_h = (  pa.mu_K(2) * sum(fl.S2(:,:,t) .* repmat( X2, 1, pa.num ), 1 )'      ...
                    + pa.mu_K(3) * sum(fl.S3(:,:,t) .* repmat( X3, 1, pa.num ), 1 )'     ...
                    + pa.mu_K(4) * sum(fl.S4(:,:,t) .* repmat( X4, 1, pa.num ), 1 )'   ) ...
                    ./ ( p.r(:, t-1) .* Q.k(:, t)   ); 
end

% numeraire
numeraire = new.w_Hh(1);
new.w_Hh = new.w_Hh /numeraire;
new.w_Lh = new.w_Lh / numeraire;
new.r_h = new.r_h / numeraire;

end

