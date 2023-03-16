function [w_o_hat, r_u_hat] = temp_eq(L_1, K_1, S_0, w_o, r_u, pa, N, O, J, tt)

    % initial guess
    w_o_hat = 1.5*ones(N,O);
    r_u_hat = ones(N,1);

    dif = 10;
    iter = 0;

    while dif > 5e-3

        iter = iter + 1;
        
        w1_o = w_o.*w_o_hat;
        r1_u = r_u.*r_u_hat;

        % a.1 solve the price hat of different industries
        p_hat = price_hat(S_0,w_o_hat,r_u_hat,pa,N,J,tt);

        % a.2 solve the trade share hat of different industries
        S_hat = trade_share_hat(S_0,w_o_hat,r_u_hat,p_hat,pa,N,J,tt);
        S1 = S_0.*S_hat;

        % a.3 solve the total income
        py = goodmkt(S1, pa, N, J);
        
        % normalize py such that wage in region 1 ind 1 is equal to 1
        py = py ./ py(1,1) .* L_1(1,1);
        
        % total income of different areas
        py_r = py(1,:);
        py_u = sum(py(2:J,:),1);
        
        % initial wage and rental rate
        w1_o_new(:,1) = py_r' ./ L_1(:,1);
        w1_o_new(:,2) = py_u' ./ L_1(:,2);
        r1_u_new = py_u' ./ K_1;

        w_o_hat_new = w1_o_new./w_o;
        r_u_hat_new = r1_u_new./r_u;

%         % nomolization
%         numer = w_o_hat_new(1);
%         w_o_hat_new = w_o_hat_new ./ numer;
%         r_u_hat_new = r_u_hat_new ./ numer; 

%         vfactor = -0.05;
%         zw1 =  w_o_hat - w_o_hat_new;
%         zw2 = r_u_hat - r_u_hat_new;
%         adj1 = w_o_hat .* (1 + vfactor*zw1./w_o_hat );
%         adj2 = r_u_hat .* (1 + vfactor*zw2 ./ r_u_hat);
%         dif =  max(max(abs([w_o_hat,r_u_hat] - [adj1,adj2])));
%         % update the new u_hat and stigma
%         w_o_hat = adj1;
%         r_u_hat = adj2;
    
        difference = ([w_o_hat_new,r_u_hat_new]-[w_o_hat,r_u_hat])./[w_o_hat,r_u_hat];
        dif = max(max(abs(difference)));

        smooth = .9 * rand + .1;
        w_o_hat = smooth .* w_o_hat_new + (1 - smooth) .* w_o_hat;
        r_u_hat = smooth .* r_u_hat_new + (1 - smooth) .* r_u_hat; 

% 
% %         % unit cost
% %         c1 = W_hat.^pa.alpha_l(1).*R_hat.^pa.alpha_k(1).*P1_hat.^pa.alpha_m1(1).*P2_hat.^pa.alpha_m2(1)./pa.z1_hat(:,tt);
% %         c2 = W_hat.^pa.alpha_l(2).*R_hat.^pa.alpha_k(2).*P1_hat.^pa.alpha_m1(2).*P2_hat.^pa.alpha_m2(2)./pa.z2_hat(:,tt);
% %         
% %         % trade share change
% %         fenzi1 = (pa.tau_hat(:,:,tt).*repmat(c1',3,1)).^(-pa.theta);
% %         fenzi2 = (pa.tau_hat(:,:,tt).*repmat(c2',3,1)).^(-pa.theta);
% %         S1_hat=fenzi1./repmat(sum(S1_0.*fenzi1,2),1,3);
% %         S2_hat=fenzi2./repmat(sum(S2_0.*fenzi2,2),1,3);
% %         S1_1=S1_0.*S1_hat; 
% %         S2_1=S2_0.*S2_hat; 
% %     
% %         % price change
% %         a1 = S1_0.*(repmat(c1',3,1).*pa.tau_hat(:,:,tt)).^(-pa.theta);
% %         a2 = S2_0.*(repmat(c2',3,1).*pa.tau_hat(:,:,tt)).^(-pa.theta);
% %         P1_hat_new = sum(a1,2).^(-1./pa.theta);
% %         P2_hat_new = sum(a2,2).^(-1./pa.theta);   
%         
%         % given P1_hat P2_hat W1_hat W2_hat R1_hat R2_hat S1_new S2_new
%         W_1 = W_0.*W_hat;
%         R_1 = R_0.*R_hat;
%         P1_1 = P1_0.*P1_hat_new;
%         P2_1 = P2_0.*P2_hat_new;
%     
%         [X1, X2] = expenditure(L_1, K_1, W_1, R_1, S1_1, S2_1, pa);
% 
% %         % use W_new R_new P1_new P2_new S1_new S2_new to solve production of both sector
% %         [Y1, Y2] = production(L_1, K_1, W_1, R_1, P1_1, P2_1, S1_1, S2_1, pa);  
% %     
% %         % solve the new W and R
% %         X1 = pa.gamma1.*(W_1.*L_1 + R_1.*K_1) + pa.alpha_m1(1).*P1_1.*Y1 + pa.alpha_m2(1).*P2_1.*Y2;
% %         X2 = pa.gamma2.*(W_1.*L_1 + R_1.*K_1) + pa.alpha_m1(2).*P1_1.*Y1 + pa.alpha_m2(2).*P2_1.*Y2;
%     
%         a1 = sum(repmat(X1,1,3).*S1_1,1)';
%         a2 = sum(repmat(X2,1,3).*S2_1,1)';
%     
%         W_1 = (pa.alpha_l(1).*a1 + pa.alpha_l(2).*a2)./L_1;
%         R_1 = (pa.alpha_k(1).*a1 + pa.alpha_k(2).*a2)./K_1;
% 
%         W_hat_new = W_1./W_0;
%         R_hat_new = R_1./R_0;

  

%         if iter==1e4
%             disp("temp_eq.m Fails to solve the time-t equilibrium (t) -- reach max iter");
%             pause;
%         end
    end

        

end