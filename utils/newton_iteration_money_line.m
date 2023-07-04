function solvedMoneyLine = newton_iteration_money_line(money_density,gamma,tolerance)
    
    solvedMoneyLine = ClassicalMoneyLine();
    
    % Find our initial pa and pb
    pa = .51;
    aTries = 0;
    while abs(money_density(pa)) < .1 && aTries < 1000
        aTries = aTries + 1; pa = rand();
    end
    if aTries >= 999; error('Money Density Function Too Concentrated'); end
    pb = pa;
    
    % Iteration Time
    numIter = 0;
    h = power(10,-6);
    while max( abs(classical_moneyline_equation1(gamma,pa,pb)), abs(classical_moneyline_equation2(money_density,gamma,pa,pb)) ) > tolerance && numIter < 10000
        f1 = @(var1,var2) classical_moneyline_equation1(gamma,var1,var2);
        f2 = @(var1,var2) classical_moneyline_equation2(money_density,gamma,var1,var2); 
        [dpa, dpb] = newton_step_2d(f1,f2,pa,pb,h);
        pa = pa + dpa;
        pb = pb + dpb;
        
        % To ensure that the moneyline actually captures bets on both sides
        if abs(gamma(1)-gamma(pa)) < power(10,-3) || abs(gamma(pb)) < power(10,-3)
            aTries = 0;
            while abs(money_density(pa)) < .1 && aTries < 1000
                aTries = aTries + 1; pa = rand();            
            end          
            pb = pa;
            if aTries >= 1000; error('Money Density Function Too Concentrated'); end
        end   
        
        numIter = numIter + 1;
    end
    
    if numIter >= 10000; error('Maximum Iterations Reached'); end
    
    solvedMoneyLine.paNI = round(pa,4);
    solvedMoneyLine.pbNI = round(pb,4);
    solvedMoneyLine.alphaNI = round(100/(1/pa-1),2);
    solvedMoneyLine.betaNI = round(100/(1/pb-1),2);
    solvedMoneyLine.profitNI = round((1-gamma(pa))-solvedMoneyLine.betaNI/100*gamma(pb),4);
end