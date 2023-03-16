function P = ini_price(w, r, pa, N, J) 
% solve the initial price
    
    % initial guess
    P = ones(N,J);
    P_new = NaN(N,J);

%     P1 = ones(3,1);
%     P2 = ones(3,1);

    dif = 10;
    iter = 0;
    
    while dif > 1e-3

        iter = iter + 1;

        % cost bundle
        for j = 1:J
            if j == 1
                A = pa.alpha_l(j).^pa.alpha_l(j) .* prod(pa.alpha_m.^pa.alpha_m,2);
                c(:,j) = w(:,j).^pa.alpha_l(j) .* prod(P.^pa.alpha_m,2) ./A./ pa.z_0(:,j);
            else
                A = pa.alpha_l(j).^pa.alpha_l(j) .* pa.alpha_k(j).^pa.alpha_k(j) .* prod(pa.alpha_m.^pa.alpha_m,2);
                c(:,j) = w(:,j).^pa.alpha_l(j) .* r(:,j-1).^pa.alpha_k(j) .* prod(P.^pa.alpha_m,2) ./A./ pa.z_0(:,j);
            end
        end
% 
%         % constant
%         A = pa.alpha_l.^pa.alpha_l .* pa.alpha_k.^pa.alpha_k .* prod(pa.alpha_m.^pa.alpha_m,2);
% 
% %         A1 = pa.alpha_l(1).^pa.alpha_l(1).*pa.alpha_k(1).^pa.alpha_k(1).*pa.alpha_m1(1).^pa.alpha_m1(1).*pa.alpha_m2(1).^pa.alpha_m2(1);
% %         A2 = pa.alpha_l(2).^pa.alpha_l(2).*pa.alpha_k(2).^pa.alpha_k(2).*pa.alpha_m1(2).^pa.alpha_m1(2).*pa.alpha_m2(2).^pa.alpha_m2(2);
%     
%         % unit cost
%         
%         c_m = prod(P.^pa.alpha_m,2); % intermediate good cost N*1
%         c_v = w.^pa.alpha_l'.*r.^pa.alpha_k'; % factor cost N*J
%         c = c_m .* repmat(c_m,1,J)./pa.z_0; % unit cost N*J
% 
% 
% %         c1 = W.^pa.alpha_l(1).*r.^pa.alpha_k(1).*P1.^pa.alpha_m1(1).*P2.^pa.alpha_m2(1)./pa.z1_0;
% %         c2 = W.^pa.alpha_l(2).*r.^pa.alpha_k(2).*P1.^pa.alpha_m1(2).*P2.^pa.alpha_m2(2)./pa.z2_0;

        % update the new price
        for j = 1:J
            c_j = c(:,j);
            a_j = (repmat(c_j',3,1).*pa.tau_0).^(-pa.theta);
            constant = gamma((pa.theta+1-pa.sigma)./pa.theta).^(1./(1-pa.sigma));
            p_j = constant .* sum(a_j,2).^(-1./pa.theta);
            P_new(:,j) = p_j;
        end

%         a1 = (repmat(c1',3,1).*pa.tau_0).^(-pa.theta);
%         a2 = (repmat(c2',3,1).*pa.tau_0).^(-pa.theta);
%         P1_new = sum(a1,2).^(-1./pa.theta);
%         P2_new = sum(a2,2).^(-1./pa.theta);
    
        difference = P_new - P;
        dif = max(abs(difference));

        smooth = .9 * rand + .1;        
        P = smooth .* P_new + (1 - smooth) .* P;
    end

end