function solvedMoneyLine = monte_carlo_money_line(gamma,factor,balanceError)
% Factor is what multiple you want alpha and beta to be in (like 5 or 10)
% Balance error given in terms of basis points of the total money involved
% Monte Carlo Money Line information added to existing money line

    arguments
        gamma = @(p) double_stunted_gaussian_gamma(p,.4,.15);
        factor = 1;
        balanceError = 10;
    end
    
    solvedMoneyLine = ClassicalMoneyLine();
    
    profitMax = 0;
    minConstraint = 1;
    alphaMesh = 100:factor:1000; betaMesh = 50:factor:1000;
    
    for ii = 1:length(alphaMesh)
        alphaTemp = alphaMesh(ii);
        for jj = 1:length(betaMesh)
            betaTemp = betaMesh(jj);
            
            palphaTemp = alphaTemp/(alphaTemp+100); pbetaTemp = betaTemp/(betaTemp+100); 
            profitValue = monte_carlo_profit(gamma,palphaTemp,pbetaTemp);
            constraintValue = abs(monte_carlo_constraint(gamma,palphaTemp,pbetaTemp));
            
            minConstraint = min(minConstraint,constraintValue);
            
            if constraintValue < (balanceError/10000) && profitValue > profitMax
                profitMax = profitValue;
                alphaMC = fix(alphaTemp);
                betaMC = fix(betaTemp);
                palphaMC = round(palphaTemp,4);
                pbetaMC = round(pbetaTemp,4);        
            end

        end
    end

    if profitMax > 0
        solvedMoneyLine.alphaMC = alphaMC;
        solvedMoneyLine.betaMC = betaMC;
        solvedMoneyLine.palphaMC = round(palphaMC,4);
        solvedMoneyLine.pbetaMC = round(pbetaMC,4);
        solvedMoneyLine.profitMC = round(profitMax,2);
    end
end