function PercentFee = percent_fee_funct(P1,P2,MaxBid,Percent)
% P1 - Player 1's guess of probability of event occuring
% P2 - Player 2's guess of probability of event occuring
% MaxBid - Maximum value for Pay1 or Pay2
% Percent - Percent of Profits the Fee is

% Note: P1 > P2 
    [Pay1, Pay2, Profit1, Profit2] = pays_wins(P1,P2,MaxBid,0);
    
    if Pay1 == MaxBid
        PercentFee = Percent*(MaxBid*P1-MaxBid*P2)/(P1+Percent*P1+P2);
    end
    
    if Pay2 == MaxBid
        PercentFee = Percent*(MaxBid*P2-MaxBid*P1)/(P1+Percent*P2+P2-2-Percent);
    end
    
    PercentFee = round(PercentFee,4);
end