function profit = peer_to_peer_theoretical_system_utility(inverse_gamma,system_micro_utility,strategy,x,opt)
    arguments
        inverse_gamma = @(d) sqrt(2)*.1*erfinv(2*erf(sqrt(2))*(d-1/2)) + .5;
        system_micro_utility =  @(vLow,vHigh,x) x*(vHigh-vLow) / ( max(vLow+vHigh,2-vLow-vHigh) + x*max(vHigh,1-vLow) );
        strategy = 'Mixed';
        x = 2;
        opt.switchOverPoint = 1/4;
    end
    
    function localProfit = outside_in(fun,system_micro_utility,ex,d)
        pGreat = fun(1-d);
        pLess = fun(d); 
        localProfit = system_micro_utility(pLess,pGreat,ex);
    end

    function localProfit = split_n_pair(fun,system_micro_utility,ex,d)
        pGreat = fun(1/4+d); % Note the +1/4, was 1/2 by error I believe
        pLess = fun(d); 
        localProfit = system_micro_utility(pLess,pGreat,ex);
    end
    
    integrandPart1 = @(d) outside_in(inverse_gamma,system_micro_utility,x,d);
    integrandPart2 = @(d) split_n_pair(inverse_gamma,system_micro_utility,x,d);
        
    switch strategy
        case 'Outside In'
            profit = integral(integrandPart1,0,1/2,'ArrayValued',true);
        case 'Split n Pair'
            profit = integral(integrandPart2,0,1/2,'ArrayValued',true);
        case 'Mixed'    
            assert(opt.switchOverPoint <= .5 & opt.switchOverPoint >= 0,'Improper Switch Over Point')
            profit = integral(integrandPart1,0,opt.switchOverPoint,'ArrayValued',true) + integral(integrandPart2,opt.switchOverPoint,1/2,'ArrayValued',true);
        otherwise
            error('Improper Strategy')        
    end
end
   
