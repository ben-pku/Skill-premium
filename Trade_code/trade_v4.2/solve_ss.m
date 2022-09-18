function [p, Q, para] = solve_ss(para)
%% SOLVE_SS solve steady state
% solve steady state of the trade model with given parameters
% guess the w_l w_h r together and then update them together

    %% 1 guess the w_l, w_h
    p.w_l = 1e-3 * ones(para.num, 1);
    p.w_l = p.w_l ./ sum(p.w_l.*para.L);  % numeraire
    
    
    p.w_h = 1.5 * p.w_l;
    
    iter = 0;
    dif = 10;
    
    while dif > 1e-8 && iter <1e6
        iter = iter + 1;
        %% 2 solve r, p_m and other price indexes
        p = ss_price(p, para);

        %% 3 solve C, consumption
            [p, Q] = ss_C(p, para);

         %% solve quantity
         
            % agriculture
            % H1
            Q.Ca = para.Omega_a * (p.p_a./Q.E).^(-para.sigma) .* ( (Q.C./Q.D).^(para.eps_a) .*Q.D  ).^(1-para.sigma);           
            Q.L_a = (1-para.alpha1) * Q.Ca .*  (para.A_a .* p.p_a ./p.w_l).^(para.rho);           
            Q.YA = Q.Ca;
            
            % low skill service
            % H1
            Q.Csl = para.Omega_sl * (p.p_sl./Q.E).^(-para.sigma) .* ( (Q.C./Q.D).^(para.eps_sl) .*Q.D  ).^(1-para.sigma);
            Q.Ysl = Q.Csl ;
            Q.H_l = (1-para.alpha_l) * ( para.A_l .* p.p_sl./p.w_h ).^(para.chi_l) .*Q.Csl ;
            Q.o_l = (para.alpha_l) * ( para.A_l .* p.p_sl./p.p_ol ).^(para.chi_l) .*Q.Csl ;
            Q.L_l = (1-para.alpha1) * (p.p_ol./p.w_l).^para.rho .* Q.o_l;

            % high skill service 
            %H1
            Q.Csh = para.Omega_sh * (p.p_sh./Q.E).^(-para.sigma) .* ( (Q.C./Q.D).^(para.eps_sh) .*Q.D  ).^(1-para.sigma);
            Q.H_h = (1-para.alpha_h) * ( para.A_h .* p.p_sh./p.w_h ).^(para.chi_h) .*Q.Csh ;
            Q.o_h = (para.alpha_h) * ( para.A_h .* p.p_sh./p.p_oh ).^(para.chi_h) .*Q.Csh ;
            Q.L_h = (1-para.alpha1) * (p.p_oh./p.w_l).^para.rho .* Q.o_h;
            Q.Ysh = Q.Csh;

            % manufacturing 
            % H1
            Q.Cm = para.Omega_m * (p.p_m./Q.E).^(-para.sigma) .* ( (Q.C./Q.D).^(para.eps_m) .*Q.D  ).^(1-para.sigma);
            % unskilled labor mkt clearing 
            Q.L_m = para.L - Q.L_h - Q.L_l - Q.L_a;
            Q.h = (p.w_l./p.p_h).^para.rho .* Q.L_m /(1-para.alpha1) ;
            Q.H_m = (1-para.beta2)/para.beta2 * Q.h .* (p.p_h./p.w_h) .^para.phi;
            Q.s = Q.H_m .* ( p.w_h./p.p_s ).^para.phi /(1-para.beta2);
            Q.M = (1-para.tau)/para.tau * (p.p_s./p.p_m).^para.eta  .*Q.s;
           

            %% update w_h
            % 
            omega = 1e-1; 
            neww_h = p.w_h .* (1+ omega * (Q.H_m + Q.H_h + Q.H_l -para.H) ./ para.H );
            dif_w_h =  max(max( abs(  (neww_h - p.w_h)./ p.w_h)  ) ); 
            smooth = .2*rand + .8;
            p.w_h = smooth*neww_h + (1-smooth)*p.w_h;
            

            % 2 for verification
           
            Q.i = para.delta * Q.K;
            % 20
            Q.YM = Q.M + Q.Cm + Q.i;
            
            %  calculate the trade flow
            [p, Q] = trade_flow(p, Q, para);

            % gross spending on each sector
            Spnd_m = p.p_m .* (Q.YM);

            % gross output
            Sales_m = repmat(Spnd_m, 1, para.num ) .* Q.pi;
            Q.Y_m = (sum(Sales_m, 1))' ./p.p_m;
%             % verify the Y_m
%             Q.Ym = Q.M ./ (1-para.v_m);


            % trade deficit
            Q.F = Spnd_m - p.p_m .* Q.Y_m;
            
            %% update w_l
            % using trade balance condition
            % excess demand
            Zl = - Q.F ./p.w_l;
            % update unskilled wages
            phi = 1e-1;
            neww_l = p.w_l .* (1+ phi* Zl./para.L);

            %unit =sum( neww_l .* para.L)

            dif_w_l =  max(max( abs( (neww_l-p.w_l)./p.w_l  )  )  ) ;

            smooth = 0.2*rand + 0.8;
            p.w_l = smooth* neww_l + (1- smooth)* p.w_l;
            
            dif = max(dif_w_h, dif_w_l);
            
    end
    
       
    if iter >=10000
        disp('solve_ss fails to solve the steady state.');
     end
    
end
