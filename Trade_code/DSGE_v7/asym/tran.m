function [p, Q, fl] = tran(pa)
%TRAN solve the transitional path 
% Given initial trade and migration matices,  solve the transitional path
% input
% pa -struct, parameters for all of the model
% output
% p -prices country * time
% Q - quantities country * time
% flow -probability matices country * country * time

%% 1 guess the paths of u, sigma
Q.u_Hh = repmat(logspace(log10(2), 0,  pa.T+1 ), pa.num , 1);
Q.u_Lh = repmat(logspace(log10(2), 0,  pa.T+1 ), pa.num , 1);
Q.sigma = (1-pa.beta)/(1+pa.beta*(pa.delta-1)) * ones(pa.num, pa.T+1); % t=1 ~T+1
Q.sigma0 = (1-pa.beta)/(1+pa.beta*(pa.delta-1)) * ones(pa.num, 1) ;
% create other variables
Q.k = NaN(pa.num,pa.T+1);
fl.D_H = NaN(pa.num, pa.num, pa.T+1);
fl.D_Hh = NaN(pa.num , pa.num , pa.T+1);
fl.D_L = NaN(pa.num, pa.num, pa.T+1);
fl.D_Lh = NaN(pa.num , pa.num , pa.T+1);
p.r0 = NaN(pa.num,1);

flag = 1; % nonnegative value
iter = 0;
dif = 10;
tol = 1e-7;
maxit = 1e4;
for iter = 1: maxit
    if flag==0
        disp('negative');
        break
    end
    if dif < tol
        break
    end
   %% 2 get migration rates
   for t = 0: pa.T
       if t == 0
            numer = repmat( Q.u_Hh(:, t+2), 1, pa.num)./( pa.kappa_h(:,:,t+1).^(1/pa.rho) ) ;
            denom = sum( pa.D_H' .* numer, 1 ); % 1* pa.num
            fl.D_Hh( :, :, t+1) = (numer./ repmat(denom, pa.num , 1) )';
            fl.D_H(:, :, t+1) =  fl.D_Hh( :, :, t+1) .* pa.D_H;

            numer = repmat( Q.u_Lh(:, t+2), 1, pa.num)./( pa.kappa_h(:,:,t+1).^(1/pa.rho) ) ;
            denom = sum( pa.D_L' .* numer, 1 ); % 1* pa.num
            fl.D_Lh( :, :, t+1) = (numer./ repmat(denom, pa.num , 1) )';
            fl.D_L(:, :, t+1) =  fl.D_Lh( :, :, t+1) .* pa.D_L;

       elseif t<pa.T
            numer = repmat( Q.u_Hh(:, t+2), 1, pa.num)./( pa.kappa_h(:,:,t+1).^(1/pa.rho) ) ;
            denom = sum( pa.D_H' .* numer, 1 ); % 1* pa.num
            fl.D_Hh( :, :, t+1) = (numer./ repmat(denom, pa.num , 1) )';
            fl.D_H(:, :, t+1) =  fl.D_Hh( :, :, t+1) .* fl.D_H(:, :, t);

            numer = repmat( Q.u_Lh(:, t+2), 1, pa.num)./( pa.kappa_h(:,:,t+1).^(1/pa.rho) ) ;
            denom = sum( pa.D_L' .* numer, 1 ); % 1* pa.num
            fl.D_Lh( :, :, t+1) = (numer./ repmat(denom, pa.num , 1) )';
            fl.D_L(:, :, t+1) =  fl.D_Lh( :, :, t+1) .* fl.D_L(:, :, t);
       else
            numer = repmat( ones(pa.num,1), 1, pa.num) ./ pa.kappa_h(:, : , t+1).^(1/pa.rho);
            denom = sum(fl.D_H( :, :, t)' .* numer , 1); % 1* pa.num
            fl.D_Hh( :, :, t+1) =  ( numer./ repmat(denom, pa.num , 1) )';
            fl.D_H(:, :, t+1) = fl.D_Hh( :, :, t+1) .* fl.D_H( :, :, t);           
            
            numer = repmat( ones(pa.num,1), 1, pa.num) ./ pa.kappa_h(:, : , t+1).^(1/pa.rho);
            denom = sum(fl.D_L( :, :, t)' .* numer , 1); % 1* pa.num
            fl.D_Lh( :, :, t+1) =  ( numer./ repmat(denom, pa.num , 1) )';
            fl.D_L(:, :, t+1) = fl.D_Lh( :, :, t+1) .* fl.D_L( :, :, t);    
       end


   end

   % population H, L
    Q.L = NaN( pa.num, pa.T+1);
    Q.H = NaN( pa.num, pa.T+1);
     for  t = 1: pa.T+1
            if t == 1
                Q.L(:, t) = (fl.D_L(:, :, t) )' * pa.L;
                Q.H(:, t) = (fl.D_H(:, :, t) )' * pa.H;
            else
                Q.L(:, t) = (fl.D_L(: ,: , t) )' * Q.L(:, t-1);
                Q.H(:, t) = (fl.D_H(: ,: , t) )' * Q.H(:, t-1);
            end
     end

     %% 3 solve initial equilibrium (t=0)
    [p, Q] = ini_equi(p, Q, pa, iter);
    % 3e capital stock (t=1)
    Q.k(:, 1) = Q.I0 ./ p.p2_0 + (1- pa.delta) * pa.k0;

    %% 4 temporary equilibrium (t=1,...,T+1)
    p.uc_h1 = NaN(pa.num, pa.T+1); % agri
    p.uc_h2 = NaN(pa.num, pa.T+1); % manu
    p.uc_h3 = NaN(pa.num, pa.T+1);  % l_S
    p.uc_h4 = NaN(pa.num, pa.T+1);  % h_S
    p.w_Hh = [NaN(1, pa.T+1); 
                        ones(pa.num-1,pa.T+1)] ;  % guess the w_Hh
    p.w_Lh = ones(pa.num,pa.T+1) ; % guess the w_Lh
    p.r_h = [NaN(1, pa.T+1); 
                        ones(pa.num-1,pa.T+1)] ; % guess the r_h
    p.w_H = NaN(pa.num,pa.T+1) ;
    p.w_L = NaN(pa.num,pa.T+1) ;
    p.r = NaN(pa.num,pa.T+1) ;
    p.p_h1 = NaN(pa.num,pa.T+1)  ; % agri
    p.p_h2 = NaN(pa.num,pa.T+1)  ; % manu
    p.p_h3 = NaN(pa.num,pa.T+1)  ; % l_S
    p.p_h4 = NaN(pa.num,pa.T+1)  ; % h_S
    p.p1 = NaN(pa.num,pa.T+1)  ; % agri
    p.p2 = NaN(pa.num,pa.T+1)  ; % manu
    p.p3 = NaN(pa.num,pa.T+1)  ; % l_S
    p.p4 = NaN(pa.num,pa.T+1)  ; % h_S
    fl.S1 = NaN(pa.num, pa.num, pa.T+1);    
    fl.S1_h = NaN(pa.num, pa.num, pa.T+1);
    fl.S2 = NaN(pa.num, pa.num, pa.T+1);
    fl.S2_h = NaN(pa.num, pa.num, pa.T+1);
    fl.S3 = NaN(pa.num, pa.num, pa.T+1);
    fl.S3_h = NaN(pa.num, pa.num, pa.T+1);
    fl.S4 = NaN(pa.num, pa.num, pa.T+1);
    fl.S4_h = NaN(pa.num, pa.num, pa.T+1);

    Q.E = NaN(pa.num, pa.T+1); % expenditure
    Q.I = NaN(pa.num, pa.T+1); % investment expenditure
    Q.oL = NaN(pa.num, pa.sec, pa.T+1); % expenditure share of lowskill
    Q.oH = NaN(pa.num, pa.sec, pa.T+1); % high worker
    Q.oK = NaN(pa.num, pa.sec, pa.T+1); % landlord

    for t = 1 : pa.T+1
        [p, Q, fl] = temp_e(p, Q, fl, t, pa);
    end



    
end




end

