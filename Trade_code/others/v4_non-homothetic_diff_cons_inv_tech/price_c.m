function p_w = price_c(I,p,pa,N,J)

    p_a = p(:,1);
    p_na = prod((p(:,2:J)./pa.gamma).^pa.gamma, 2);

    constant = pa.xi.^pa.xi.*(1-pa.xi).^(1-pa.xi);
    agr = (I./p_a-pa.Lambda_a+pa.Lambda_na.*p_na./p_a);
    sz = size(agr);
    for n = 1:sz(1)*sz(2)
        if agr(n) < 0
            agr(n) = 0.0001;
        end
    end
    nag = (I./p_na-pa.Lambda_a.*p_a./p_na+pa.Lambda_na);
    for n = 1:sz(1)*sz(2)
        if nag(n) < 0
            nag(n) = 0.0001;
        end
    end
    p_w = 0.1.*I./agr.^pa.xi./nag.^(1-pa.xi);

end