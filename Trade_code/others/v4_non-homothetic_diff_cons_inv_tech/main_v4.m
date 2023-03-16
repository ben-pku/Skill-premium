%% note : Model v4 - 3 sector 3 region 2 sector with input-output linkage
% free mobile within areas, 
% wages are the same within area (rural and urban) but are different across areas within regions
% migration cost across areas and regions, 
% rural wage in region 1 is nominaire,
% non-homothetic preference
% consumption goods and investment goods have different technology

% Last Update: 2023.1.1
% Solving for the Sequential Competitive Equilibrium of the Model

clear all; clc;
tic
%% 1. Parameter Setting

N = 3; % region number
O = 2; % area number (urban & rural)
J = 3; % ind number
TT = 300; % period number

pa = parameter_v4(N, O, J, TT);

%% 2. Solve for the sequential competitive equilibrium

R = NaN(N,TT+1);  
R_hat = NaN(N,TT+1);
D = NaN(O*N,O*N,TT+1);
D_hat =NaN(O*N,O*N,TT+1);
L = NaN(N,O,TT+1);
L_hat = NaN(N,O,TT+1);
pop_hat = NaN(N,TT+1);
K = NaN(N,TT+1);
K_hat = NaN(N,TT+1);
P_hat = NaN(N,TT+1);

K(:,1)=pa.k_1;

dif = 10;
iter = 0;

% iteration

% Initial guess

u_hat = ones(N,O,TT+1);
u_hat_new = zeros(N,O,TT+1);

stigma = (1-pa.beta).*ones(3,TT+2);
stigma_new = NaN(3,TT+2);

while dif > 1e-3

    iter = iter + 1;

    %rental rate at t = 1
    R(:,1) = pa.k_1./pa.k_0.*(1-stigma(:,1));
    
    [m,n]=size(pa.D_m1);
    % migration rate
    for tt = 0 : TT
        if tt == 0 % migration rate at t = 0
            for j = 1:O
                u = u_hat(:,:,1)';
                fenmu = repmat(sum(repmat(u(:)',3,1).*pa.D_m1(j:O:m,:)./(pa.kappa_hat_0(j:O:m,:)).^(1/pa.rho),2),1,3);
                for h = 1:O
                    DD = pa.D_m1(j:O:m,h:O:n);
                    KK_hat = pa.kappa_hat_0(j:O:m,h:O:n);
                    UU = u_hat(:,h,tt+1);
                    fenzi = DD.*repmat(UU',3,1)./(KK_hat.^(1/pa.rho));
                    D_0(j:O:m,h:O:n) = fenzi./fenmu;
                end    
            end    
        elseif tt == 1 % migration rate at t = 1
            for j = 1:O
                u = u_hat(:,:,tt+1)';
                fenmu = repmat(sum(repmat(u(:)',3,1).*D_0(j:O:m,:)./(pa.kappa_hat(j:O:m,:,tt)).^(1/pa.rho),2),1,3);
                for h = 1:O
                    DD = D_0(j:O:m,h:O:n);
                    KK_hat = pa.kappa_hat(j:O:m,h:O:n,tt);
                    UU = u_hat(:,h,tt+1);
                    fenzi = DD.*repmat(UU',3,1)./(KK_hat.^(1/pa.rho));
                    D(j:O:m,h:O:n,tt) = fenzi./fenmu;
                end    
            end 
        else % migration rate at t > 1    
            for j = 1:O
                u = u_hat(:,:,tt+1)';
                fenmu = repmat(sum(repmat(u(:)',3,1).*D(j:O:m,:,tt-1)./(pa.kappa_hat(j:O:m,:,tt)).^(1/pa.rho),2),1,3);
                for h = 1:O
                    DD = D(j:O:m,h:O:n,tt-1);
                    KK_hat = pa.kappa_hat(j:O:m,h:O:n,tt);
                    UU = u_hat(:,h,tt+1);
                    fenzi = DD.*repmat(UU',3,1)./(KK_hat.^(1/pa.rho));
                    D(j:O:m,h:O:n,tt) = fenzi./fenmu;
                end    
            end 
        end
    end

    % population
    for tt = 1 : TT+1
        if tt == 1 %population at t = 1
            l = pa.l_0';
            L1 = sum(repmat(l(:),1,6).*D_0,1)';
            L(:,:,tt) = reshape(L1',[2,3])';
            L_hat(:,:,tt) = L(:,:,tt)./pa.l_0;
        else %population at t  1
            l = L(:,:,tt-1)';
            L1 = sum(repmat(l(:),1,6).*D_0,1)';
            L(:,:,tt) = reshape(L1',[2,3])';
            L_hat(:,:,tt) = L(:,:,tt)./L(:,:,tt-1);    
        end
    end
    clear l L1 DD KK_hat UU fenzi fenmu u

    % Solve the initial wage and rental price Given S0 l0 pa
    [w_o_0,r_u_0] = initial(pa.l_0,pa.S_0,stigma,pa,N,O,J);
    w_0 = [w_o_0(:,1), repmat(w_o_0(:,2),1,J-1)];
    r_0 = repmat(r_u_0,1,J-1);
    % solve the initial price of different sector
    p_0 = ini_price(w_0, r_0, pa, N, J) ;
    p_w_0 = price_c(w_o_0,p_0,pa,N,J);
    p_k_0 = price_c(r_u_0.*pa.k_0,p_0,pa,N,J);

    tt = 1;

    % temporary system
    [w_o_hat(:,:,tt), r_u_hat(:,tt)] = temp_eq(L(:,:,tt), K(:,tt), pa.S_0, w_o_0, r_u_0, p_0, stigma, pa, N, O, J, tt);
    w_o(:,:,tt) = w_o_0.*w_o_hat(:,:,tt);
    r_u(:,tt) = r_u_0.*r_u_hat(:,tt);

    % a.1 solve the price hat of different industries
    p_hat(:,:,tt) = price_hat(pa.S_0,w_o_hat(:,:,tt),r_u_hat(:,tt),pa,N,J,tt);
    p(:,:,tt) = p_0.*p_hat(:,:,tt);

    % a.2 solve the trade share hat of different industries
    S_hat(:,:,tt) = trade_share_hat(pa.S_0,w_o_hat(:,:,tt),r_u_hat(:,tt),p_hat(:,:,tt),pa,N,J,tt);
    S(:,:,tt) = pa.S_0.*S_hat(:,:,tt);

    % a.3 solve the investment price
    p1_s = prod((p(:,:,tt)./pa.eta_s').^pa.eta_s',2);
    p1_e = prod((p(:,:,tt)./pa.eta_e').^pa.eta_e',2);
    p_x(:,tt) = (p1_s./pa.nu(1)).^pa.nu(1).*(p1_e./pa.nu(2)).^pa.nu(2)./50;

    % a.4 solve the consumption price of workers
    p_w(:,:,tt) = price_c(w_o(:,:,tt),p(:,:,tt),pa,N,J);
    p_k(:,tt) = price_c(r_u(:,tt).*K(:,tt),p(:,:,tt),pa,N,J);
    p_w_hat(:,:,tt) = p_w(:,:,tt) ./ p_w_0;
    p_k_hat(:,tt) = p_k(:,tt) ./ p_k_0;

    % capital return
    R(:,tt) = 1 - pa.delta + r_u(:,tt)./p_x(:,tt);

    % update the new capital at tt = 2
    K(:,tt+1)=(1-stigma(:,tt+1)).*R(:,tt).*K(:,tt);

    for tt = 2:TT+1
        % temporary system
        [w_o_hat(:,:,tt), r_u_hat(:,tt)] = temp_eq(L(:,:,tt), K(:,tt), S(:,:,tt-1), w_o(:,:,tt-1), r_u(:,tt-1), p(:,:,tt-1), stigma, pa, N, O, J, tt);
        w_o(:,:,tt) = w_o(:,:,tt-1).*w_o_hat(:,:,tt);
        r_u(:,tt) = r_u(:,tt-1).*r_u_hat(:,tt);
    
        % a.1 solve the price hat of different industries
        p_hat(:,:,tt) = price_hat(S(:,:,tt-1),w_o_hat(:,:,tt),r_u_hat(:,tt),pa,N,J,tt);
        p(:,:,tt) = p(:,:,tt-1).*p_hat(:,:,tt);
    
        % a.2 solve the trade share hat of different industries
        S_hat(:,:,tt) = trade_share_hat(S(:,:,tt-1),w_o_hat(:,:,tt),r_u_hat(:,tt),p_hat(:,:,tt),pa,N,J,tt);
        S(:,:,tt) = S(:,:,tt-1).*S_hat(:,:,tt);
    
        % a.3 solve the investment price
        p1_s = prod((p(:,:,tt)./pa.eta_s').^pa.eta_s',2);
        p1_e = prod((p(:,:,tt)./pa.eta_e').^pa.eta_e',2);
        p_x(:,tt) = (p1_s./pa.nu(1)).^pa.nu(1).*(p1_e./pa.nu(2)).^pa.nu(2)./50;

        % a.4 solve the consumption price of workers
        p_w(:,:,tt) = price_c(w_o(:,:,tt),p(:,:,tt),pa,N,J);
        p_k(:,tt) = price_c(r_u(:,tt).*K(:,tt),p(:,:,tt),pa,N,J);
        p_w_hat(:,:,tt) = p_w(:,:,tt) ./ p_w(:,:,tt-1);
        p_k_hat(:,tt) = p_k(:,tt) ./ p_k(:,tt-1);
    
        % a.5 capital return
        R(:,tt) = 1 - pa.delta + r_u(:,tt)./p_x(:,tt);
    
        % a.6 update the new capital at tt = 2
        K(:,tt+1)=(1-stigma(:,tt+1)).*R(:,tt).*K(:,tt); 
    end

    %solve backwards for utility
    for tt=linspace(TT,1,TT)
        if tt > 1
            for j = 1:O
                if j == 1
                    u = u_hat(:,:,tt+1)';
                    a = (pa.b_hat(:,tt).*w_o_hat(:,j,tt)./p_w_hat(:,j,tt)).^(pa.beta./pa.rho);
                    b = (sum(repmat(u(:)',3,1).*D(j:O:m,:,tt-1)./(pa.kappa_hat(j:O:m,:,tt)).^(1/pa.rho),2)).^pa.beta;
                    u_hat_new(:,j,tt) = a.*b;
                elseif j == 2
                    u = u_hat(:,:,tt+1)';
                    a = (pa.b_hat(:,tt).*w_o_hat(:,j,tt)./p_w_hat(:,j,tt)).^(pa.beta./pa.rho);
                    b = (sum(repmat(u(:)',3,1).*D(j:O:m,:,tt-1)./(pa.kappa_hat(j:O:m,:,tt)).^(1/pa.rho),2)).^pa.beta;
                    u_hat_new(:,j,tt) = a.*b;
                end
            end
        else    
            for j = 1:O
                if j == 1
                    u = u_hat(:,:,tt+1)';
                    a = (pa.b_hat(:,tt).*w_o_hat(:,j,tt)./p_w_hat(:,j,tt)).^(pa.beta./pa.rho);
                    b = (sum(repmat(u(:)',3,1).*D_0(j:O:m,:)./(pa.kappa_hat(j:O:m,:,tt)).^(1/pa.rho),2)).^pa.beta;
                    u_hat_new(:,j,tt) = a.*b;
                elseif j == 2
                    u = u_hat(:,:,tt+1)';
                    a = (pa.b_hat(:,tt).*w_o_hat(:,j,tt)./p_w_hat(:,j,tt)).^(pa.beta./pa.rho);
                    b = (sum(repmat(u(:)',3,1).*D_0(j:O:m,:)./(pa.kappa_hat(j:O:m,:,tt)).^(1/pa.rho),2)).^pa.beta;
                    u_hat_new(:,j,tt) = a.*b;
                end
            end
        end
    end
    u_hat_new(:,TT+1) = 1;

    %solve backwards for stigma
    R(:,TT+1) = 1./pa.beta;
    for tt = linspace(TT,1,TT)   
        stigma_new(:,TT+2) = 1-pa.beta.^pa.phi.*R(:,TT+1).^(pa.phi-1); 
        stigma_new(:,TT+1) = 1-pa.beta.^pa.phi.*R(:,TT+1).^(pa.phi-1); 
        stigma_new(:,tt)=stigma_new(:,tt+1)./(stigma_new(:,tt+1)+pa.beta.^pa.phi.*(R(:,tt+1).*p_x(:,tt+1)./p_x(:,tt)./p_k_hat(:,tt+1)).^(pa.phi-1));
    end   

    vfactor = -0.05;
    zw1 =  u_hat - u_hat_new;
    zw2 = stigma - stigma_new;
    adj1 = u_hat .* (1 + vfactor*zw1./u_hat );
    adj2 = stigma .* (1 + vfactor*zw2 ./ stigma);
    dif =  max(max(abs([u_hat(:);stigma(:)] - [adj1(:);adj2(:)])));

    % update the new u_hat and stigma
    u_hat = adj1;
    stigma = adj2;

%     difference = ([u_hat(:);stigma(:)] - [u_hat_new(:);stigma_new(:)]);
%     dif = max(max(abs(difference)));
% 
%     smooth = .9 * rand + .1;
%     u_hat = smooth .* u_hat_new + (1 - smooth) .* u_hat;
%     stigma = smooth .* stigma_new + (1 - smooth) .* stigma; 

    disp("the iteration number and difference are: ")
    disp([iter,dif])
end
disp("iteration succeesed")
toc

%% Functions



