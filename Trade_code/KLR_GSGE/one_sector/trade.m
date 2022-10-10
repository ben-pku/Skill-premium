function [p, Q, fl] = trade(p, Q, fl, t, pa)
%TRADE equilibrium conditions
%  Given t, solve w^ and S (t+1) by iteration
    
    % we have guessed w_h t=t
    iter = 0;
    dif = 10;

    while iter<1e4 && dif > 1e-5
        iter = iter + 1;
        numer = ( pa.tau_h(:, :, t+1).* repmat( (p.w_h(:, t+1) ./pa.z_h(:,t+1) .* Q.chi_h( : , t+1).^(pa.mu-1))' , pa.num ,1 )   ) .^(-pa.theta);
        if t == 0
            denom = sum( pa.S .* numer, 2 ) ;
        else
            denom = sum( fl.S(:, :, t) .* numer, 2 ) ;
        end
        fl.S_h(:, :, t+1) = numer ./ repmat(denom , 1, pa.num  ); % trade flow change
        
        if t==0
            fl.S(:, :, t+1) = pa.S .*fl.S_h(:, :, t+1);
        else
            fl.S(:, :, t+1) = fl.S(:, :, t) .*fl.S_h(:, :, t+1);
        end
        
        if t==0
            element = fl.S(:, :, t+1) .* repmat(  p.w0 .* pa.l .* p.w_h( :, t+1) .* Q.l_h( : , t+1) ,1, pa.num );
            b_ele = pa.S .* repmat( p.w0 .* pa.l ,1, pa.num );
        else
            element = fl.S(:, :, t+1) .* repmat(  p.w(:, t) .* Q.l(:, t) .* p.w_h( :, t+1) .* Q.l_h( : , t+1) ,1, pa.num );
            b_ele = fl.S(: , :, t) .* repmat( p.w(:, t) .* Q.l(:, t) ,1, pa.num );
        end
        
        % update wage hat
            neww_h = ( sum( element )./ sum( b_ele ) )' ./ Q.l_h(:, t+1); 
        
        
        dif1 = p.w_h(:, t+1)-neww_h;
        dif = max( abs( dif1./p.w_h(:,t+1) ) );
        
        smooth = .1 + .9*rand; 
        p.w_h( : , t+1) = (1-smooth) *p.w_h( : , t+1) + smooth * neww_h;
        
        % update wage
        if t ==0 
            p.w( : , t+1) = p.w_h( : , t+1) .* p.w0;
        else
            p.w( : , t+1) = p.w_h( : , t+1) .* p.w( : , t);
        end
        
    end

    if iter >= 1e4
        disp("trade fails. \n");
        pause;
    end

end

