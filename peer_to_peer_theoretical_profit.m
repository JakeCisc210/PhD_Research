function profit = peer_to_peer_theoretical_profit(funct,x)
    arguments
        funct = @(d) sqrt(2)*.1*erfinv(2*erf(sqrt(2))*(d-1/2)) + .5;
        x = 2;
    end
    
    function localProfit = outside_in(fun,ex,d)  
        pGreat = fun(1-d);
        pLess = fun(d); pDiff = pGreat-pLess; pSum = pGreat+pLess;
        
        numerator = ex*pDiff;
        denominator = max(pSum,2-pSum)+ex*max(pGreat,1-pLess);
        localProfit = numerator/denominator;
    end

    function localProfit = split_n_pair(fun,ex,d)  
        pGreat = fun(1/4+d); % Note the +1/4, was 1/2 by error I believe
        pLess = fun(d); pDiff = pGreat-pLess; pSum = pGreat+pLess;
        
        numerator = ex*pDiff;
        denominator = max(pSum,2-pSum)+ex*max(pGreat,1-pLess);
        localProfit = numerator/denominator;
    end

    integrandPart1 = @(d) outside_in(funct,x,d);
    integrandPart2 = @(d) split_n_pair(funct,x,d);

    profit = integral(integrandPart1,0,1/4,'ArrayValued',true) + integral(integrandPart2,1/4,1/2,'ArrayValued',true);
end
   
