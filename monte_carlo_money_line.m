function solvedMoneyLine = monte_carlo_money_line(gamma,factor,balanceError)
% Factor is what multiple you want alpha and beta to be in (like 5 or 10)
% Balance error given in terms of basis points of the total money involved
% Monte Carlo Money Line information added to existing money line

    solvedMoneyLine = ClassicalMoneyLine();
    
    maxProfit = 0;
    for tempAlpha = 50:1000
        for tempBeta = 50:tempAlpha
        
            if (mod(tempAlpha,factor) == 0) && (mod(tempBeta,factor) == 0)
            
                tempPa = 1/(1+100/tempAlpha);
                tempPb = 1/(1+100/tempBeta);
                tempFavoriteProfit = gamma(tempPb) - (100/tempAlpha)*(gamma(1)-gamma(tempPa));
                tempUnderdogProfit = (gamma(1)-gamma(tempPa)) - (tempBeta/100)*gamma(tempPb);
                tempBalance = abs(tempFavoriteProfit - tempUnderdogProfit);
            
                if tempBalance < (balanceError/10000) && max(tempFavoriteProfit,tempUnderdogProfit) > maxProfit
                    maxProfit = max(tempFavoriteProfit,tempUnderdogProfit);
                    alphaMC = int(temp_alpha);
                    betaMC = int(temp_beta);
                    paMC = round(temp_pa,4);
                    pbMC = round(temp_pb,4);
                end
            end
        end
    end
    
    if maxProfit > 0
        solvedMoneyLine.alphaMC = alphaMC;
        solvedMoneyLine.betaMC = betaMC;
        solvedMoneyLine.paMC = round(paMC,4);
        solvedMoneyLine.pbMC = round(pbMC,4);
        solvedMoneyLine.profitMC = round(maxProfit,2);
    end
end