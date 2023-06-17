function ClassicalMoneyLine = newtown_iteration_money_line(InputClassicalMoneyLine,money_density,gamma,tolerance)
    ClassicalMoneyLine = InputClassicalMoneyLine;
    
    % Find our initial pa and pb
    pa = .51;
    aTries = 0;
    while abs(money_density(pa)) < .1 && aTries < 1000
        aTries = aTries + 1;
        pa = .5  + .5*rand();
    end
    
    if aTries > 999
        fprintf("This Money Density Function Sucks!")
        return
    end
    
    pb = pa;
    
    
    numIter = 0;
    h = pow(10,-6);
    while max( abs(classical_moneyline_equation1(gamma,palpha,pbeta)), abs(classical_moneyline_equation2(money_density,gamma,palpha,pbeta)) ) > tolerance && numIter < 1000
        [dpa, dpb] = newton_step_2d(classical_moneyline_equation1,classical_moneyline_equation2,pa,pb,h);
        pa = pa + dpa;
        pb = pb + dpb;
        
        % To ensure that the moneyline actually captures bets on both sides
        if abs(gamma(1) - gamma(pa)) < pow(10,-3) || abs(gamma(pb)) < pow(10,-3)
            while abs(money_density(pa)) < .1
                aTries = aTries + 1;
                pa = .5  + .5*rand();
            end
            
            pb = pa;
        end   
    end
    
    if numIter == 1000
        fprintf('Maximum Iterations Reached');
        return 
    end
    
      ClassicalMoneyLine.paNI = round(palpha,4);
      ClassicalMoneyLine.pbNI = round(pbeta,4);
      ClassicalMoneyLine.alphaNI = round(100/(1/pa-1),2);
      ClassicalMoneyLine.betaNI = round(100/(1/pb-1),2);
      ClassicalMoneyLine.profitNI = round( (1-gamma(pa)) - ClassicalMoneyLine.betaNI/100*gamma(pb) ,4);
      
end