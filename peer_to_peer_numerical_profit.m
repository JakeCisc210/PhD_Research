function profit = peer_to_peer_numerical_profit(funct,functMax,x,numParticipants)
    arguments
        funct = @(p) exp(-power(p-.5)/2/power(.1,2)) / sqrt(2*pi) / .1;
        functMax = 1/  sqrt(2*pi) / .1;
        x = 2;
        numParticipants = 1000;
    end
    
    for 1:numParticipants
    end
    

    [WinsWith1,MasonPays,ZackPays,Winnings,Fee,ExpectedProfit] = peer_to_peer(Pm,Pz,MaxBid,Percent)