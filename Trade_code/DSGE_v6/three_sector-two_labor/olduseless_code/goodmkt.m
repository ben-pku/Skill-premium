function y = goodmkt(w, S, l, pa)
%GOODMKT apply good market clearing condition to solve the wage 
    %wl = \sum S' wl
    
    y = w.*l - S' * (w.*l);
    


end

