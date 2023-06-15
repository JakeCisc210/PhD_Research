function [WinsWith1,MasonPays,ZackPays,Winnings,Fee,ExpectedProfit] = peer_to_peer(Pm,Pz,MaxBid,Percent)
% WinsWith1 - which Player wins if the Binary Event is 1
% MasonPays - what Mason pays into system
% ZackPays - what Zack pays into system
% Winnings - what the winner gets if the Binary Event is their desired outcome
% Fee - fee charged by central party
% ExpectedProfit - expected profit of both Players 
% Pm - Mason's guess of probability of event occuring
% Pz - Zack's guess of probability of event occuring
% MaxBid - Maximum value for MasonPays or ZackPays
% Percent - Fee as percentage of ExpectedProfit (in decimal form)
    
    if Pm > Pz
       WinsWith1 = "Mason";
       Fee = percent_fee_funct(Pm,Pz,MaxBid,Percent);
       [MasonPays, ZackPays, Profitm, Profitz] = pays_wins(Pm,Pz,MaxBid,Fee);
       Winnings = MasonPays + ZackPays - Fee;
       if abs(Profitm - Profitz) < max(.001*MaxBid,.02)
           ExpectedProfit = Profitm;
       else
           fprintf("Unequal profits");
       end   
    end
    
    if Pm < Pz
       WinsWith1 = "Zack";
       Fee = percent_fee_funct(Pz,Pm,MaxBid,Percent);
       [ZackPays, MasonPays, Profitz, Profitm] = pays_wins(Pz,Pm,MaxBid,Fee);
       Winnings = MasonPays + ZackPays - Fee;
       if abs(Profitm - Profitz) < max(.001*MaxBid,.02)
           ExpectedProfit = Profitm;
       else
           fprintf("Unequal profits");
       end
    end
    
    if Pm == Pz
       WinsWith1 = "Mason";
       Fee = 0;
       MasonPays = MaxBid;
       ZackPays = MaxBid;
       Winnings = 2*MaxBid;
       ExpectedProfit = 0;
    end 
end
