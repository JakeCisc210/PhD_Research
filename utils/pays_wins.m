function [Pay1, Pay2, Profit1, Profit2] = pays_wins(P1,P2,MaxBid,F)
% Pay1 - what Player 1 pays into system
% Pay2 - what Player 2 pays into system
% Profit1 - expected profit of Player 1 
% Profit2 - expected profit of Player 2
% P1 - Player 1's guess of probability of event occuring
% P2 - Player 2's guess of probability of event occuring
% MaxBid - Maximum value for Pay1 or Pay2
% F - fee of middle man

    if  P1 >= (1-P2)
        Pay1 = MaxBid;
        Pay2 = (2*MaxBid-F)/(P1+P2) + F - MaxBid;
        Pay2 = round(Pay2,2);
    end

    if  P1 < (1-P2) 
        Pay1 = (2*MaxBid-F)/(2-P1-P2) + F - MaxBid;
        Pay1 = round(Pay1,2);
        Pay2 = MaxBid;
    end

    Profit1 = P1*(Pay1+Pay2-F)-Pay1;
    Profit1 = round(Profit1,2);
    Profit2 = (1-P2)*(Pay1+Pay2-F)-Pay2;
    Profit2 = round(Profit2,2);
end
