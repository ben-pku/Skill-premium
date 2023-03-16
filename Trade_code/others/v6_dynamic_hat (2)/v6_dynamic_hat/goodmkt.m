function py = goodmkt(S, pa, N, J)

% initial guess
py = ones(J,N);
py_new = zeros(J,N);
iter = 0;
dif = 10;

while dif > 1e-3

    iter = iter + 1;

    for j = 1:J
        gamma = pa.gamma(j);
        alpha_m = pa.alpha_m(:,j);
        alpha_l = pa.alpha_l;
        alpha_k = pa.alpha_k;
        cons = gamma .* (alpha_l + alpha_k) + alpha_m;
        S_j = S(:,1+(j-1)*N : N+(j-1)*N);
        right = sum(cons .* py * S_j,1);
        py_new(j,:) = right;
    end

    dif = max(max(abs(py_new - py)));
    py = 0.5 * py + 0.5 * py_new;

end




end